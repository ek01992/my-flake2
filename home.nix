{
  lib,
  ...
}:
{
  # Change your-user
  home.username = "erik";
  # Change your-user
  home.homeDirectory = lib.mkDefault "erik";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    nixfmt
  ];

  imports = [
  ];
  programs.home-manager.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "autumn_night_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
    }];
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Erik";
      email = "ek01992@proton.me";
    };
    config.init.defaultBranch = "main";
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #   config.common.default = [ "gtk" ];
  # };
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
}
