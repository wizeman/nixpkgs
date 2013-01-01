{ v, h, stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui, dbus_glib }:

stdenv.mkDerivation rec {
  name = "xfce-utils-${v}";
  src = fetchXfce.core name h;

  configureFlags = "--with-xsession-prefix=$(out)/share/xsessions --with-vendor-info=NixOS.org";
  fixupPhase = "rm $out/share/icons/hicolor/icon-theme.cache";
  buildInputs = [ pkgconfig intltool gtk libxfce4util libxfce4ui dbus_glib ];

  meta = {
    homepage = http://www.xfce.org/projects/xfce-utils;
    description = "Utilities and scripts for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
