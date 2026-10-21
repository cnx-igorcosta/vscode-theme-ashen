#!/usr/bin/env bash
# Sobe o stack local da Conexa
set -euo pipefail

readonly PORTAS=(8080 8081 3000)
readonly RAIZ="${HOME}/dev"
LOG_DIR="${RAIZ}/.logs"

liberar_portas() {
  local porta
  for porta in "${PORTAS[@]}"; do
    if pid=$(lsof -ti ":${porta}" 2>/dev/null); then
      echo "Liberando porta ${porta} (pid ${pid})..." >&2
      kill -9 "${pid}" || true
    fi
  done
}

subir() {
  local nome="$1" dir="$2" cmd="$3"
  mkdir -p "${LOG_DIR}"
  ( cd "${dir}" && eval "${cmd}" ) >"${LOG_DIR}/${nome}.log" 2>&1 &
  printf 'Subindo %-12s -> %s\n' "${nome}" "${LOG_DIR}/${nome}.log"
}

main() {
  liberar_portas
  subir "backoffice-v2" "${RAIZ}/front-conexa-backoffice-v2" "npm run dev"
  wait
}

main "$@"
