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
