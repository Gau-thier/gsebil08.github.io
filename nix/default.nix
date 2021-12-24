{ sources ? import ./sources.nix }:

import sources.nixpkgs {
  # Following line is mandatory for colima as the MIT license is not free.
  # config.allowUnfree = true;
  #  Package ‘colima’ in /Users/GAUTHIER/Documents/workspace/projects/one-catalog/nix/custom/colima.nix:21 has an unfree license (‘unfree mit’), refusing to evaluate.
  #
  #  a) To temporarily allow unfree packages, you can use an environment variable
  #     for a single invocation of the nix tools.
  #
  #       $ export NIXPKGS_ALLOW_UNFREE=1
  #
  #  b) For `nixos-rebuild` you can set
  #    { nixpkgs.config.allowUnfree = true; }
  #  in configuration.nix to override this.
  #
  #  Alternatively you can configure a predicate to allow specific packages:
  #    { nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #        "colima"
  #      ];
  #    }
  #
  #  c) For `nix-env`, `nix-build`, `nix-shell` or any other Nix command you can add
  #    { allowUnfree = true; }
  #  to ~/.config/nixpkgs/config.nix.
}
