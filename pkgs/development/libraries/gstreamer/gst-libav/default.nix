{ fetchurl, stdenv, pkgconfig, gst_plugins_base, bzip2, yasm
, useInternalLibAV ? false, libav ? null
}:

assert useInternalLibAV -> libav != null;

stdenv.mkDerivation rec {
  name = "gst-libav-${version}";
  version = "1.0.7";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-libav/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
    ];
    sha256 = "0ymslwjis0796a1w0p9fnlxr1w81khdl1gygff35b9p72jfngymf";
  };

  # Upstream strongly recommends against using --with-system-libav,
  # but we do it anyway because we're so hardcore (and we don't want
  # multiple copies of libav).
  configureFlags = stdenv.lib.optionalString (!useInternalLibAV) "--with-system-libav";

  enableParallelBuilding = true;
  doCheck = true;

  buildInputs = [ pkgconfig bzip2 gst_plugins_base ]
    ++ (if useInternalLibAV then [ yasm ] else [ libav ]);

  meta = {
    homepage = http://gstreamer.freedesktop.org;
    description = "GStreamer's plug-in using LibAV";
    license = "GPLv2+";
  };
}
