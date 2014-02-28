{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng, libX11
, jasper, libintlOrEmpty, gobjectIntrospection, writeScript }:

let
  ver_maj = "2.30";
  ver_min = "4";
  loader_dir = "lib/gdk-pixbuf-2.0/2.10.0";
in
stdenv.mkDerivation rec {
  name = "gdk-pixbuf-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/${ver_maj}/${name}.tar.xz";
    sha256 = "0ldhpdalbyi6q5k1dz498i9hqcsd51yxq0f91ck9p0h4v38blfx1";
  };

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 libintlOrEmpty ];

  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  configureFlags = "--with-libjasper --with-x11"
    + stdenv.lib.optionalString (gobjectIntrospection != null) " --enable-introspection=yes"
    ;

  enableParallelBuilding = true;
  doCheck = true;

  postInstall = "rm -rf $out/share/gtk-doc";

  setupHook = writeScript "gdk-pixbuf_setup-hook.sh" ''
    gen-gdk-pixbuf-cache() {
      mkdir -p "$out/${loader_dir}"
      @out@/bin/gdk-pixbuf-query-loaders $(
        for pkg in $crossPkgs $nativePkgs "$out"; do
          find "$pkg"/lib/gdk-pixbuf* -name "libpixbufloader-*.so"
        done | sort -u
      ) > "$out/${loader_dir}/loaders.cache"
    }
    gdk-pixbuf-wrapLine() {
      if [ ! -f "$out/${loader_dir}/loaders.cache" ]; then
        gen-gdk-pixbuf-cache
      fi
      echo -n -- --set GDK_PIXBUF_MODULE_FILE '"$out/${loader_dir}/loaders.cache"'
    }
  '';


  meta = {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.unix;
  };
}
