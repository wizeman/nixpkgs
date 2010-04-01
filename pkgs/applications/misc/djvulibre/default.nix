{ stdenv, fetchurl, lib, config, libjpeg, libtiff, libpng, ghostscript
, libungif, zlib, x11, libX11, mesa, qt3 }:

stdenv.mkDerivation {
  name = "djvulibre-3.5.22";

  src = fetchurl {
    url = mirror://sourceforge/djvu/djvulibre-3.5.22.tar.gz;
    sha256 = "1gphi67qiq1ky7k8vymkwcgla80cwy8smk1rla6grxdqipwl54ix";
  };

  buildInputs = [ libjpeg libtiff libpng ghostscript zlib libungif ] ++
    (if config "qt3" true then [qt3 libX11 x11 mesa] else []);

  meta = {
    description = "A library and viewer for the DJVU file format for scanned images";
    homepage = http://djvu.sourceforge.net;
    maintainers = [ lib.maintainers.urkud ];
  };
}
