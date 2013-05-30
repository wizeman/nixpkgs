{ stdenv, fetchurl, libav_9 }:

let derivSrc = libav_9.derivSrc // rec {
  name = "libav-0.8.7";

  src = fetchurl {
    url = "http://libav.org/releases/${name}.tar.xz";
    sha256 = "0gazdngbad0dgvfaz2l6dp1qpnpcky7wzwfh208h7sk683pcprlb";
  };
};
in stdenv.mkDerivation derivSrc

