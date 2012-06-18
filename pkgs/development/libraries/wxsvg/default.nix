{ stdenv, fetchurl, pkgconfig, wxGTK, cairo, pango, ffmpeg }:

stdenv.mkDerivation rec {
  name = "wxsvg-${version}";
  version = "1.1.8";

  src = fetchurl {
    url = "mirror://sourceforge/wxsvg/${name}.tar.bz2";
    sha256 = "16ira8jgz92j9v2g2r2qjm0d3dihcxb36kbwj29jindh9f6xf4lm";
  };

  buildInputs = [ pkgconfig wxGTK cairo pango ffmpeg ];

  meta = {
    homepage = http://wxsvg.sourceforge.net;
    description = "A C++ library to create, manipulate and render Scalable Vector Graphics (SVG) files with the wxWidgets toolkit.";
    license = "wxWindows";
  };
}
