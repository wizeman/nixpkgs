{ callPackage, pkgs }:

let
  lib = import ../../lib;
in {
  inherit (pkgs.gtkLibs) gtk glib;
  inherit (pkgs.gnome) libglade libwnck vte;
  inherit (pkgs.perlPackages) URI;

  fetchXfce = rec {
    generic = prepend : name : hash :
      let p = builtins.parseDrvName name;
          versions = lib.splitString "." p.version;
          ver_maj = lib.concatStrings (lib.intersperse "." (lib.take 2 versions));
          name_low = lib.toLower p.name;
      in pkgs.fetchurl {
        url = "mirror://xfce/${prepend}/${name_low}/${ver_maj}/${name}.tar.bz2";
        sha256 = hash;
      };
    core = generic "xfce";
    app = generic "apps";
    art = generic "art";
  };
  
  #### SUPPORT

  libgdu = callPackage ./support/libgdu.nix { };  

  # Gvfs is required by Thunar for the trash feature and for volume
  # mounting.  Should use the one from Gnome, but I don't want to mess
  # with the Gnome packages (or pull in a zillion Gnome dependencies).
  gvfs = callPackage ./support/gvfs.nix { };


  #### CORE

  libxfce4util = callPackage ./core/libxfce4util.nix { };

  xfconf = callPackage ./core/xfconf.nix { };

  libxfce4ui = callPackage ./core/libxfce4ui.nix { };

  libxfcegui4 = callPackage ./core/libxfcegui4.nix { };

  exo = callPackage ./core/exo.nix { };

  garcon = callPackage ./core/garcon.nix { };

  xfce4panel = callPackage ./core/xfce4-panel.nix { };

  thunar = callPackage ./core/thunar.nix { };

  thunar_volman = callPackage ./core/thunar-volman.nix { };

  xfce4settings = callPackage ./core/xfce4-settings.nix { };

  xfce4session = callPackage ./core/xfce4-session.nix { };

  xfwm4 = callPackage ./core/xfwm4.nix { };

  xfdesktop = callPackage ./core/xfdesktop.nix { };

  xfceutils = callPackage ./core/xfce-utils.nix { };

  # not used anymore
  libxfce4menu = callPackage ./core/libxfce4menu.nix { };

  gtk_xfce_engine = callPackage ./core/gtk-xfce-engine.nix { };

  #### APPLICATIONS

#TODO: correct links; more stuff: appfinder, thunar_volman etc.

  terminal = callPackage ./applications/terminal.nix { };

  mousepad = callPackage ./applications/mousepad.nix { };

  ristretto = callPackage ./applications/ristretto.nix { };

  xfce4mixer = callPackage ./applications/xfce4-mixer.nix { };

  xfce4notifyd = callPackage ./applications/xfce4-notifyd.nix { };

  xfce4_power_manager = callPackage ./core/xfce4-power-manager.nix { };

  #### ART

  xfce4icontheme = callPackage ./art/xfce4-icon-theme.nix { };

}
