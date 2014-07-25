{ stdenv, fetchurl, gfortran, blas, cmake, python, shared ? false }:
let
  blasMS = blas; #.override { inherit shared; }; # currently provides both by default
  version = "3.5.0";
in
stdenv.mkDerivation {
  name = "liblapack-${version}";
  src = fetchurl {
    url = "http://www.netlib.org/lapack/lapack-${version}.tgz";
    sha256 = "0lk3f97i9imqascnlf6wr5mjpyxqcdj73pgj97dj2mgvyg9z1n4s";
  };

  propagatedBuildInputs = [ blasMS ];
  buildInputs = [ gfortran cmake ];
  nativeBuildInputs = [ python ];

  # not a standard cmakeFlags list because of a space in cmake var
  # -frecursive: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=693269
  preConfigure = ''
    cmakeFlagsArray=(
      "-DUSE_OPTIMIZED_BLAS=ON"
      "-DCMAKE_Fortran_FLAGS=-frecursive -fPIC"
      ${stdenv.lib.optionalString shared ''"-DBUILD_SHARED_LIBS=ON"''}
    )
  '';

  doCheck = false; # all tests fail on shared, and also -frecursive is problem for tests
  checkPhase = ''
    sed -i 's,^#!.*,#!${python}/bin/python,' lapack_testing.py
    ctest
  '';

  enableParallelBuilding = true;

  passthru = {
    blas = blasMS;
  };

  meta = with stdenv.lib; {
    description = "Linear Algebra PACKage";
    homepage = "http://www.netlib.org/lapack/";
    license = licenses.bsd3; # possibly slightly revised

    platforms = platforms.all;
    maintainers = [ maintainers.simons ];
  };
}
