{ stdenv, fetchurl, autoconf, automake, pkgconfig
, libtool, libva, libvdpau, libdrm, libX11, libXfixes, libXext, mesa }:

stdenv.mkDerivation rec {
  name = "libva-vdpau-driver-0.7.4";
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/${name}.tar.bz2";
    sha256 = "1fcvgshzyc50yb8qqm6v6wn23ghimay23ci0p8sm8gxcy211jp0m";
  };

  patches = [ ./paths-common.patch ./nvidia-paths.patch ];

  preConfigure = "autoreconf --verbose --install"; # to use the *.am patches

  buildInputs = [ automake autoconf libtool pkgconfig libva libvdpau libdrm libX11 libXfixes libXext mesa ];

  fixupPhase = ''find "$out" -name "*.la" -delete'';

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = "GPLv2";
    description = "VDPAU Backend for Video Acceleration (VA) API";
  };
}
