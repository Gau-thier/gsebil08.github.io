let

  # Must be the same as the Stack resolver we use!
  ghcCompiler = "ghc8106";

  # By default, all functions/values come fron Nixpkgs
in
with import nix/default.nix { };
mkShell {

  # Useful packages, you can manually use `nix-shell` to get a shell with everything configured, or even better, install `nix-direnv`, see `.envrc`
  buildInputs = [

    
    stack

    # Development tools #
    # Formatter
    ormolu
    # Code suggestions
    hlint

    # Nix formatter
    nixfmt

  ];

}