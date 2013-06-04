{ stdenv, fetchurl, automake
, withInternalGlib ? true, glib, pkgconfig # too big dependency to enable by default
}:

stdenv.mkDerivation (rec {
  name = "pkg-config-0.28";

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "http://pkgconfig.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0igqq5m204w71m11y0nipbdf5apx87hwfll6axs12hn4dqfb6vkb";
  };

  buildInputs = stdenv.lib.optionals (!withInternalGlib)
    [ glib (pkgconfig.override { withInternalGlib = true; }) ];

  configureFlags = stdenv.lib.optional withInternalGlib "--with-internal-glib";

  meta = {
    description = "A tool that allows packages to find out information about other packages";
    homepage = http://www.freedesktop.org/wiki/Software/pkg-config/;
    platforms = stdenv.lib.platforms.all;
  };

} // (if stdenv.system == "mips64el-linux" then
  {
    preConfigure = ''
      cp -v ${automake}/share/automake*/config.{sub,guess} .
    '';
  } else {}))
