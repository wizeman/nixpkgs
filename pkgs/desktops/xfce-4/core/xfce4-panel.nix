{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfcegui4
, libwnck, exo, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "xfce4-panel-4.8.2";

  src = fetchurl {
    url = "mirror://xfce/${name}.tar.bz2";
    sha256 = "0rmvh2inzgb2qixxfmacvvhkqvdmh8qfvxb3csbh5vbrg838hzj9";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util exo libwnck
      libstartup_notification
    ];

  propagatedBuildInputs = [ libxfcegui4 ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce panel";
    license = "GPLv2+";
  };
}
