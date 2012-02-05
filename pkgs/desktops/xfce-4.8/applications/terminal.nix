{ stdenv, fetchXfce, pkgconfig, intltool, ncurses, gtk, vte, dbus_glib
, exo, libxfce4util
}:

let version = "0.4.8"; in
stdenv.mkDerivation rec {
  name = "xfce-terminal-${version}";

  src = fetchXfce.app "Terminal-${version}" "13bqrhjkwlv4dgmbzw74didh125y2n4lvx0h3vx7xs3w2avv0pgy";

  fixupPhase = "rm $out/share/icons/hicolor/icon-theme.cache";
  buildInputs = [ pkgconfig intltool exo gtk vte libxfce4util ncurses dbus_glib ];

  meta = {
    homepage = http://www.xfce.org/projects/terminal;
    description = "A modern terminal emulator primarily for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
