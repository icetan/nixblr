{
  system ? builtins.currentSystem,
  nix ? import (
    builtins.fetchTarball {
      url = "https://github.com/nixos/nix/archive/2.31.1.tar.gz";
      sha256 = "sha256:0iqz73qqb91as3y7i9cxn29q4k922vlfa99nnmg0vjafxyx9gcd7";
    }
  ),
}:
nix.hydraJobs.buildStatic.nix-cli.${system}
