{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "djbfft-0.76";

  src = fetchurl {
    url = "http://cr.yp.to/djbfft/${name}.tar.gz";
    sha256 = "0k1r5g59z2f279rzhn93nr08bbqizkj4j93aw7q7x9ri6sf957br";
  };

  # from http://anonscm.debian.org/viewvc/pkg-multimedia/unstable/djbfft/debian/patches/
  patches = [ ./gcc-3.patch ./libdjbfft.patch ];

  postPatch = ''
    substituteInPlace ./conf-home --replace /usr/local/djbfft $out
    chmod +x *.sh
    echo "gcc $NIX_CFLAGS_COMPILE" -fPIC > conf-cc
  '';

  installPhase = "make setup";

  meta = {
    homepage = http://cr.yp.to/djbfft.html;
  };
}
