{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui, xfce4panel
, libwnck, dbus_glib, xfconf, libglade, xorg }:

#TODO: gnome stuff: gconf (assistive?), keyring

stdenv.mkDerivation rec {
  name = "xfce4-session-4.8.2";

  src = fetchXfce.core name "1l608kik98jxbjl73waf8515hzji06lr80qmky2qlnp0b6js5g1i";

  fixupPhase = "rm $out/share/icons/hicolor/icon-theme.cache";
  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck dbus_glib
      xfconf xfce4panel libglade xorg.iceauth
    ];

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-session;
    description = "Session manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
