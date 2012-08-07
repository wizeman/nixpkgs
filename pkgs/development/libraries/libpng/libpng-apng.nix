{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  version = "1.5.12";
  name = "libpng-apng-${version}";

  patch_src = fetchurl {
    url = "mirror://sourceforge/project/libpng-apng/libpng-master/${version}/libpng-${version}-apng.patch.gz";
    sha256 = "1imnmd8kz21gyxjl460s5yahcjj7g7ps6gl0vbzz25lq71x7p3kq";
  };

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    sha256 = "03fl91yirm59s1ppdflvqqbhsmwhxwf9mchambwvvd18yp56ip5s";
  };

  preConfigure = ''
    gunzip < ${patch_src} | patch -Np1
  '';

  propagatedBuildInputs = [ zlib ];

  passthru = { inherit zlib; };

  meta = {
    description = "The official reference implementation for the PNG file format with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
