{ stdenv, fetchXfce, pkgconfig, intltool, URI, glib, gtk, libxfce4ui, libxfce4util }:

stdenv.mkDerivation rec {
  name = "exo-0.7.0";

  src = fetchXfce.core name "0w8p4qva33jgqwrxcrqqdx9r7yac0fhc41g2z70nn0mhz0jrxdbb";

  buildInputs = [ pkgconfig intltool URI glib gtk libxfce4ui libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/projects/exo;
    description = "Application library for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
