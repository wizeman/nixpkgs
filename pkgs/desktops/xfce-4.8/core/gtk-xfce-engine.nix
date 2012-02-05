{ stdenv, fetchXfce, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  name = "gtk-xfce-engine-2.99.0";

  src = fetchXfce.core name "0m71rmrhl5yx1n6p5g0228s6v6ykd2xd96cvvb7i9li7hnkfbgi7";

  #TODO: gtk3
  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "GTK+ theme engine for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
