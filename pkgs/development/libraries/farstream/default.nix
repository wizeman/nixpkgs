{ stdenv, fetchurl, libnice, pkgconfig, python, gstreamer, gst_plugins_base
, pygobject, gupnp_igd
, gst_plugins_good, gst_plugins_bad, gst_libav
}:

stdenv.mkDerivation rec {
  name = "farstream-0.2.3";
  src = fetchurl {
    url = "http://www.freedesktop.org/software/farstream/releases/farstream/${name}.tar.gz";
    sha256 = "15h4qv30ql3rnmlm4ac3h7rplvj7125z14fbfh1zrkajjaa3bxdz";
  };

  buildInputs = [ libnice python pygobject gupnp_igd libnice ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gstreamer gst_plugins_base
    gst_plugins_good gst_plugins_bad gst_libav
    ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/Farstream;
    description = "Audio/Video Communications Framework formely known as farsight";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
