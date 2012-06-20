{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "orc-${version}";
  version = "0.4.16";

  src = fetchurl {
    url = "http://code.entropywave.com/download/orc/${name}.tar.gz";
    sha256 = "1asq58gm87ig60ib4cs69hyqhnsirqkdlidnchhx83halbdlw3kh";
  };

  buildInputs = [ pkgconfig ];

  meta = {
    homepage = http://code.entropywave.com/orc;
    description = "A library and simple set of tools for compiling and executing simple programs.";
    license = "BSD"; # seems BSD-like to me
  };
}
