{ stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg_turbo, libpng, zlib, cairo, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper, pysqlite, ply
, pixman, hunspell, libffi, curl, libvpx, gstreamer, gst_plugins_base, libevent
, # If you want the resulting program to call itself "Firefox" instead
  # of "Shiretoko" or whatever, enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
  , libproxy
}:

assert stdenv.gcc ? libc && stdenv.gcc.libc != null;

rec {

  firefoxVersion = "18.0.1";

  xulVersion = "18.0.1"; # this attribute is used by other packages


  src = fetchurl {
    urls = [
        # It is better to use this url for official releases, to take load off Mozilla's ftp server.
        "http://releases.mozilla.org/pub/mozilla.org/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.bz2"
        # Fall back to this url for versions not available at releases.mozilla.org.
        "ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.bz2"
    ];
    sha256 = "0zvbml0mas6h9hd1zr6khfgnygh7a19qj66yck1m1f9x2pakj074";
  };

  commonConfigureFlags = [ # ordered as in ./configure --help
    "--with-system-ply"
    #"--with-pthreads" caused to pass -lpthread instead of -pthread
    "--with-system-nspr"
    "--with-system-libevent"
    #"--with-system-nss" # build of xulrunner fails with a -fPIC error
    "--with-system-jpeg" # was too old in nixpkgs
    "--with-system-zlib"
    "--with-system-bz2"
    "--with-system-png" # we have system-wide APNG support now

    "--enable-system-hunspell"
    "--enable-system-ffi" # only xul and ff option?
    #"--enable-startup-notification" # disabled
    #"--enable-gnomevfs" # +gconf, gnomeui?
    "--enable-libproxy"

    # more media stuff
    "--with-system-libvpx"
    #"--enable-pulsaudio" # experimental
    "--enable-gstreamer" # ToTest, mainly for HTML5 videos

    "--disable-crashreporter" # why?
    # "--enable-tree-freetype" #TODO:what?
    "--disable-updater"
    "--disable-tests"
    "--enable-system-sqlite"
    #"--enable-safe-browsing" "--enable-url-classifier" #TODO:what?

    #"--enable-egl-xrender-composite" # problems with bad c++ calls in gfx/gl/GLContextProviderEGL.cpp
    # moreover it's said to work bad with many Linux GPU drivers

    "--enable-optimize=-O2"
    "--enable-strip" # minimal diagnostics
    "--disable-elf-hack" # why?

    #"--enable-shared-js" #TODO:what?
    #"--enable-skia" # what?
    "--enable-system-cairo" # was disabled because our Cairo was too old
    "--enable-system-pixman"
    "--disable-necko-wifi" # maybe we want to enable this at some point
  ];

  commonBuildInputs = [
    pkgconfig gtk perl unzip zip
    dbus dbus_glib alsaLib
    # checking for doxygen and autoconf
    python ply
    nspr libevent #nss
    libjpeg_turbo zlib bzip2 libpng
    hunspell libffi libproxy
    libvpx gstreamer gst_plugins_base
    sqlite cairo pixman
    pango freetype mesa
    file
    ];


    ffXulConfigureFlags =
      [
      ];


  xulrunner = stdenv.mkDerivation rec {
    name = "xulrunner-${xulVersion}";

    inherit src;

    buildInputs = commonBuildInputs ++ [ makeWrapper ];

/*
    xxxx =  [ pkgconfig gtk perl zip libIDL libjpeg_turbo libpng zlib cairo bzip2
        python dbus dbus_glib pango freetype fontconfig xlibs.libXi
        xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt file
        nspr nss libnotify pixman yasm mesa
        xlibs.libXScrnSaver xlibs.scrnsaverproto pysqlite
        xlibs.libXext xlibs.xextproto sqlite unzip makeWrapper
        hunspell/*?needed?*#/ libffi curl/*crash-reporter*#/
     ];
*/
    configureFlags =
      [ "--enable-application=xulrunner"
      ] ++ commonConfigureFlags ++ ffXulConfigureFlags;

    enableParallelBuilding = true;

    patches = [
      ./system-cairo.patch # https://bugzil.la/722975
      #./fpermissive.patch # degrade some bad-style c++ errors to warnings (>=gcc-4.6)
    ];

    preConfigure =
      ''
        #export NIX_LDFLAGS="$NIX_LDFLAGS -L$out/lib/xulrunner-${xulVersion}"

        for f in `find .  -name Makefile.in -o -name configure`; do
          substituteInPlace "$f" --replace -lpthread -pthread
        done

        mkdir ../objdir
        cd ../objdir
        configureScript=../mozilla-release/configure
      ''; # */

        #echo '\nCXXFLAGS += -fPIC\n' >> memory/mozalloc/Makefile.in

    #installFlags = "SKIP_GRE_REGISTRATION=1";

    postInstall = ''
      # Fix run-mozilla.sh search
      libDir=$(cd $out/lib && ls -d xulrunner-[0-9]*)
      echo libDir: $libDir
      test -n "$libDir"
      cd $out/bin
      rm xulrunner

      for i in $out/lib/$libDir/*; do
          file $i;
          if file $i | grep executable &>/dev/null; then
              echo -e '#! /bin/sh\nexec "'"$i"'" "$@"' > "$out/bin/$(basename "$i")";
              chmod a+x "$out/bin/$(basename "$i")";
          fi;
      done
      for i in $out/lib/$libDir/*.so; do
          patchelf --set-rpath "$(patchelf --print-rpath "$i"):$out/lib/$libDir" $i || true
      done
      for i in $out/lib/$libDir/{plugin-container,xulrunner,xulrunner-stub}; do
          wrapProgram $i --prefix LD_LIBRARY_PATH ':' "$out/lib/$libDir"
      done
      rm -f $out/bin/run-mozilla.sh
    ''; # */

    meta = {
      description = "Mozilla Firefox XUL runner";
      homepage = http://www.mozilla.com/en-US/firefox/;
    };

    passthru = { inherit gtk; version = xulVersion; };
  };


  firefox = stdenv.mkDerivation rec {
    name = "firefox-${firefoxVersion}";

    inherit src;

    enableParallelBuilding = true;

    buildInputs =
      [ pkgconfig gtk perl zip libIDL libjpeg_turbo zlib cairo bzip2 python
        dbus dbus_glib pango freetype fontconfig alsaLib nspr nss libnotify
        pixman yasm mesa sqlite file unzip pysqlite hunspell
      ];

    propagatedBuildInputs = [xulrunner];

    configureFlags =
      [ "--enable-application=browser"
        "--with-libxul-sdk=${xulrunner}/lib/xulrunner-devel-${xulrunner.version}"
        "--enable-chrome-format=jar"
      ]
      ++ commonConfigureFlags
      ++ stdenv.lib.optional enableOfficialBranding "--enable-official-branding";

    # Hack to work around make's idea of -lbz2 dependency
    preConfigure =
      ''
        find . -name Makefile.in -execdir sed -i '{}' -e '1ivpath %.so ${
          stdenv.lib.concatStringsSep ":"
            (map (s : s + "/lib") (buildInputs ++ [stdenv.gcc.libc]))
        }' ';'
      '';

    postInstall =
      ''
        ln -s ${xulrunner}/lib/xulrunner-${xulrunner.version} $(echo $out/lib/firefox-*)/xulrunner
        cd "$out/lib/"firefox-*
        rm firefox
        echo -e '#!${stdenv.shell}\nexec ${xulrunner}/bin/xulrunner "'"$PWD"'/application.ini" "$@"' > firefox
        chmod a+x firefox
      ''; # */

    meta = {
      description = "Mozilla Firefox - the browser, reloaded";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = [ stdenv.lib.maintainers.eelco ];
    };

    passthru = {
      inherit gtk xulrunner nspr;
      isFirefox3Like = true;
    };
  };
}
