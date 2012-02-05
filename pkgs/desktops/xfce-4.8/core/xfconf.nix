{ stdenv, fetchXfce, pkgconfig, intltool, glib, libxfce4util, dbus_glib }:

stdenv.mkDerivation rec {
  name = "xfconf-4.8.1";

  src = fetchXfce.core name "1jwkb73xcgqfly449jwbn2afiyx50p150z60x19bicps75sp6q4q";

  #TODO: no perl bingings yet (ExtUtils::Depends, ExtUtils::PkgConfig, Glib)
  buildInputs = [ pkgconfig intltool glib libxfce4util ];

  propagatedBuildInputs = [ dbus_glib ];

  meta = {
    homepage = http://www.xfce.org/projects/xfconf;
    description = "Simple client-server configuration storage and query system for Xfce";
    license = "GPLv2";
  };
}
