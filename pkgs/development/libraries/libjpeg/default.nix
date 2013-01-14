{ stdenv, fetchurl }: 

stdenv.mkDerivation rec {
  version = "9";
  name = "libjpeg-${version}";

  src = fetchurl {
    url = "http://www.ijg.org/files/jpegsrc.v${version}.tar.gz";
    sha256 = "0dg5wxcx3cw0hal9gvivj97vid9z0s5sb1yvg55hpxmafn9rxqn4";
  };

  meta = {
    homepage = http://www.ijg.org/;
    description = "A library that implements the JPEG image file format";
    license = "free";
  };
}
