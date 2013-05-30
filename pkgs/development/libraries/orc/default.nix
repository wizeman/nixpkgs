{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "orc-${version}";
  version = "0.4.17";

  src = fetchurl {
    url = "http://code.entropywave.com/download/orc/${name}.tar.gz";
    sha256 = "1s6psp8phrd1jmxz9j01cksh3q5xrm1bd3z7zqxg5zsrijjcrisg";
  };

  buildInputs = [ pkgconfig ];

  enableParallelBuilding = true;
  doCheck = true;

  postInstall = "rm -rf $out/share/gtk-doc"; # the disabling option would be disregarded

  meta = {
    homepage = http://code.entropywave.com/orc;
    description = "A library and simple set of tools for compiling and executing simple programs";
    license = "BSD"; # seems BSD-like to me
  };
}

