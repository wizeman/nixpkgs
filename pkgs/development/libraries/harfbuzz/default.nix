{ stdenv, fetchurl, pkgconfig, glib, freetype }:

stdenv.mkDerivation rec {
  name = "harfbuzz-0.9.10";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/harfbuzz/release/${name}.tar.bz2";
    sha256 = "08rfkkcm4113ilm15j6h6cxp21z6pni123jcjv8hya85xlfji30z";
  };

  buildInputs = [ pkgconfig glib freetype ];

  meta = {
    description = "An OpenType text shaping engine";
    homepage = http://www.freedesktop.org/wiki/Software/HarfBuzz;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
