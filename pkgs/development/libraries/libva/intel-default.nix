{ stdenv, fetchurl, autoconf, automake, pkgconfig
, libtool, libva, libdrm, libX11, libXfixes, libXext, intelgen4asm }:

stdenv.mkDerivation rec {
  name = "libva-intel-driver-1.0.19";
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/${name}.tar.bz2";
    sha256 = "14m7krah3ajkwj190q431lqqa84hdljcdmrcrqkbgaffyjlqvdid";
  };

  patches = [ ./intel-paths.patch ];

  preConfigure = "./autogen.sh -V";

  # TODO: test on an intel GFX
  configureFlags = [
    "--sharedstatedir=/var/run/" # modifiable architecture-independent data [PREFIX/com]
    "--localstatedir=/var/run/"   # modifiable single-machine data [PREFIX/var]
  ];

  buildInputs = [ autoconf automake libtool pkgconfig libva intelgen4asm libdrm libX11 libXfixes libXext ];

  fixupPhase = ''find "$out" -name "*.la" -delete'';

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = "MIT";
    description = "VA API driver for Intel G45 & HD Graphics family";
  };
}
