#!/usr/bin/env bash
set -euo pipefail

runtime=$(command -v podman 2>/dev/null || true)
runtime=${runtime:-$(command -v docker 2>/dev/null)}
kernel=$(uname --kernel-name)
kernel=${kernel,,}
machine=$(uname --machine)

case ${machine,,} in
  x86_64) arch=amd64;;
  aarch64) arch=arm64;;
esac

scriptRoot=$(cd "$(dirname "$0")" && pwd)
source "$scriptRoot/../meta.env"

(cd "$scriptRoot/.."

#docker load < "$(nix-build --no-out-link)"

$runtime build ./nix \
  -t "$IMAGE_NAME":_temp \
  -t "$IMAGE_NAME":"$kernel-$arch" \
  --platform="$kernel/$arch"
trap '$runtime image rm -f "$IMAGE_NAME:_temp"' EXIT

if [[ -z $arch ]]; then
  echo >&2 "Skipping build of LD image, machine '$machine' not supported"
  exit 0
fi
$runtime build -f ./nix/Dockerfile.with-ld ./nix \
  --build-arg "KERNEL=$kernel" \
  --build-arg "MACHINE=$machine" \
  -t "$IMAGE_LD_NAME":"$kernel-$arch" \
  --platform="$kernel/$arch"
)
