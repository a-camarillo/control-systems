{
  description = "Control Systems";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = inputs@{ flake-parts, ... }: 
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }:
        {
          devShells = {
            default = pkgs.mkShell {
              packages = [
                (pkgs.python311.withPackages(ps:[
                  ps.numpy
                  ps.scipy
                  ps.matplotlib
                  ps.jupyter
                  (ps.buildPythonPackage rec {
                    pname = "control";
                    version = "0.9.4";
                    pyproject = true;
                    src = ps.fetchPypi {
                      inherit pname version;
                      sha256 = "sha256-D6V9Iha3rE6TOcCeq2gnZgMYpkF3kzWGT+7pQL0Zyc4=";
                    };
                    doCheck = false;
                    propagatedBuildInputs = [
                      ps.setuptools
                      ps.setuptools-scm
                      ps.wheel
                      ps.numpy
                      ps.scipy
                      ps.matplotlib
                    ];
                  })
                ]))
              ];  
            };
          };
        };
    };
}
