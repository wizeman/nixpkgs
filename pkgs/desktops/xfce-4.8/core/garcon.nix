{ stdenv, fetchXfce, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  name = "garcon-0.1.8";

  src = fetchXfce.core name "e5eac6a13208c81ccad0941656c01e7a69530f03";

  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
#TODO
    description = "";
    license = "";
  };
}
