{ stdenv, fetchurl, ffmpeg, libtheora, pkgconfig, scons, libkate }:

stdenv.mkDerivation rec {
  name = "ffmpeg2theora-0.28";

  src = fetchurl {
    url = "http://v2v.cc/~j/ffmpeg2theora/downloads/${name}.tar.bz2";
    sha256 = "6893c1444d730a1514275ba76ba487ca207205b916d6cb1285704225ee86fe1e";
  };

  #TODO: libkate not found for some reason
  buildInputs = [ ffmpeg libtheora pkgconfig scons /*libkate*/ ];

  installPhase = "scons install prefix=$out";

  meta = {
    homepage = http://v2v.cc/~j/ffmpeg2theora;
    description = "A simple converter to create Ogg Theora files.";
    license = "GPLv3+";
  };
}
