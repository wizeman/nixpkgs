{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util }:

stdenv.mkDerivation rec {
  name = "garcon-0.1.10";

  src = fetchXfce.core name "05hkfqirnbspr4rifnjzds7j6z5s5bvjwwfw47kc27qhj4lpljf2";

  buildInputs = [ pkgconfig intltool gtk libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce menu support library";
    license = "GPLv2+";
  };
}
