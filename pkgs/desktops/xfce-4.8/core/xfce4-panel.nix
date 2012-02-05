{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, exo, garcon, xfconf, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "xfce4-panel-4.9.0"; # dev version for 4.10

  src = fetchXfce.core name "1f5zk5j37jzdi13wdvcl6m78x29xkvn0cl2d4gh8zcg6h22v23yn";

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util exo libwnck
      garcon xfconf libstartup_notification
    ];

  propagatedBuildInputs = [ libxfce4ui ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-panel;
    description = "Xfce panel";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
