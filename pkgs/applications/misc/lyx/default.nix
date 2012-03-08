# I haven't put much effort into this expressions .. so some optional depencencies may be missing - Marc
{ fetchurl, stdenv, texLive, python, makeWrapper, pkgconfig
, libX11, qt
}:

stdenv.mkDerivation rec {
  version = "2.0.2";
  name = "lyx-${version}";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.0.x/${name}.tar.xz";
    sha256 = "065xvkdasgrv45f9mj1b3d1clkb3h39l9qjriy004i8d436wmsp5";
  };

  buildInputs = [texLive qt python makeWrapper pkgconfig ];

  meta = {
    description = "WYSIWYM frontend for LaTeX, DocBook, etc.";
    homepage = "http://www.lyx.org";
    license = "GPL2";
    maintainers = [ stdenv.lib.maintainers.neznalek ];
    platforms = stdenv.lib.platforms.linux;
  };
}
