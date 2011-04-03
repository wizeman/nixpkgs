{stdenv, fetchurl, openssl
, readlineSupport ? true, readline
, guiSupport ? false, qt4}:

assert readlineSupport -> readline!=null;
assert guiSupport -> qt4!=null;

let
  buildDirs = "wpa_supplicant wpa_passphrase wpa_cli";
  lib = stdenv.lib;

  extraConfig = lib.concatStringsSep "\n" (
    ["CONFIG_DEBUG_SYSLOG=y"]
    ++ lib.optional readlineSupport "CONFIG_READLINE=y"
  );
in

stdenv.mkDerivation rec {
  name = "wpa_supplicant-0.7.3";

  src = fetchurl {
    url = "http://hostap.epitest.fi/releases/${name}.tar.gz";
    sha256 = "0hwlsn512q2ps8wxxjmkjfdg3vjqqb9mxnnwfv1wqijkm3551kfh";
  };

  preBuild = ''
    cd wpa_supplicant
    cp defconfig .config
    echo "${extraConfig}" >> .config
    substituteInPlace Makefile --replace /usr/local $out
    makeFlagsArray=(ALL="${buildDirs} ${if guiSupport then "wpa_gui-qt4" else ""}")
  '';

  buildInputs = [openssl]
    ++ lib.optional readlineSupport readline
    ++ lib.optional guiSupport qt4;

  # qt gui doesn't install because the executable is named differently from directory name
  # so never include wpa_gui_-qt4 in buildDirs when running make install
  preInstall = if guiSupport then ''
    makeFlagsArray=(ALL="${buildDirs}")
  '' else null;

  postInstall = ''
    ensureDir $out/share/man/man5 $out/share/man/man8
    cp doc/docbook/*.5 $out/share/man/man5/
    cp doc/docbook/*.8 $out/share/man/man8/
  ''
  + (if guiSupport then ''
      pwd
      cp wpa_gui-qt4/wpa_gui $out/sbin
    '' else "");

  meta = {
    homepage = http://hostap.epitest.fi/wpa_supplicant/;
    description = "A tool for connecting to WPA and WPA2-protected wireless networks";
    license = "GPLv2";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };

}
