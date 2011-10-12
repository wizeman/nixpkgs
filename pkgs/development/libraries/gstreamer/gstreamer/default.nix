{ fetchurl, stdenv, perl, bison, flex, pkgconfig, glib, libxml2 }:

stdenv.mkDerivation rec {
  name = "gstreamer-0.10.35";

  src = fetchurl {
    urls =
      [ "${meta.homepage}/src/gstreamer/${name}.tar.bz2"
        "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "11lp13lig3c6qys80phyvsik56r9y0c95vg2jxxliqj6rnigwyw1";
  };

  buildInputs = [ perl bison flex pkgconfig ];
  propagatedBuildInputs = [ glib libxml2 ];

  patchPhase = ''
    sed -i -e 's/^   /\t/' docs/gst/Makefile.in docs/libs/Makefile.in docs/plugins/Makefile.in
  '';

  configureFlags = ''
    --disable-examples --enable-failing-tests --localstatedir=/var --disable-gtk-doc --disable-docbook
  '';

  # Hm, apparently --disable-gtk-doc is ignored...
  postInstall = "rm -rf $out/share/gtk-doc";

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "GStreamer, a library for constructing graphs of media-handling components";

    longDescription = ''
      GStreamer is a library for constructing graphs of media-handling
      components.  The applications it supports range from simple
      Ogg/Vorbis playback, audio/video streaming to complex audio
      (mixing) and video (non-linear editing) processing.

      Applications can take advantage of advances in codec and filter
      technology transparently.  Developers can add new codecs and
      filters by writing a simple plugin with a clean, generic
      interface.
    '';

    license = "LGPLv2+";
  };
}
