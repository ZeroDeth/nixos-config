/* nix profile install -f pkgs/tf0155-bin.nix */
{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./hashicorp/generic.nix) {
  name = "terraform";
  version = "1.0.1";
  sha256 = "sha256-2pRldZNjbI01qW5AQRNkNf9YuwBhJFt9D4LbSncozvM=";
}
