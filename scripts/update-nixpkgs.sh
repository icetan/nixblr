#!/usr/bin/env bash
set -eo pipefail

readonly scriptRoot=$(cd "$(dirname "$0")" && pwd)
readonly etcNixPath="$scriptRoot/../nix/root/etc/nix"

NIXPKGS_BRANCH="${NIXPKGS_BRANCH:-nixpkgs-unstable}"
NIXPKGS_BRANCH="${1:-$NIXPKGS_BRANCH}"

gitRev="$2"
if [[ -z "$gitRev" ]]; then
  gitDir=$(mktemp -d)
  cleanup() {
    rm -rf "$gitDir"
  }
  trap "trap - EXIT; cleanup" EXIT

  git clone -b "$NIXPKGS_BRANCH" --depth 1 --single-branch https://github.com/nixos/nixpkgs "$gitDir"
  gitRev=$(cd "$gitDir" && git rev-parse HEAD)
fi

tarballUrl="https://github.com/nixos/nixpkgs/archive/${gitRev}.tar.gz"
sha256=$(nix-prefetch-url --unpack "$tarballUrl")
exprs="fetchTarball {url=\"$tarballUrl\";sha256=\"$sha256\";}"
storePath=$(nix-instantiate --eval -E "(import ($exprs) {}).path")
narHash=$(nix hash path "$storePath")

echo >&2 "Updating nixpkgs.nix and registry.json"

cat > "$etcNixPath/nixpkgs.nix" <<EOF
# Generated $(date +'%Y-%m-%d %H:%M') from https://github.com/nixos/nixpkgs on branch $NIXPKGS_BRANCH
import ($exprs)
EOF

cat > "$etcNixPath/registry.json" <<EOF
{
  "flakes": [
    {
      "exact": true,
      "from": {
        "id": "nixpkgs",
        "type": "indirect"
      },
      "to": {
        "lastModified": 0,
        "type": "tarball",
        "url": "$tarballUrl",
        "narHash": "$narHash"
      }
    }
  ],
  "version": 2
}
EOF
