{ stdenv, fetchurl, pkgconfig, dbus_glib, gtk, glib, libxml2
, intltool, dbus_libs, polkit, orbit }:

stdenv.mkDerivation rec {

  versionMajor = "3.2";
  versionMinor = "5";
  moduleName   = "GConf";

  origName = "${moduleName}-${versionMajor}.${versionMinor}";

  name = "gconf-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${origName}.tar.xz";
    sha256 = "1ijqks0jxc4dyfxg4vnbqds4aj6miyahlsmlqlkf2bi1798akpjd";
  };

  buildInputs = [ dbus_libs dbus_glib libxml2 polkit gtk orbit ];
  propagatedBuildInputs = [ glib ];
  buildNativeInputs = [ pkgconfig intltool ];
}
