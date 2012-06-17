{ stdenv, fetchurl, pkgconfig, wxGTK, cairo, pango, ffmpeg }:

#, SDL, ffmpeg, libdv, libsamplerate, libvorbis
#, libxml2 , pkgconfig, qt4, sox }:

stdenv.mkDerivation rec {
  name = "wxsvg-${version}";
  version = "1.1.8";

  src = fetchurl {
    url = "mirror://sourceforge/wxsvg/${name}.tar.bz2";
    sha256 = "16ira8jgz92j9v2g2r2qjm0d3dihcxb36kbwj29jindh9f6xf4lm";
  };

  buildInputs = [ pkgconfig wxGTK cairo pango ffmpeg ];

  meta = {
    homepage = http://www.mltframework.org/;
    description = "Open source multimedia framework, designed for television broadcasting";
    license = "GPLv2+";
  };
}
