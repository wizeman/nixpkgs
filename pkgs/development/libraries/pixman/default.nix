{ fetchurl, stdenv, pkgconfig, perl }:

stdenv.mkDerivation rec {
  name = "pixman-0.26.2";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "1qiwn7qa9vll2cx9cp3lqi9ixpbfkv5m65zsifarsrv0a55mbay9";
  };

  buildInputs = [ pkgconfig perl ];

  meta = {
    #homepage = http://poppler.freedesktop.org/;
    #description = "Poppler, a PDF rendering library";
    #license = "GPLv2";
  };
}
