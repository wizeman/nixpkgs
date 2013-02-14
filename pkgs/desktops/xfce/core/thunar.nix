{ v, h, stdenv, fetchXfce, pkgconfig, intltool
, gtk, dbus_glib, libstartup_notification, libnotify, libexif, pcre, udev
, exo, libxfce4util,  xfconf, xfce4panel
}:

stdenv.mkDerivation rec {
  name = "Thunar-${v}";
  src = fetchXfce.core name h;

  buildInputs = [
    pkgconfig intltool
    gtk dbus_glib libstartup_notification libnotify libexif pcre udev
    exo libxfce4util xfconf xfce4panel
  ];
  # TODO: optionality?

  enableParallelBuilding = true;

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://thunar.xfce.org/;
    description = "Xfce file manager";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
