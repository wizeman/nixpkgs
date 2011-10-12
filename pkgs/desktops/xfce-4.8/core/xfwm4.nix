{ stdenv, fetchXfce, pkgconfig, gtk, intltool, libglade, libxfce4util
, libxfce4ui, xfconf, libwnck, libstartup_notification, xorg }:

stdenv.mkDerivation rec {
  name = "xfwm4-4.8.1";

  src = fetchXfce.core name "4075a689f572ae157ed80ab3ce5be85f09dac766";

  buildInputs =
    [ pkgconfig intltool gtk libglade libxfce4util libxfce4ui xfconf
      libwnck libstartup_notification
      xorg.libXcomposite xorg.libXfixes xorg.libXdamage
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Window manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
