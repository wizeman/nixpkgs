{ stdenv, fetchXfce, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, libglade, xfconf, xorg, libwnck, libnotify, libxklavier, garcon }:

#TODO: optional packages
stdenv.mkDerivation rec {
  name = "xfce4-settings-4.9.2"; # dev version for 4.10

  src = fetchXfce.core name "1yz20xj6kp5mx4gfhqqa9hxls7i85h4dcqqkfkk9mlmw9vqmgl1v";

  buildInputs =
    [ pkgconfig intltool exo gtk libxfce4util libxfce4ui libglade
      xfconf xorg.libXi xorg.libXcursor libwnck libnotify libxklavier garcon
    #gtk libxfce4util libxfcegui4 libwnck dbus_glib
      #xfconf libglade xorg.iceauth
    ];

  configureFlags = "--enable-pluggable-dialogs --enable-sound-settings";

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-settings;
    description = "Settings manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
