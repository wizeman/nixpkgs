{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui }:

stdenv.mkDerivation rec {
  name = "xfce-utils-4.8.3";

  src = fetchXfce.core name "09mr0amp2f632q9i3vykaa0x5nrfihfm9v5nxsx9vch8wvbp0l03";

  configureFlags = "--with-xsession-prefix=$(out)/share/xsessions --with-vendor-info=NixOS.org";

  fixupPhase = "rm $out/share/icons/hicolor/icon-theme.cache";
  buildInputs = [ pkgconfig intltool gtk libxfce4util libxfce4ui ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Utilities and scripts for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
