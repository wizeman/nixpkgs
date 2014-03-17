{
  nixpkgs
}:

let

  pkgs = import nixpkgs { };

  release = import ../nixos/release.nix {
    inherit nixpkgs;
    stableBranch = false;
  };

  tests = builtins.attrNames release;

  to_filter = [ "ova" ];

  filtered_tests = builtins.filter (x: !builtins.elem x to_filter) tests;

in

  pkgs.lib.genAttrs filtered_tests (test: builtins.getAttr test release)

