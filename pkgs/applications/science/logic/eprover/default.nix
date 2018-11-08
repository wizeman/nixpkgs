{ stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  name = "eprover-${version}";
  version = "2.3pre002";

  src = fetchurl {
    url = "https://github.com/eprover/eprover/archive/E-${version}.tar.gz";
    sha256 = "1dq110r63jji39szz1hlazvyxrxa5c17pjjsqc8csh79r3jckm7v";
  };

  patches = [
    ./eho.patch
  ];

  buildInputs = [ which ];

  preConfigure = ''
    sed -e 's/ *CC *= *gcc$//' -i Makefile.vars
  '';
  configureFlags = [
    "--exec-prefix=$(out)"
    "--man-prefix=$(out)/share/man"
    "--enable-ho"
  ];

  meta = with stdenv.lib; {
    description = "Automated theorem prover for full first-order logic with equality";
    homepage = http://www.eprover.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin gebner ];
    platforms = platforms.all;
  };
}
