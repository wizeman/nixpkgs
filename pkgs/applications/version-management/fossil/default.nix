{stdenv, fetchurl, zlib, openssl, tcl}:

let
  version = "20110512145652";
in

stdenv.mkDerivation {
  name = "fossil-${version}";

  src = fetchurl {
    url = "http://www.fossil-scm.org/download/fossil-src-${version}.tar.gz";
    sha256 = "1x51bmmzmabq8dkpm4sxkqbpmp6nxk9dix7pqa2calmjn3rmzc8k";
  };

  buildInputs = [ zlib openssl ];
  buildNativeInputs = [ tcl ];

  doCheck = true;

  checkTarget = "test";

  installPhase = ''
    ensureDir $out/bin
    INSTALLDIR=$out/bin make install
  '';

  crossAttrs = {
    doCheck = false;
    makeFlagsArray = [ "TCC=${stdenv.cross.config}-gcc" ];
  };

  meta = {
    description = "Simple, high-reliability, distributed software configuration management.";
    longDescription = ''
      Fossil is a software configuration management system.  Fossil is
      software that is designed to control and track the development of a
      software project and to record the history of the project. There are
      many such systems in use today. Fossil strives to distinguish itself
      from the others by being extremely simple to setup and operate.
    '';
    homepage = http://www.fossil-scm.org/;
    license = "BSD";
    platforms = with stdenv.lib.platforms; all;
    maintainers = [ #Add your name here!
      stdenv.lib.maintainers.z77z
      stdenv.lib.maintainers.viric
    ];
  };
}
