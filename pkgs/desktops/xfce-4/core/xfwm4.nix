{ stdenv, fetchurl, pkgconfig, gtk, intltool, libglade, libxfce4util
, libxfcegui4, xfconf, libwnck, libstartup_notification, xorg }:

stdenv.mkDerivation rec {
  name = "xfwm4-4.8.1";

  src = fetchurl {
    url = "mirror://xfce/${name}.tar.bz2";
    sha256 = "16c4ix559hm32vbb89pcd13kbrpabg1na9fgyz53pk50j9nbyg3a";
  };

  buildInputs =
    [ pkgconfig intltool gtk libglade libxfce4util libxfcegui4 xfconf
      libwnck libstartup_notification
      xorg.libXcomposite xorg.libXfixes xorg.libXdamage
    ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Window manager for Xfce";
    license = "GPLv2+";
  };
}
