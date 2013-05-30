{ fetchurl, stdenv, pkgconfig, intltool, glib, gstreamer, gst_plugins_base, orc
, bzip2, libdvdnav, libdvdread }:

stdenv.mkDerivation rec {
  name = "gst-plugins-bad-1.0.7";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "1ay22miv61zcsakfviq6h1azmxbyljrm9c5ynls5i1fw7wsycjaz";
  };

  buildInputs = [
    pkgconfig intltool glib gstreamer gst_plugins_base orc
    bzip2 libdvdnav libdvdread
  ]; # ?ToDo: many features missing

  enableParallelBuilding = true;
  # doCheck = true; # 2/26 tests failing (!)

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "‘Bad’ (potentially low quality) plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;

    license = "LGPLv2+";
  };
}
