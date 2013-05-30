{ stdenv, fetchurl, pkgconfig, intltool
, gstreamer, gst_plugins_base, orc
, glib, gdk_pixbuf, bzip2, libpng, libjpeg, cairo
, libv4l, libavc1394, libiec61883, libdv, libvpx
, aalib, libcaca
, flac, speex, libshout, taglib, pulseaudio
, udev, xlibs
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-1.0.7";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-good/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "0da03fpr5hwmnv1zr21f1c80k0hh0j92p47gg9i5hrn8fyrs65m0";
  };

  configureFlags = [ "--disable-oss" ]; # not sure why, leaving the same

  buildInputs = with xlibs; [
    pkgconfig intltool
    gstreamer gst_plugins_base orc
    glib gdk_pixbuf bzip2 libpng libjpeg cairo
    libv4l libavc1394 libiec61883 libdv libvpx
    aalib libcaca
    flac speex libshout taglib pulseaudio
    udev libX11 libICE libXfixes libXdamage libSM libXext libXv
  ];
  # ?ToDo: jack, soup, wavpack

  enableParallelBuilding = true;
  doCheck = true;

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "`Good' plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;

    license = "LGPLv2+";
  };
}
