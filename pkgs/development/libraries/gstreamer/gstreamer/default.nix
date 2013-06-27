{ fetchurl, stdenv, perl, python, bison, flex, pkgconfig, intltool
, glib, libxml2, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = "gstreamer-1.0.7";

  src = fetchurl {
    urls =
      [ "${meta.homepage}/src/gstreamer/${name}.tar.xz"
        "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "1kmmn766yn9iihddi8n6lfkx3vlq33hws768bphj7pjfw9zdmjk8";
  };

  buildInputs = [ perl python bison flex pkgconfig intltool ];
  propagatedBuildInputs = [ glib libxml2 ] ++ libintlOrEmpty;

  configureFlags = ''
    --disable-gst-debug --disable-debug --localstatedir=/var
    --disable-examples --disable-gtk-doc --disable-docbook
  '';

  doCheck = true;

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
