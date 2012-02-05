{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, xfconf, libglade, libxfce4menu, xfce4panel, thunar, exo, garcon, libnotify }:

stdenv.mkDerivation rec {
  name = "xfdesktop-4.8.3";

  src = fetchXfce.core name "097lc9djmay0jyyl42jmvcfda75ndp265nzn0aa3hv795bsn1175";

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck xfconf
      libglade libxfce4menu xfce4panel thunar exo garcon libnotify
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/projects/xfdesktop;
    description = "Xfce desktop manager";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
