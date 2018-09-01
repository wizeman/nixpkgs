{ fetchurl, stdenv, pkgconfig, libao, readline, json_c, libgcrypt, libav_12, curl }:

stdenv.mkDerivation rec {
  name = "pianobar-2018.06.22";

  src = fetchurl {
    url = "http://6xq.net/projects/pianobar/${name}.tar.bz2";
    sha256 = "1hnlif62vsxgh8j9mcibxwj4gybpgqc11ba729kflpvvi9qmfqwl";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libao json_c libgcrypt libav_12 curl
  ];

  makeFlags="PREFIX=$(out)";

  CC = "gcc";
  CFLAGS = "-std=c99";

  meta = with stdenv.lib; {
    description = "A console front-end for Pandora.com";
    homepage = http://6xq.net/projects/pianobar/;
    platforms = platforms.linux;
    license = licenses.mit; # expat version
    maintainers = with maintainers; [ eduarrrd ];
  };
}
