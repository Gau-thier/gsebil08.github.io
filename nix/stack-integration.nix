# Provide Nix / NixOS support by expressing system packages required, rather than manually having to install stuff
# Inspired by https://docs.haskellstack.org/en/stable/nix_integration/#using-a-custom-shellnix-file
{ ghc, nixpkgs ? import ./default.nix { } }:

with nixpkgs;

haskell.lib.buildStackProject {
  inherit ghc;
  name = "gauthiersblog";
  buildInputs = [ zlib ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks;
      [
        Cocoa
      ]); # got this fix from https://github.com/idris-lang/Idris-dev/pull/2938/files#diff-e0da5783c1ce24f57c3ea722cabf95a25c828bbea59a60a177885da2e1fa59ddR14
}
