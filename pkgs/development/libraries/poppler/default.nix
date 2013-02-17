{ fetchurl, stdenv, cairo, freetype, fontconfig, zlib
, libjpeg, curl, libpthreadstubs, xorg, openjpeg
, libxml2, pkgconfig, cmake, lcms2
, gtkSupport ? false, glib ? null, gtk3 ? null # gtk2 no longer accepted
, qt4Support ? false, qt4 ? null
, fetchgit, doCheck?false # some strange test-compilation error
}:

stdenv.mkDerivation rec {
  name = "poppler-0.22.1";

  src = fetchurl {
    url = "${meta.homepage}${name}.tar.gz";
    sha256 = "1h4p241k7ysm7mb8wgwi7ilp69z297d7ql5padb0dnmzq39sddhj";
  };
  testdata = fetchgit {
    url = "git://anongit.freedesktop.org/poppler/test";
    rev = "0d2bfd4af4c76a3bac27ccaff793d9129df7b57a";
  };

  propagatedBuildInputs = with xorg;
    [ zlib cairo freetype fontconfig libjpeg lcms2 curl
      libpthreadstubs libxml2 stdenv.gcc.libc
      libXau libXdmcp libxcb libXrender libXext
      #openjpeg # not detected
    ]
    ++ stdenv.lib.optionals gtkSupport [ glib /*gtk3*/ ]
    ++ stdenv.lib.optional qt4Support qt4;

  buildNativeInputs = [ pkgconfig cmake ];

  cmakeFlags = "-DENABLE_XPDF_HEADERS=ON -DENABLE_LIBCURL=ON -DENABLE_ZLIB=ON";

  preConfigure = if !doCheck then "" else "cp -r ${testdata} ../test";

  patches = [ ./datadir_env.patch ];

  inherit doCheck;
  checkPhase = ''
    pushd ../../test
    #ln -s ../${name}/glib .
    NIX_CFLAGS="$NIX_CFLAGS -I../${name}"
    PKG_CONFIG_PATH="../${name}/build:$PKG_CONFIG_PATH"
    chmod +rw Makefile
    echo "CFLAGS += -I../${name}/glib -I../${name}/build/glib" >> Makefile
    make # build the testers
    popd
    make test
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://poppler.freedesktop.org/;
    description = "Poppler, a PDF rendering library";

    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base.
    '';

    platforms = if qt4Support
      then qt4.meta.platforms
      else stdenv.lib.platforms.all;

    license = "GPLv2";
  };
}
