{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, xfconf, libglade, libxfce4menu, xfce4panel, thunar, exo }:

#TODO: garcon, dbus_glib, libnotify

stdenv.mkDerivation rec {
  name = "xfdesktop-4.8.2";

  src = fetchXfce.core name "fe7d71bb502197b0353b952947826a5a50ab13bc";

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck xfconf
      libglade libxfce4menu xfce4panel thunar exo
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce desktop manager";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
