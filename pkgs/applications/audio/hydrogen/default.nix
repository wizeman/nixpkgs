{ stdenv, fetchurl, 
  alsaLib, boost, glib, jackaudio, libarchive, liblrdf, libsndfile,
  pkgconfig, qt4, scons, subversion }:

stdenv.mkDerivation rec {
  version = "0.9.5";
  name = "hydrogen-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/hydrogen/hydrogen-${version}.tar.gz";
    sha256 = "1hyri49va2ss26skd6p9swkx0kbr7ggifbahkrcfgj8yj7pp6g4n";
  };

  buildInputs = [ 
    alsaLib boost glib jackaudio libarchive liblrdf libsndfile
    pkgconfig qt4 scons subversion 
  ];

  patches = [ ./scons-env.patch ];

  # why doesn't scons find librdf?
  buildPhase = ''
    scons prefix=$out libarchive=1 lrdf=0 install
  '';

  installPhase = ":";

  meta = with stdenv.lib; {
    description = "Advanced drum machine";
    homepage = http://www.hydrogen-music.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
