{stdenv, fetchurl, autoconf, automake, libtool, djbfft}:

stdenv.mkDerivation rec {
  name = "a52dec-0.7.4";

  src = fetchurl {
    url = "${meta.homepage}/files/a52dec-0.7.4.tar.gz";
    sha256 = "0czccp4fcpf2ykp16xcrzdfmnircz1ynhls334q374xknd5747d2";
  };

  patches = [ ./enable-pic.diff ./soname.diff
    ./link-against-lm.diff ./fix_imdct_error_msg.diff ];

  configureFlags = "--enable-djbfft --enable-shared";

  buildInputs = [autoconf automake libtool];
  propagatedBuildInputs = [djbfft];

  NIX_CFLAGS_COMPILE = "-fpic";

  meta = {
    homepage = http://liba52.sourceforge.net/;
  };
}
