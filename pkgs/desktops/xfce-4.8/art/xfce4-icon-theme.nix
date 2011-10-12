{ stdenv, fetchXfce, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  name = "xfce4-icon-theme-4.4.3";

  src = fetchXfce.art name "0c0d0c45cd4a7f609310db8e9d17c1c4a131a6e7";

  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Icons for Xfce";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
