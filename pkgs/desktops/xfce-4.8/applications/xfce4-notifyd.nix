{ stdenv, fetchXfce, pkgconfig, intltool
, gtk , libxfce4util, libxfce4ui, xfconf }:

stdenv.mkDerivation rec {
  name = "xfce4-notifyd-0.2.1";

  src = fetchXfce.app name "0w7dqfzb7h6hg9n7bdnqwybakrz2p72ffi37h4fsj7j02hyxmcma";

  buildInputs = [ pkgconfig intltool gtk libxfce4util libxfce4ui xfconf ];

  fixupPhase = ''
    rm $out/share/icons/hicolor/icon-theme.cache
    # to be able to run the daemon we need it in PATH
    cp -l $out/lib/xfce4/notifyd/xfce4-notifyd $out/bin
   '';

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-notifyd;
    description = "";
    #license = "GPLv2+";
  };
}
