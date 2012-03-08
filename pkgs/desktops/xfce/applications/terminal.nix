{ v, h, stdenv, fetchXfce, pkgconfig, intltool, ncurses, gtk, vte, dbus_glib
, exo, libxfce4util
}:

stdenv.mkDerivation rec {
  name = "xfce-terminal-${v}";
  src = fetchXfce.app "Terminal-${v}" h;

  fixupPhase = "rm $out/share/icons/hicolor/icon-theme.cache";
  buildInputs = [ pkgconfig intltool exo gtk vte libxfce4util ncurses dbus_glib ];

  meta = {
    homepage = http://www.xfce.org/projects/terminal;
    description = "A modern terminal emulator primarily for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
