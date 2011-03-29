{ callPackage, pkgs }:

{
  inherit (pkgs.gtkLibs) gtk glib;
  inherit (pkgs.gnome) libglade libwnck;
  inherit (pkgs.perlPackages) URI;

  #### CORE

  libxfce4util = callPackage ./core/libxfce4util.nix { };

  xfconf = callPackage ./core/xfconf.nix { };

  libxfce4ui = callPackage ./core/libxfce4ui.nix { };

  libxfcegui4 = callPackage ./core/libxfcegui4.nix { };

  # not tested yet?
  exo = callPackage ./core/exo.nix { };

  # not tested yet
  xfce4panel = callPackage ./core/xfce4-panel.nix { };

  # not tested yet
  thunar = callPackage ./core/thunar.nix { };

  # not tested yet
  xfce4settings = callPackage ./core/xfce4-settings.nix { };

  # not tested yet
  xfce4session = callPackage ./core/xfce4-session.nix { };

  # not tested yet
  xfwm4 = callPackage ./core/xfwm4.nix { };

  # not tested yet
  xfdesktop = callPackage ./core/xfdesktop.nix { };

  # needs 4ui
  xfceutils = callPackage ./core/xfce-utils.nix { };


  # not used anymore
  libxfce4menu = callPackage ./core/libxfce4menu.nix { };









  gtk_xfce_engine = callPackage ./core/gtk-xfce-engine.nix { };

  #### APPLICATIONS

#TODO: appfinder

  terminal = callPackage ./applications/terminal.nix {
    inherit (pkgs.gnome) vte;
  };

  mousepad = callPackage ./applications/mousepad.nix { };

  ristretto = callPackage ./applications/ristretto.nix { };

  xfce4_power_manager = callPackage ./applications/xfce4-power-manager.nix { };

  xfce4mixer = callPackage ./applications/xfce4-mixer.nix { };

  #### ART

  xfce4icontheme = callPackage ./art/xfce4-icon-theme.nix { };

}
