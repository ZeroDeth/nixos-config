/* nix profile install -f pkgs/tf0155-bin.nix */
{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./hashicorp/generic.nix) {
  name = "terraform";
  version = "1.3.6";
  sha256 = "sha256-u0SkwrCoMtSSU7kDTYzL00+f7rJu2nHGZfbn+ghh9Js=";
}
