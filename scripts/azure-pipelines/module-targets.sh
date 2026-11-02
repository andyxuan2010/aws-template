#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $0 detect-files --input <changed-files> --format <ado-matrix|json-array>" >&2
}

command="${1:-}"
shift || true
if [[ "${command}" != "detect-files" ]]; then
  usage
  exit 2
fi

input_file=""
format=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --input)
      input_file="${2:-}"
      shift 2
      ;;
    --format)
      format="${2:-}"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ -z "${input_file}" || ! -f "${input_file}" || -z "${format}" ]]; then
  usage
  exit 2
fi

mapfile -t all_modules < <(find modules -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
if [[ "${#all_modules[@]}" -eq 0 ]]; then
  echo "No modules found under modules/." >&2
  exit 1
fi

for module in "${all_modules[@]}"; do
  if [[ ! "${module}" =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo "Invalid module directory name '${module}'; use lowercase letters, digits, and underscores, starting with a letter." >&2
    exit 1
  fi
done

declare -A known_modules=()
declare -A selected_modules=()
for module in "${all_modules[@]}"; do
  known_modules["${module}"]=1
done

run_all=false
while IFS= read -r changed_file; do
  [[ -z "${changed_file}" ]] && continue
  changed_file="${changed_file#./}"

  case "${changed_file}" in
    modules/*)
      module_name="${changed_file#modules/}"
      if [[ "${module_name}" != */* ]]; then
        run_all=true
      else
        module_name="${module_name%%/*}"
        if [[ -n "${known_modules[${module_name}]:-}" ]]; then
          selected_modules["${module_name}"]=1
        else
          # A removed module or a shared modules-level change affects the catalog.
          run_all=true
        fi
      fi
      ;;
    examples/* | scripts/* | .github/workflows/terraform.yml | azure-pipelines.yml | \
    .tflint.hcl | .terraform-docs.yml | *.tf | *.tfvars)
      run_all=true
      ;;
  esac
done < "${input_file}"

if [[ "${run_all}" == "true" ]]; then
  selected_modules=()
  for module in "${all_modules[@]}"; do
    selected_modules["${module}"]=1
  done
fi

modules=()
for module in "${all_modules[@]}"; do
  if [[ -n "${selected_modules[${module}]:-}" ]]; then
    modules+=("${module}")
  fi
done

case "${format}" in
  json-array)
    printf '['
    separator=""
    for module in "${modules[@]}"; do
      printf '%s"%s"' "${separator}" "${module}"
      separator=,
    done
    printf ']\n'
    ;;
  ado-matrix)
    printf '{'
    separator=""
    for module in "${modules[@]}"; do
      printf '%s"%s":{"moduleName":"%s"}' "${separator}" "${module}" "${module}"
      separator=,
    done
    printf '}\n'
    ;;
  *)
    echo "Unknown format: ${format}" >&2
    usage
    exit 2
    ;;
esac
