{ stdenv, fetchurl, pkgconfig, wxGTK, wxsvg, libgnomeui, libexif, udev, xmlto
, gettext, zip, cdrkit, dvdplusrwtools, yacc, flex, dvdauthor, ffmpeg }:

stdenv.mkDerivation rec {
  name = "dvdstyler-${version}";
  version = "2.3b1";

  src = fetchurl {
    url = "mirror://sourceforge/dvdstyler/DVDStyler-${version}.tar.bz2";
    sha256 = "0lwpgpsa5aym5vc9x7b8pwaj4xhs1y9a66ncz17d8cn2v4fm7qfj";
  };

  # fixes a run-time link error
  preBuild = ''echo "AM_LDFLAGS = -ljpeg" >> src/Makefile'';

  buildInputs = [
    pkgconfig wxGTK wxsvg libgnomeui libexif udev gettext xmlto zip
    cdrkit dvdplusrwtools yacc flex dvdauthor ffmpeg
  ];

  meta = {
    homepage = http://www.dvdstyler.org/;
    #description = "";
    #license = "GPLv2+";
  };
}
