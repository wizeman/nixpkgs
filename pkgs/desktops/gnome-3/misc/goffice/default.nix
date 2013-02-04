{ fetchurl, stdenv, pkgconfig, intltool, bzip2, glib, gdk_pixbuf, gtk3
, libgsf, libxml2, cairo, pango, librsvg, libspectre }:

stdenv.mkDerivation rec {
  name = "goffice-0.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/goffice/0.10/${name}.tar.xz";
    sha256 = "0fc4s2z0fygf5c66710nzfg64yp8qsmwlswhcr4krc03jbv7fxby";
  };

  propagatedBuildInputs = [ # ToDo lasem library for MathML, opt. introspection?
    pkgconfig intltool bzip2 glib gdk_pixbuf gtk3
    libgsf libxml2 cairo pango librsvg libspectre
  ];

  doCheck = true;

  meta = {
    description = "A Glib/GTK+ set of document centric objects and utilities";

    longDescription = ''
      There are common operations for document centric applications that are
      conceptually simple, but complex to implement fully: plugins, load/save
      documents, undo/redo.
    '';

    license = "GPLv2+";

    platforms = stdenv.lib.platforms.gnu;
  };
  passthru = { inherit meta; };
}
