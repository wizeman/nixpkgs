{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, xfconf
, libglade, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "libxfce4ui-4.9.0";

  src = fetchXfce.core name "1zfskfzmwzq64yavnv7gcjws0v6r192y5kkykw5qdwmhpcvg8wi4";

  #TODO: gladeui
  # Install into our own prefix instead.
  preConfigure =
    ''
      configureFlags="--with-libglade-module-path=$out/lib/libglade/2.0"
    '';

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util xfconf libglade
      libstartup_notification
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/projects/libxfce4;
#TODO
    description = "Basic GUI library for Xfce";
    license = "LGPLv2+";
  };
}
