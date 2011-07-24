{ stdenv, fetchXfce #, pkgconfig, intltool, libexif
, gtk
#, exo, dbus_glib
, libxfce4util, libxfce4ui, xfconf }:

stdenv.mkDerivation rec {
  name = "xfce4-notifyd-0.2.1";

  src = fetchXfce.app name "0w7dqfzb7h6hg9n7bdnqwybakrz2p72ffi37h4fsj7j02hyxmcma";

  buildInputs = [ gtk libxfce4util libxfce4ui xfconf ];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-notifyd;
    description = "";
    #license = "GPLv2+";
  };
}
