{ stdenv, fetchXfce, pkgconfig, glib, intltool }:

stdenv.mkDerivation rec {
  name = "libxfce4util-4.8.2";

  src = fetchXfce.core name "05n8586h2fwkibfld5fm4ygx1w66jnbqqb3li0ardjvm2n24k885";

  buildInputs = [ pkgconfig glib intltool ];

  meta = {
    homepage = http://www.xfce.org/projects/libxfce4;
    description = "Basic utility non-GUI functions for Xfce";
    license = "bsd";
  };
}
