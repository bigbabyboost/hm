{pkgs, config, ...}: {
  programs.kitty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.kitty;
  };
}
