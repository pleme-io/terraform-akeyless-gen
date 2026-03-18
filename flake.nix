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

        # Basic artifact check. Deep validation runs via iac-verify in the
        # aggregate repo (akeyless-terraform-resources).
        checks.default = pkgs.runCommand "check-terraform-gen" { src = self; } ''
          cd $src
          count=$(find . -name '*.go' -not -path './.git/*' | wc -l | tr -d ' ')
          if [ "$count" -eq 0 ]; then echo "FAIL: no Go files found"; exit 1; fi
          echo "OK: $count Go files found"
          mkdir -p $out && echo "$count files" > $out/result.txt
        '';
      }
    );
}
