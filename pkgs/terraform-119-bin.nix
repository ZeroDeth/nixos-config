/* nix profile install -f pkgs/tf0155-bin.nix */
{ callPackage ? pkgs.callPackage
, pkgs ? import <nixpkgs> {} }:

callPackage (import ./hashicorp/generic.nix) {
  name = "terraform";
  version = "1.1.9";
  sha256 = "sha256-nS2KifXMi8HAbLbzTOduxLmRhLB+t3b4s5GDtRPXeYo=";
}
