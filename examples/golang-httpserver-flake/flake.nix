# syntax = ghcr.io/reproducible-containers/buildkit-nix:v0.1.1@sha256:7d4c42a5c6baea2b21145589afa85e0862625e6779c89488987266b85e088021

{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # See https://ryantm.github.io/nixpkgs/languages-frameworks/go/
        app = pkgs.buildGoModule {
          name = "golang-httpserver";
          src = ./.;
          vendorSha256 = "FdDIvZrvGFHk7aqjLtJsiqsIHM6lob9iNPLd7ITau7o=";
          runVend = true;
        };
      in rec {
        defaultPackage = pkgs.dockerTools.buildImage {
          name = "golang-httpserver";
          tag = "nix";
          contents = [ pkgs.bash pkgs.coreutils app ];
          config = {
            Cmd = [ "golang-httpserver" ];
            ExposedPorts = { "80/tcp" = { }; };
          };
        };
      });
}
