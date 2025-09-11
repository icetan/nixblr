#!/usr/bin/env bash
set -euo pipefail

scriptRoot=$(cd "$(dirname "$0")" && pwd)
source "$scriptRoot/../meta.env"

IMAGE_NAME=${1:-$IMAGE_NAME}
MANIFEST_NAME="$IMAGE_NAME":multi

(cd "$scriptRoot/.."
set -x

podman load -i "$IMAGE_NAME-arm64.tar.gz"

podman manifest rm --ignore "$MANIFEST_NAME"
podman manifest create "$MANIFEST_NAME" \
  "$IMAGE_NAME":linux-amd64 \
  "$IMAGE_NAME":linux-arm64

podman manifest inspect "$MANIFEST_NAME"
) >&2

echo "podman manifest push '$MANIFEST_NAME' 'docker.io/icetan/$IMAGE_NAME:latest'"
echo "podman manifest push '$MANIFEST_NAME' 'docker.io/icetan/$IMAGE_NAME:$VERSION'"
