#!/usr/bin/env bash

set -euo pipefail

terraform_version="${1:-}"
if [[ ! "${terraform_version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Usage: $0 <terraform-version>" >&2
  exit 2
fi

case "$(uname -m)" in
  x86_64|amd64) terraform_arch="amd64" ;;
  aarch64|arm64) terraform_arch="arm64" ;;
  *)
    echo "Unsupported Terraform agent architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

if [[ -z "${AGENT_TOOLSDIRECTORY:-}" ]]; then
  echo "AGENT_TOOLSDIRECTORY is not set; run this script from an Azure Pipelines agent." >&2
  exit 1
fi

install_dir="${AGENT_TOOLSDIRECTORY}/terraform/${terraform_version}"
if [[ -x "${install_dir}/terraform" ]]; then
  echo "Terraform ${terraform_version} is already installed at ${install_dir}."
else
  archive="terraform_${terraform_version}_linux_${terraform_arch}.zip"
  release_url="https://releases.hashicorp.com/terraform/${terraform_version}"
  temp_dir="$(mktemp -d)"
  trap 'rm -rf "${temp_dir}"' EXIT

  curl --fail --silent --show-error --location "${release_url}/${archive}" --output "${temp_dir}/${archive}"
  curl --fail --silent --show-error --location "${release_url}/terraform_${terraform_version}_SHA256SUMS" --output "${temp_dir}/SHA256SUMS"
  (cd "${temp_dir}" && grep " ${archive}$" SHA256SUMS | sha256sum --check --status)

  mkdir -p "${install_dir}"
  unzip -q "${temp_dir}/${archive}" -d "${install_dir}"
  chmod +x "${install_dir}/terraform"
fi

echo "##vso[task.prependpath]${install_dir}"
"${install_dir}/terraform" version
