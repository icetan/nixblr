#!/usr/bin/env bash
set -euo pipefail

runtime=$(command -v podman 2>/dev/null || true)
runtime=${runtime:-$(command -v docker 2>/dev/null)}

NIXBLR_IMAGE="${NIXBLR_IMAGE:-nixblr}"
NIXBLR_VOLUME="${NIXBLR_VOLUME:-nixblr-store}"

options=(
    --rm
    -it
    -w /workspace
    -v "$PWD":/workspace
    -v "$NIXBLR_VOLUME":/nix
    -e AWS_EC2_METADATA_DISABLED=true
)

$runtime run "${options[@]}" "$NIXBLR_IMAGE" "$@"
