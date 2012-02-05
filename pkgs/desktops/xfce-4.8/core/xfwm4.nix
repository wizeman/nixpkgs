{ stdenv, fetchXfce, pkgconfig, gtk, intltool, libglade, libxfce4util
, libxfce4ui, xfconf, libwnck, libstartup_notification, xorg }:

stdenv.mkDerivation rec {
  name = "xfwm4-4.8.3";

  src = fetchXfce.core name "0zi2g1d2jdgw5armlk9xjh4ykmydy266gdba86nmhy951gm8n3hb";

  #TODO: kde systray, docs
  buildInputs =
    [ pkgconfig intltool gtk libglade libxfce4util libxfce4ui xfconf
      libwnck libstartup_notification
      xorg.libXcomposite xorg.libXfixes xorg.libXdamage
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/projects/xfwm4;
    description = "Window manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
