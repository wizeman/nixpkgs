{ stdenv, fetchurl, bc, dtc, python2, allwinner-atf
, hostPlatform
}:

let
  buildUBoot = { targetPlatforms
            , filesToInstall
            , installDir ? "$out"
            , defconfig
            , extraMeta ? {}
            , ... } @ args:
           stdenv.mkDerivation (rec {

    name = "uboot-${defconfig}-${version}";
    version = "2017.09";

    src = fetchurl {
      url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
      sha256 = "0i4p12ar0zgyxs8hiqgp6p6shvbw4ikkvryd4mh70bppyln5zldj";
    };

    patches = [ ./rpi.patch ./pathlen.patch ./orangepi_prime.patch ];

    nativeBuildInputs = [ bc dtc python2 ];

    hardeningDisable = [ "all" ];

    postPatch = ''
      patchShebangs tools
    '';

    configurePhase = ''
      make ${defconfig}
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p ${installDir}
      cp ${stdenv.lib.concatStringsSep " " filesToInstall} ${installDir}

      runHook postInstall
    '';

    enableParallelBuilding = true;
    dontStrip = true;

    crossAttrs = {
      makeFlags = [
        "ARCH=${hostPlatform.platform.kernelArch}"
        "CROSS_COMPILE=${stdenv.cc.prefix}"
      ];
    };

    meta = with stdenv.lib; {
      homepage = http://www.denx.de/wiki/U-Boot/;
      description = "Boot loader for embedded systems";
      license = licenses.gpl2;
      maintainers = [ maintainers.dezgeg ];
      platforms = targetPlatforms;
    } // extraMeta;
  } // args);

in rec {
  inherit buildUBoot;

  ubootTools = buildUBoot rec {
    defconfig = "allnoconfig";
    installDir = "$out/bin";
    buildFlags = "tools NO_SDL=1";
    dontStrip = false;
    targetPlatforms = stdenv.lib.platforms.linux;
    filesToInstall = ["tools/dumpimage" "tools/mkenvimage" "tools/mkimage"];
  };

  ubootA20OlinuxinoLime = buildUBoot rec {
    defconfig = "A20-OLinuXino-Lime_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootBananaPi = buildUBoot rec {
    defconfig = "Bananapi_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootBeagleboneBlack = buildUBoot rec {
    defconfig = "am335x_boneblack_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["MLO" "u-boot.img"];
  };

  ubootJetsonTK1 = buildUBoot rec {
    defconfig = "jetson-tk1_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot" "u-boot.dtb" "u-boot-dtb-tegra.bin" "u-boot-nodtb-tegra.bin"];
  };

  ubootOdroidXU3 = buildUBoot rec {
    defconfig = "odroid-xu3_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-dtb.bin"];
  };

  ubootOrangePiPrime = buildUBoot rec {
    defconfig = "orangepi_prime_defconfig";
    BL31 = "${allwinner-atf}/bl31.bin";
    targetPlatforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.itb" "spl/sunxi-spl.bin"];
  };

  ubootPcduino3Nano = buildUBoot rec {
    defconfig = "Linksprite_pcDuino3_Nano_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootRaspberryPi = buildUBoot rec {
    defconfig = "rpi_defconfig";
    targetPlatforms = ["armv6l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi2 = buildUBoot rec {
    defconfig = "rpi_2_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi3_32bit = buildUBoot rec {
    defconfig = "rpi_3_32b_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi3_64bit = buildUBoot rec {
    defconfig = "rpi_3_defconfig";
    targetPlatforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootUtilite = buildUBoot rec {
    defconfig = "cm_fx6_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-with-nand-spl.imx"];
    buildFlags = "u-boot-with-nand-spl.imx";
    postConfigure = ''
      cat >> .config << EOF
      CONFIG_CMD_SETEXPR=y
      EOF
    '';
    # sata init; load sata 0 $loadaddr u-boot-with-nand-spl.imx
    # sf probe; sf update $loadaddr 0 80000
  };

  ubootWandboard = buildUBoot rec {
    defconfig = "wandboard_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.img" "SPL"];
  };
}
