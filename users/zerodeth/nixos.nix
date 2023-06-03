{ pkgs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Since we're using fish as our shell
  programs.fish.enable = true;
  
  users.users.zerodeth = {
    isNormalUser = true;
    home = "/home/zerodeth";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$6$XECGl7SdC.v$BxPSgsoFRxE49v.mU0R5j4MEWloixaxiKx43k6SNNzayRWuLl1UuvMARou8.e9fjxDNqChXuzXYKRKn1rRWL41";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHztJdM8If1PkPe7Bk0sqsEnz08J1lkDH9gPkSh4Oasp ZeroDeth"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlHERFgHj/PvJSgWkevwh0QrxFhNVte+27Q/rh3fGtm zerodeth"
    ];
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ./vim.nix)
  ];
}
