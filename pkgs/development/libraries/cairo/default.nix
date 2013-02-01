{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, xcbSupport ? true # no longer experimental since 1.12
, gobjectSupport ? true, glib
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype, xlibs
, zlib, libpng, pixman
, gettext, libiconvOrEmpty
          # the test suite needs many deps. incl. cairo itself transitively (!)
, doCheck ? false, which, binutils, gawk, ghostscript, libspectre, poppler, librsvg
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

with { inherit (stdenv.lib) optional optionals; };

stdenv.mkDerivation rec {
  name = "cairo-1.12.12";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.xz";
    sha256 = "06nq0pzk2hyknp8cy1xn12s7i18sfcs0r3xfalilg1yckrsr7xhl";
  };

  buildInputs = with xlibs;
    [ pkgconfig x11 fontconfig libXrender ]

    ++ optionals xcbSupport [ libxcb xcbutil ]

    ++ optionals doCheck [ which ghostscript libspectre poppler glib librsvg ]
      #ToDo: can't find poppler_page_render

    # On non-GNU systems we need GNU Gettext for libintl.
    ++ optional (!stdenv.isLinux) gettext

    ++ libiconvOrEmpty;

  propagatedBuildInputs =
    [ freetype pixman ] ++
    optional gobjectSupport glib ++
    optional postscriptSupport zlib ++
    optional pngSupport libpng;

  configureFlags =
    [ "--enable-tee" ]
    ++ optional xcbSupport "--enable-xcb"
    ++ optional doCheck    "--enable-full-testing"
    ++ optional pdfSupport "--enable-pdf";

  preConfigure =
    stdenv.lib.optionalString doCheck
    "substituteInPlace src/check-doc-syntax.awk --replace /usr/bin/awk ${gawk}/bin/awk"
    +
  # On FreeBSD, `-ldl' doesn't exist.
    (stdenv.lib.optionalString stdenv.isFreeBSD
       '' for i in "util/"*"/Makefile.in" boilerplate/Makefile.in
          do
            cat "$i" | sed -es/-ldl//g > t
            mv t "$i"
          done
       '');

  enableParallelBuilding = true;

  inherit doCheck;

  # The default `--disable-gtk-doc' is ignored.
  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "A 2D graphics library with support for multiple output devices";

    longDescription = ''
      Cairo is a 2D graphics library with support for multiple output
      devices.  Currently supported output targets include the X
      Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.  Experimental backends include OpenGL
      (through glitz), XCB, BeOS, OS/2, and DirectFB.

      Cairo is designed to produce consistent output on all output
      media while taking advantage of display hardware acceleration
      when available (e.g., through the X Render Extension).
    '';

    homepage = http://cairographics.org/;

    licenses = [ "LGPLv2+" "MPLv1" ];

    platforms = stdenv.lib.platforms.all;

    maintainers = [ lib.maintainers.neznalek ];
  };
}
