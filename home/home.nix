{ config, lib, pkgs, nixgl, ... }:
{
  home = {
    username = "xaolan";
    homeDirectory = "/home/xaolan";
    stateVersion = "25.05";
    packages = with pkgs; [
      nixd
      alacritty
    ];
    file = {

    };
    sessionVariables = {
      EDITOR = "vim";
    };
    shell.enableFishIntegration = true;
  };

  # nixGL Home Manager integration
  nixGL = {
    defaultWrapper = "mesa";
    packages = nixgl.packages;
    vulkan.enable = true;
    installScripts = ["mesa"];
  };

  # Nixpkgs configuration
  nixpkgs.config = {
    allowDirty = true;
    allowUnfree = true;
  };
  
  # Enable Home Manager
  programs.home-manager.enable = true;
}
