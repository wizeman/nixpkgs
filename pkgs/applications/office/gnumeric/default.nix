{ stdenv, fetchurl, pkgconfig, intltool, perl, perlXMLParser
, goffice, gtk3, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "gnumeric-1.12.9";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/1.12/${name}.tar.xz";
    sha256 = "1rv2ifw6rp0iza4fkf3bffvdkyi77dwvzdnvcbpqcyn2kxfsvlsc";
  };

  preConfigure = ''sed -i 's/\(SUBDIRS.*\) doc/\1/' Makefile.in''; # fails when installing docs

  configureFlags = "--disable-component";

  # ToDo: optional libgda, python, introspection?
  buildInputs = [
    pkgconfig intltool perl perlXMLParser
    goffice gtk3 makeWrapper
  ];

  # ToDo: make also the default hicolor icons work
  postInstall = ''
    wrapProgram "$out"/bin/gnumeric-* \
      --prefix XDG_DATA_DIRS : "${gtk3}/share"
  '';

  meta = {
    description = "The GNOME Office Spreadsheet";
    license = "GPLv2+";
    homepage = http://projects.gnome.org/gnumeric/;
  };
}
