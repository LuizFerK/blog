{
  description = "Blog Flake";
  inputs = {
    nixpkgs = {url = "github:NixOS/nixpkgs/nixos-23.05";};
    flake-utils = {url = "github:numtide/flake-utils";};
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      inherit (pkgs.lib) optional optionals;
      pkgs = import nixpkgs {inherit system;};

      beamPkg = pkgs.beam.packagesWith pkgs.erlangR26;
      elixir = beamPkg.elixir_1_15;

      shellHook = ''
        # this allows mix to work on the local directory
        mkdir -p .nix-mix
        mkdir -p .nix-hex

        export MIX_HOME=$PWD/.nix-mix
        export HEX_HOME=$PWD/.nix-hex
        export PATH=$MIX_HOME/bin:$PATH
        export PATH=$HEX_HOME/bin:$PATH
        export LANG=en_US.UTF-8
        export ERL_AFLAGS="-kernel shell_history enabled"

        # Go to the user $SHELL
        $SHELL
      '';

      elixirBuildInputs = with pkgs;
        [
          elixir
          elixir_ls
          glibcLocales
          pre-commit
        ]
        ++ optional stdenv.isLinux inotify-tools
        ++ optional stdenv.isDarwin terminal-notifier
        ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
          CoreFoundation
          CoreServices
        ]);
    in
      with pkgs; {
        formatter = nixpkgs.legacyPackages.${system}.alejandra;

        devShells.default = pkgs.mkShell {
          shellHook = shellHook;
          buildInputs = elixirBuildInputs;
        };
      });
}
