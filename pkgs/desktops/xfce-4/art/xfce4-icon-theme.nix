{ stdenv, fetchXfce, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  name = "xfce4-icon-theme-4.4.3";

  src = fetchXfce.art name "1yk6rx3zr9grm4jwpjvqdkl13pisy7qn1wm5cqzmd2kbsn96cy6l";

  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Icons for Xfce";
  };
}
