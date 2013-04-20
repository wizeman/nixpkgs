{ stdenv, fetchurl, fetchgit, cairo, freetype, fontconfig, zlib
, libjpeg, curl, libpthreadstubs, xorg, openjpeg
, libxml2, pkgconfig, cmake, lcms2
, glibSupport ? false, glib, gtk3Support ? false, gtk3 # gtk2 no longer accepted
, qt4Support ? false, qt4 ? null
, doCheck ? true # some strange test-compilation errors (probably outdated tests)
  , pango, gtk2
}:

stdenv.mkDerivation rec {
  name = "poppler-0.22.3";

  src = fetchurl {
    url = "${meta.homepage}${name}.tar.gz";
    sha256 = "0ca4jci8xmbdz4fhahdcck0cqms6ax55yggi2ih3clgrpqf96sli";
  };
  testdata = if !doCheck then null else fetchgit {
    url = "git://anongit.freedesktop.org/poppler/test";
    rev = "0d2bfd4af4c76a3bac27ccaff793d9129df7b57a";
  };

  qtcairo_patches =
    let qtcairo = fetchgit { # the version for poppler-0.22
      url = "git://github.com/giddie/poppler-qt4-cairo-backend.git";
      rev = "7a12c58e5cefc2b7a5179c53b387fca8963195c0";
      sha256 = "1jg2d5y62d0bv206nijb63x426zfb2awy70505nx22d0fx1v1p9k";
    }; in
      [ "${qtcairo}/0001-Cairo-backend-added-to-Qt4-wrapper.patch"
        "${qtcairo}/0002-Setting-default-Qt4-backend-to-Cairo.patch"
        "${qtcairo}/0003-Forcing-subpixel-rendering-in-Cairo-backend.patch" ];

  propagatedBuildInputs = with xorg; with stdenv.lib; [
      zlib cairo freetype fontconfig libjpeg lcms2 curl
      libpthreadstubs libxml2 stdenv.gcc.libc
      libXau libXdmcp libxcb libXrender libXext
      openjpeg
    ]
    ++ optional glibSupport glib
    ++ optional gtk3Support gtk3
    ++ optionals doCheck [ pango gtk2 ]
    ;

  nativeBuildInputs = [ pkgconfig cmake ];

  cmakeFlags = "-DENABLE_XPDF_HEADERS=ON -DENABLE_LIBCURL=ON -DENABLE_ZLIB=ON";

  patches = [ ./datadir_env.patch ] ++ stdenv.lib.optionals qt4Support qtcairo_patches;

  preConfigure = stdenv.lib.optionalString doCheck "cp -r ${testdata} ../test";

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
