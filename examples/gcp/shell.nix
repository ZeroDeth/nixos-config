# Ref: https://github.com/NixOS/nixpkgs/issues/99280#issuecomment-1267627236
# Ref: https://github.com/michielboekhoff/nixos-conf/blob/37d2a6f7b4d5c266346b270f5da5db82613eb945/hosts/kyoshi/default.nix#L19

{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/a62844b30250.tar.gz") {} }:

pkgs.mkShell {
  buildInputs = [
    (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.cloud-build-local])
  ];
}
