{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, exo, garcon, xfconf, libstartup_notification }:

#TODO: garcon

stdenv.mkDerivation rec {
  name = "xfce4-panel-4.8.5";

  src = fetchXfce.core name "67b9d5bc422663f60f5a05e7cfd7ca67b4542813";

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util exo libwnck
      garcon xfconf libstartup_notification
    ];

  propagatedBuildInputs = [ libxfce4ui ];
  
  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce panel";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
