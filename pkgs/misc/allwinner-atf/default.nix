{ stdenv, fetchFromGitHub }:

let
  platform = "sun50iw1p1";
in

stdenv.mkDerivation {
  name = "allwinner-atf-2017-10-17";

  src = fetchFromGitHub {
    owner = "apritzel";
    repo = "arm-trusted-firmware";
    rev = "91f2402d941036a0db092d5375d0535c270b9121";
    sha256 = "0lbipkxb01w97r6ah8wdbwxir3013rp249fcqhlzh2gjwhp5l1ys";
  };

  makeFlags = [ "PLAT=${platform}" "DEBUG=1" ];

  hardeningDisable = [ "stackprotector" ];

  buildFlags = [ "bl31" ];

  installPhase = ''
    mkdir -p $out

    cp build/${platform}/debug/bl31.bin $out/
  '';

  meta = with stdenv.lib; {
    # More info at https://github.com/u-boot/u-boot/blob/master/board/sunxi/README.sunxi64
    description = "ARM Trusted Firmware for Allwinner SoCs";
    homepage = "https://github.com/apritzel/arm-trusted-firmware";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}

