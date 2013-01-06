{ v, h, stdenv, fetchXfce, pkgconfig, intltool, libxfce4util, libxfcegui4
, gtk, gtksourceview }:

stdenv.mkDerivation rec {
  name = "mousepad-${v}";
  src = fetchXfce.app name h;

  buildInputs = [ pkgconfig intltool libxfce4util libxfcegui4 gtk gtksourceview ];

  meta = {
    homepage = http://www.xfce.org/projects/mousepad/;
    description = "A simple text editor for Xfce";
    license = "GPLv2+";
  };
}
