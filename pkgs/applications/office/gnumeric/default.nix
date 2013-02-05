{ stdenv, fetchurl, pkgconfig, intltool, perl, perlXMLParser
, goffice, gtk3
}:

stdenv.mkDerivation rec {
  name = "gnumeric-1.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/1.12/${name}.tar.xz";
    sha256 = "04a1w38abx25cbix8diy6ihf4f3q3vxw9a7x595lblg517cm6yq3";
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
