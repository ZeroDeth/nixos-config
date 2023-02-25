# nix-shell --pure --show-trace keybase-shell.nix
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "keybase-env";

  buildInputs = with pkgs; [
    keybase
    keybase-gui
    kbfs
    gnupg
  ];

  # The '' quotes are 2 single quote characters
  # They are used for multi-line strings
  shellHook = ''
    keybase login zerodeth
  '';
}
