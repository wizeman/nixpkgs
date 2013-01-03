{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  version = "1.5.13";
  name = "libpng-apng-${version}";

  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng15/${version}/libpng-${version}-apng.patch.gz";
    sha256 = "13x39m7wb5prvck0h6g9wxnvc5f9n253yfh8kdncsqjw9pi4ffam";
  };

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    sha256 = "1vks4mqv4140b10kp53qrywsx9m4xan5ibwsrlmf42ni075zjhxq";
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
