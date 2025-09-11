FROM docker.io/nixpkgs/nix AS builder

COPY ./default.nix .
RUN nix-build
RUN mkdir -p /out \
&&  cp --no-preserve=all result/bin/nix /out/nix \
&&  chmod +x /out/nix


FROM docker.io/alpine

COPY ./root/etc/nix /etc/nix
COPY --from=builder /out/nix /bin/nix

RUN addgroup -g 30000 nixbld \
&&  adduser -D -G nixbld nixbld \
&&  ln -s /bin/nix /bin/nix-build \
&&  ln -s /bin/nix /bin/nix-channel \
&&  ln -s /bin/nix /bin/nix-collect-garbage \
&&  ln -s /bin/nix /bin/nix-copy-closure \
&&  ln -s /bin/nix /bin/nix-daemon \
&&  ln -s /bin/nix /bin/nix-env \
&&  ln -s /bin/nix /bin/nix-hash \
&&  ln -s /bin/nix /bin/nix-instantiate \
&&  ln -s /bin/nix /bin/nix-prefetch-url \
&&  ln -s /bin/nix /bin/nix-shell \
&&  ln -s /bin/nix /bin/nix-store \
&&  mkdir /out \
\
&&  mkdir -p /home /nix/store /nix/var/log /nix/var/nix/build \
&&  chown nixbld:nixbld /nix /nix/var /nix/var/log /nix/var/nix/build
# &&  chmod 777 /nix/store #/home /etc/nix
# &&  chmod 666 /etc/nix/*

ENV NIX_PATH=nixpkgs=/etc/nix/nixpkgs.nix
