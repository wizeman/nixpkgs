{ stdenv, pam, pkgconfig, libxcb, glib, libXdmcp, itstool, libxml2, intltool, x11, libxklavier, libgcrypt, makeWrapper
, fetchbzr, autoconf, automake, libtool, m4, gobjectIntrospection, gnome }:

let
  #ver_maj = "1.6";
  #ver_min = "0";
  #version = "${ver_maj}.${ver_min}";
  ver_bzr = 1656;
  version = "bzr";
in
stdenv.mkDerivation rec {
  name = "lightdm-${version}";

  #src = fetchurl {
  #  url = "${meta.homepage}/${ver_maj}/${version}/+download/${name}.tar.xz";

  src = fetchbzr {
    url = "http://bazaar.launchpad.net/~lightdm-team/lightdm/trunk";
    revision = ver_bzr;
    sha256 = "0n8mj6gr64rcqza28149jl7a32rfg18z5x4wzbm5xil0xa6q2wa5";
  };

  patches = [ ./lightdm.patch ];
  patchFlags = "-p0";

  buildInputs = [
    pkgconfig pam libxcb glib libXdmcp itstool libxml2 intltool libxklavier libgcrypt makeWrapper
    autoconf automake libtool m4 gobjectIntrospection gnome.gtkdoc
  ];

  postPatch = "sed '/^SUBDIRS/s/doc help//' -i Makefile.am"; # some problems there
  configurePhase = "./autogen.sh --enable-liblightdm-gobject --prefix=$out";

  meta = {
    homepage = http://launchpad.net/lightdm;
    platforms = stdenv.lib.platforms.linux;
  };
}
