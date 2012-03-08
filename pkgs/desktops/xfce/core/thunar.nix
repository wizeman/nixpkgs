{ v, h, stdenv, fetchXfce, pkgconfig, intltool, exo, gtk, libxfce4util
, dbus_glib, libstartup_notification, libnotify, xfconf, xfce4panel, gamin, libexif, pcre
, hal, enableHAL ? false }:

stdenv.mkDerivation rec {
  name = "Thunar-${v}";
  src = fetchXfce.core name h;

  fixupPhase = "rm $out/share/icons/hicolor/icon-theme.cache";
  buildInputs =
    [ pkgconfig intltool exo gtk libxfce4util
      dbus_glib libstartup_notification libnotify xfconf xfce4panel gamin libexif pcre
    ];
  # TODO: gudev, optionality
  propagatedBuildInputs = if enableHAL then [ hal ] else [];

  enableParallelBuilding = true;

  meta = {
    homepage = http://thunar.xfce.org/;
    description = "Xfce file manager";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
