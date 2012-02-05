{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util }:

stdenv.mkDerivation rec {
  name = "garcon-0.1.9";

  src = fetchXfce.core name "1m9irwi94s571k3yyrmvmyb2zpb7akh498is8apx7w0sxk426pj8";

  buildInputs = [ pkgconfig intltool gtk libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce menu support library";
    license = "GPLv2+";
  };
}
