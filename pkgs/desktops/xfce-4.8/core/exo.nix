{ stdenv, fetchXfce, pkgconfig, intltool, URI, glib, gtk, libxfce4ui, libxfce4util }:

stdenv.mkDerivation rec {
  name = "exo-0.7.1";

  src = fetchXfce.core name "11is93g82gl0z489ifvilg5s5q34j7p4brfvz3pz0klgsgr6grz4";

  buildInputs = [ pkgconfig intltool URI glib gtk libxfce4ui libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/projects/exo;
    description = "Application library for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
