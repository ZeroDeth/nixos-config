/* nix profile install -f pkgs/tf0155-bin.nix */
{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./hashicorp/generic.nix) {
  name = "terraform";
  version = "1.1.8";
  sha256 = "sha256-+9N8HsPRY/STB1qg+oUUfn4/iN2Ydg7nr3SZeDRU9MU=";
}
