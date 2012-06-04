{stdenv, fetchurl, SDL, qt4, pkgconfig, ffmpeg, libdv, libxml2, libsamplerate,
libvorbis, sox}:

stdenv.mkDerivation rec {
  name = "mlt-0.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/mlt/${name}.tar.gz";
    sha256 = "1pf61imb5xzgzf65g54kybjr67235rxi20691023mcv34qwppl3v";
  };

  buildInputs = [ qt4 SDL ffmpeg libdv libxml2 libsamplerate libvorbis sox pkgconfig ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [ "--enable-gpl" "--avformat-swscale" ];

  meta = {
    homepage = http://www.mltframework.org/;
    description = "Open source multimedia framework, designed for television broadcasting";
    license = "GPLv2+";
  };
}
