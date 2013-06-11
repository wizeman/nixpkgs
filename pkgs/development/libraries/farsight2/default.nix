{ stdenv, fetchurl, libnice, pkgconfig, python, gstreamer_0_10, gst_plugins_base_0_10
, gst_python_0_10, pygobject, gupnp_igd }:

stdenv.mkDerivation rec {
  name = "farsight2-0.0.31";

  src = fetchurl {
    url = "http://farsight.freedesktop.org/releases/farsight2/${name}.tar.gz";
    sha256 = "16qz4x14rdycm4nrn5wx6k2y22fzrazsbmihrxdwafx9cyf23kjm";
  };

  buildInputs = [ libnice python pygobject gupnp_igd ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gstreamer_0_10 gst_plugins_base_0_10 gst_python_0_10 ];

  meta = {
    homepage = http://farsight.freedesktop.org/wiki/;
    description = "Audio/Video Communications Framework";
  };
}
