{ stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, xfconf
, libglade, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "libxfce4ui-4.8.0";

  src = fetchXfce.core name "0fd39f314w0w1f6hdv3q95wb81lqkkb4x1s4vfzl0d350k87zxi1";

  # By default, libxfce4ui tries to install into libglade's prefix.
  # Install into our own prefix instead.
  #preConfigure =
  #  ''
  #    configureFlags="--with-libglade-module-path=$out/lib/libglade/2.0"
  #  '';
#TODO: glade support

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util xfconf libglade
      libstartup_notification
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
#TODO
    description = "Basic GUI library for Xfce";
    license = "LGPLv2+";
  };
}
