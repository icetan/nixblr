FROM docker.io/icetan/nixblr AS builder

RUN --mount=type=cache,target=/nix,sharing=locked,id=nix_cache nix-build --expr '\
with import (builtins.fetchTarball {url="https://github.com/nixos/nixpkgs/archive/ad4e6dd68c30bc8bd1860a27bc6f0c485bd7f3b6.tar.gz";sha256="0xwh4ly8nzvmgzx236235dhr5xdkpb4w33dsw378z3fkrjh507rf";}) {}; \
let\
  libtorrent-rakshasa = pkgsStatic.libtorrent-rakshasa.overrideAttrs (old: { \
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ pkgsStatic.curl ]; \
  }); \
in \
pkgsStatic.rtorrent.override { inherit libtorrent-rakshasa; }' \
&&  cp result/bin/rtorrent /out/rtorrent \
&&  chmod +x /out/rtorrent


FROM docker.io/alpine

COPY --from=builder /out/rtorrent /usr/bin/rtorrent
ENTRYPOINT ["rtorrent"]
