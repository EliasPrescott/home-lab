{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "nixos-1";

  users.users.bill = {
    isNormalUser = true;
    home = "/home/bill";
    extraGroups = [ "wheel" "networkmanager" ];
  };
  
  services.openssh.enable = true;

  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
    };

    appendHttpConfig = "listen 127.0.0.1:80";
  };

  programs.nix-ld.enable = true;
  environment.variables = {
    NIX_LD_LIBRARY_PATH = lib.mkForce (lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
    ]);
    NIX_LD = lib.mkForce (lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker");
  };
}
