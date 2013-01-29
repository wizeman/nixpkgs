{ callPackage, self, pkgs }:

rec {
  gtk = pkgs.gtk3;
  orbit = pkgs.gnome2.ORBit2;

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  at_spi2_atk = callPackage ./core/at-spi2-atk { };

  at_spi2_core = callPackage ./core/at-spi2-core { };

  evince = callPackage ./core/evince { };

  gconf = callPackage ./core/gconf { };

  gcr = callPackage ./core/gcr { };

  gnome_icon_theme = callPackage ./core/gnome-icon-theme { };

  gnome_keyring = callPackage ./core/gnome-keyring { };
  libgnome_keyring = callPackage ./core/libgnome-keyring { };

  gnome_terminal = callPackage ./core/gnome-terminal { };

  gsettings_desktop_schemas = callPackage ./core/gsettings-desktop-schemas { };

  gvfs = callPackage ./core/gvfs { };

  vte = callPackage ./core/vte { };

  zenity = callPackage ./core/zenity { };

#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)


  gnome_dictionary = callPackage ./desktop/gnome-dictionary { };

  gnome_desktop = callPackage ./desktop/gnome-desktop { };


  # Removed from recent GNOME releases, but still required
  scrollkeeper = callPackage ./desktop/scrollkeeper { };

  # scrollkeeper replacement
  rarian = callPackage ./desktop/rarian { };

}
