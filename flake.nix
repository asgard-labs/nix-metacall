{

  description = "metacall packaged with nix";

  inputs.nixpkgs.url = github:nixos/nixpkgs/nixos-23.11;

  inputs.metacall-core.url = github:metacall/core;
  inputs.metacall-core.flake = false;

  outputs = inputs:

    let

      system = "x86_64-linux";

      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ overlay ];
      };

      overlay = final: prev: {

        nodejs-lib = prev.nodejs.overrideAttrs (old: {
          configureFlags = old.configureFlags ++ [ "--shared" ];
        });

        metacall-core = final.callPackage ./default.nix {

          src-metacall-core = inputs.metacall-core;

          nodejs-pkgs = (import ./pkgs/node-pkgs/default.nix {
            inherit system;
            pkgs = final;
            nodejs = final.nodejs-lib;
          }).package;

        };

      };

    in
      {

        # inherit pkgs inputs;

        # inherit (pkgs) metacall-core;

        packages.${system}.default = pkgs.metacall-core;

        apps.${system} = pkgs.callPackage ./apps {
          src-metacall-core = inputs.metacall-core;
        };

      };
  
}
