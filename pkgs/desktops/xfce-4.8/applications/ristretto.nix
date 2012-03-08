{ stdenv, fetchXfce, pkgconfig, intltool, libexif, gtk
, exo, dbus_glib, libxfce4util, libxfce4ui, xfconf }:

stdenv.mkDerivation rec {
  name = "ristretto-0.3.5";

  src = fetchXfce.app name "1wmq3s2pr3zmk9ps2lyas1m1mc22fnxvkmr7f3wma2ck5sf53p4n";

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
