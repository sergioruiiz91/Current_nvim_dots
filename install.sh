#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="$(basename "$0")"

log() {
  printf '[%s] %s\n' "$SCRIPT_NAME" "$*"
}

die() {
  printf '[%s] ERROR: %s\n' "$SCRIPT_NAME" "$*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_packages() {
  local package_manager="$1"
  shift

  case "$package_manager" in
    apt-get)
      log "Actualizando índices de paquetes..."
      "${SUDO[@]}" apt-get update
      DEBIAN_FRONTEND=noninteractive "${SUDO[@]}" apt-get install -y "$@"
      ;;
    dnf)
      "${SUDO[@]}" dnf install -y "$@"
      ;;
    pacman)
      "${SUDO[@]}" pacman -Sy --needed --noconfirm "$@"
      ;;
    apk)
      "${SUDO[@]}" apk add "$@"
      ;;
    brew)
      brew install "$@"
      ;;
    *)
      die "No sé instalar paquetes automáticamente en este sistema."
      ;;
  esac
}

configure_sudo() {
  if [[ "${EUID}" -eq 0 || "$package_manager" == "brew" ]]; then
    SUDO=()
  elif command_exists sudo; then
    SUDO=(sudo)
  else
    die "Faltan dependencias y no existe sudo. Ejecuta este script como root o instala sudo."
  fi
}

package_manager=""
if command_exists apt-get; then
  package_manager="apt-get"
elif command_exists dnf; then
  package_manager="dnf"
elif command_exists pacman; then
  package_manager="pacman"
elif command_exists apk; then
  package_manager="apk"
elif command_exists brew; then
  package_manager="brew"
fi

missing=()
for command in nvim git node npm Rscript chromium; do
  if ! command_exists "$command"; then
    missing+=("$command")
  fi
done

if ((${#missing[@]} > 0)); then
  [[ -n "$package_manager" ]] || die "Faltan comandos (${missing[*]}) y no hay un gestor de paquetes compatible."
  configure_sudo

  case "$package_manager" in
    apt-get)
      install_packages "$package_manager" neovim git nodejs npm r-base r-cran-languageserver \
        build-essential libxml2-dev libcurl4-openssl-dev libssl-dev chromium
      ;;
    dnf)
      install_packages "$package_manager" neovim git nodejs npm R gcc gcc-c++ make \
        libxml2-devel libcurl-devel openssl-devel chromium
      ;;
    pacman)
      install_packages "$package_manager" neovim git nodejs npm r base-devel libxml2 \
        curl openssl chromium
      ;;
    apk)
      install_packages "$package_manager" neovim git nodejs npm R build-base libxml2-dev \
        curl-dev openssl-dev chromium
      ;;
    brew)
      install_packages "$package_manager" neovim git node r
      brew list --cask chromium >/dev/null 2>&1 || brew install --cask chromium
      ;;
  esac
fi

for command in nvim git node npm Rscript chromium; do
  command_exists "$command" || die "No se pudo instalar el comando requerido: $command"
done

if ! Rscript --vanilla -e 'quit(status = !requireNamespace("languageserver", quietly = TRUE))'; then
  if [[ -n "$package_manager" ]]; then
    configure_sudo
    case "$package_manager" in
      apt-get)
        install_packages "$package_manager" build-essential libxml2-dev libcurl4-openssl-dev libssl-dev
        ;;
      dnf)
        install_packages "$package_manager" gcc gcc-c++ make libxml2-devel libcurl-devel openssl-devel
        ;;
      pacman)
        install_packages "$package_manager" base-devel libxml2 curl openssl
        ;;
      apk)
        install_packages "$package_manager" build-base libxml2-dev curl-dev openssl-dev
        ;;
    esac
  fi
fi

if [[ -z "${R_LIBS_USER:-}" ]]; then
  R_LIBS_USER="$(Rscript --vanilla -e 'cat(path.expand(Sys.getenv("R_LIBS_USER")))')"
fi
readonly R_LIBS_USER
mkdir -p "$R_LIBS_USER"
log "Comprobando el paquete R languageserver..."
R_LIBS_USER="$R_LIBS_USER" Rscript --vanilla -e '
  if (!requireNamespace("languageserver", quietly = TRUE)) {
    install.packages("languageserver", repos = "https://cloud.r-project.org")
  }
  if (!requireNamespace("languageserver", quietly = TRUE)) {
    stop("No se pudo instalar el paquete R languageserver")
  }
'

log "Sincronizando plugins..."
nvim --headless '+Lazy! sync' '+qa'
log "Construyendo markdown-preview.nvim..."
nvim --headless '+Lazy! build markdown-preview.nvim' '+qa'
log "Instalación completada."
