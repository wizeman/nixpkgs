{ fetchurl, stdenv, pkgconfig, intltool, glib, gstreamer, gst_plugins_base, orc
, libmad, lame, libdvdread, libmpeg2, libcdio, a52dec, mpeg2dec, x264
#, amrnb, amrwb # not detected
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-ugly-1.0.7";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-ugly/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "0awg52swqzi0iz6x9s4m7w1jm1i1pdyjj3ra8gd9f91jpvx8r2xp";
  };

  buildInputs = [
    pkgconfig intltool glib gstreamer gst_plugins_base orc
    libmad lame libdvdread a52dec mpeg2dec x264
  ];
  # not here: cdio (we have cdparanoia in -base), sid, twolame

  enableParallelBuilding = true;
  #doCheck = true; # no checks in 1.0.7

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "‘Ugly’ (potentially patent-encumbered) plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;

    license = "LGPLv2+";
  };
}
