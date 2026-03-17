{
  description = "Generated Terraform provider for Akeyless";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.runCommand "terraform-akeyless-gen" {
          src = self;
        } ''
          mkdir -p $out/share/terraform
          cp -r $src/resources $out/share/terraform/ 2>/dev/null || true
          cp -r $src/provider $out/share/terraform/ 2>/dev/null || true
          touch $out/share/terraform/.generated
        '';

        # When go.mod exists, replace with:
        # packages.default = pkgs.buildGoModule {
        #   pname = "terraform-provider-akeyless";
        #   version = "0.1.0";
        #   src = self;
        #   vendorHash = null; # update after first build
        # };
      }
    );
}
