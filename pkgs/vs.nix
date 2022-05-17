Use hyper in a nix script via Git

let
     pkgs = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify
         name = "my-old-revision";
         url = "https://github.com/NixOS/nixpkgs/";
         ref = "refs/heads/nixos-21.11";
         rev = "9e27e2e6bbc1e72f73fff75f669b7be53d0bba62";
     }) {};

     myPkg = pkgs.hyper;
in


{
  imports = [
    (fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
  ];

  services.vscode-server.enable = true;
}
