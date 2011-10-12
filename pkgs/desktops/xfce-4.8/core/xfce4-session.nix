{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, dbus_glib, xfconf, libglade, xorg }:

#TODO: xfce4panel

stdenv.mkDerivation rec {
  name = "xfce4-session-4.8.1";

  src = fetchXfce.core name "0adqd1gf48mck8dy7i5xchnl4d331cxg18j09xxx5m3yv1vjmx8x";

  fixupPhase = "rm $out/share/icons/hicolor/icon-theme.cache";
  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck dbus_glib
      xfconf libglade xorg.iceauth
    ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Session manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
