{ stdenv, fetchurl, pkgconfig, libtool, libX11, libXext
, mesa, libdrm, libXfixes }:

stdenv.mkDerivation rec {
  name = "libva-1.1.0";
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "1a7g7i96ww8hmim2pq2a3xc89073lzacxn1xh9526bzhlqjdqsnv";
  };

  configureFlags = [
    "--with-drivers-path=/var/run/current-system/sw/lib/xorg/modules/drivers"
    "--enable-dummy-driver=no" # was trying to write to /var/run/...
  ];

  # don't seem to propagate anyway :-(
  propagatedBuildInputs = [ pkgconfig libtool libX11 libXext mesa libdrm libXfixes ];

  fixupPhase = ''find "$out" -name "*.la" -delete'';

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = "MIT";
    description = "VAAPI library: Video Acceleration API";
  };
}
