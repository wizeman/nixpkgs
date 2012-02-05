{ stdenv, fetchXfce, pkgconfig, intltool, libexif, gtk
, exo, dbus_glib, libxfce4util, libxfce4ui, xfconf }:

stdenv.mkDerivation rec {
  name = "ristretto-0.3.4";

  src = fetchXfce.app name "0chslylx6b7sylfkr5n7fgqcq1s6wn918kf588lzhv7mqdmmrvg2";

  buildInputs =
    [ pkgconfig intltool libexif gtk dbus_glib exo libxfce4util
      libxfce4ui xfconf
    ];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/ristretto;
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
