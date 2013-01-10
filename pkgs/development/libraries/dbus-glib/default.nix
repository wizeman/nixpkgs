{ stdenv, fetchurl, pkgconfig, expat, gettext, libiconv, dbus, glib }:

stdenv.mkDerivation rec {
  name = "dbus-glib-0.100";

  src = fetchurl {
    url = "${meta.homepage}/releases/dbus-glib/${name}.tar.gz";
    sha256 = "01a6dp28bgrsm2amwpiqdxk1sibybpcqsy8p708915b599cggpc0";
  };

  buildNativeInputs = [ pkgconfig gettext ];

  buildInputs = [ expat ] ++ stdenv.lib.optional (!stdenv.isLinux) libiconv;

  propagatedBuildInputs = [ dbus glib ];

  passthru = { inherit dbus glib; };

  meta = {
    homepage = http://dbus.freedesktop.org;
    license = "AFL-2.1 or GPL-2";
    description = "Obsolete glib bindings for D-Bus lightweight IPC mechanism";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
