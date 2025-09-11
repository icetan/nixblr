# nixblr A Minimal Nix Docker Image

## Build Images

```sh
scripts/build.sh
```

## Update nixpkgs

The script `scripts/update-nixpkgs.sh` can be used to create a nix expression with a
pointer to the latest revision of a specific branch from the
<https://github.com/nixos/nixpkgs> repo.

```text
Usage: update-nixpkgs.sh [<branch>] [<commit>]
```

## Find specific package versions

Go to https://www.nixhub.io/ to find which `nixpkgs` `commit` hash to use
for a specific version of a package.

## Pushing images

```sh
podman load < nixblr-arm64.tar.gz
podman manifest create nixblr:multi \
  nixblr:linux-amd64 \
  nixblr:linux-arm64
podman manifest inspect nixblr:multi
podman manifest push nixblr:multi docker.io/icetan/nixblr:latest
podman manifest push nixblr:multi docker.io/icetan/nixblr:x.x.x
```
