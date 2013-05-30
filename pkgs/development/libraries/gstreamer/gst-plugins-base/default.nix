{ fetchurl, stdenv, pkgconfig, intltool
, gstreamer, orc, glib, alsaLib

  # Whether to build no plugins that have external dependencies
  # (except the ALSA plugin).
, minimalDeps ? false
, xlibs, cdparanoia, libogg, libtheora, libvorbis, freetype, pango
#, isocodes # it's ~15 MB
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.0.7";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "0yk78l2jjpq8kxpg240cxxghpz3ry1nnbsk271nc0sv91gjhaj01";
  };

  patchPhase = "sed -i 's@/bin/echo@echo@g' configure";

  # TODO: libvisual
  buildInputs = [ pkgconfig intltool ]
    ++ stdenv.lib.optionals (!minimalDeps)
      [ xlibs.xlibs xlibs.libXv cdparanoia libogg libtheora libvorbis freetype pango ];

  propagatedBuildInputs = [ gstreamer orc glib alsaLib ];

  enableParallelBuilding = true;
  doCheck = true;

  postInstall = "rm -rf $out/share/gtk-doc"; # the disabling option would be disregarded

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Base plug-ins for GStreamer";

    license = "LGPLv2+";
  };
}

