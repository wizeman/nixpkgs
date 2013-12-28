{ stdenv, fetchurl, pkgconfig, intltool, perl, perlXMLParser
, goffice, gtk3
}:

stdenv.mkDerivation rec {
  name = "gnumeric-1.12.9";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/1.12/${name}.tar.xz";
    sha256 = "1rv2ifw6rp0iza4fkf3bffvdkyi77dwvzdnvcbpqcyn2kxfsvlsc";
  };

  preConfigure = ''sed -i 's/\(SUBDIRS.*\) doc/\1/' Makefile.in ''; # fails when installing docs

  configureFlags = "--disable-component";

  # ToDo: optional libgda, python, introspection?
  buildInputs = [
    #bzip2 glib goffice gtk3 intltool libglade libgsf libxml2
    #pango pkgconfig scrollkeeper zlib
    pkgconfig intltool perl perlXMLParser
    goffice gtk3
  ];

  meta = {
    description = "The GNOME Office Spreadsheet";
    license = "GPLv2+";
    homepage = http://projects.gnome.org/gnumeric/;
  };
}
