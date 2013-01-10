{ stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, libpng, zlib, cairo, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper, pixman, hunspell, libffi, curl

, # If you want the resulting program to call itself "Firefox" instead
  # of "Shiretoko" or whatever, enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
}:

assert stdenv.gcc ? libc && stdenv.gcc.libc != null;

rec {

  firefoxVersion = "14.0.1";
  thunderbirdVersion = "14.0";

  xulVersion = "14.0"; # this attribute is used by other packages

  src = fetchurl {
    url = "http://releases.mozilla.org/pub/mozilla.org/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.bz2";
    sha256 = "1al9x9skpn8mxhrwkdgh6vl99mpnmmx68vyrqdv86rvv43q8h6f2";
  };

  commonConfigureFlags =
    [ "--with-pthreads"
      "--with-system-libxul"
      "--with-system-nspr"
      "--with-system-nss"
      "--with-system-jpeg"
      "--with-system-zlib"
      "--with-system-bz2"
      "--with-system-png"  # png 1.5.x already merged in nixpkgs
      "--enable-system-hunspell"
      "--with-system-nss"
      "--enable-system-ffi" # only xul and ff option?
      # "--enable-default-toolkit=TODO?"
      # "--enable-startup-notification" # disabled
    ] ++ stdenv.lib.optional enableOfficialBranding "--enable-official-branding" ++ [
      #"--disable-crashreporter"
      # "--enable-tree-freetype" #TODO:what?
      "--disable-updater"
      "--disable-tests"
      "--enable-system-sqlite"
      #"--enable-safe-browsing" "--enable-url-classifier" #TODO:what?
      "--enable-optimize=-O2"
      "--enable-strip"
      # "--enable-shared-js" #TODO:what?
      "--enable-system-cairo"
      "--disable-necko-wifi"
    ];

    ffXulConfigureFlags =
      [ #"--enable-egl-xrender-composite" # what?
        "--disable-elf-hack"
        #"--enable-skia" # what?
        "--enable-system-pixman"
      ];
    /*
        "--enable-application=mail"
        "--enable-calendar"
        # "--enable-storage" #TODO:what?

      ];*/


  xulrunner = stdenv.mkDerivation rec {
    name = "xulrunner-${xulVersion}";
    
    inherit src;

    buildInputs =
      [ pkgconfig gtk perl zip libIDL libjpeg libpng zlib cairo bzip2
        python dbus dbus_glib pango freetype fontconfig xlibs.libXi
        xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt file
        alsaLib nspr nss libnotify yasm mesa
        xlibs.libXScrnSaver xlibs.scrnsaverproto
        xlibs.libXext xlibs.xextproto sqlite unzip makeWrapper
        pixman hunspell libffi curl/*crash-reporter*/
      ];

    configureFlags =
      [ "--enable-application=xulrunner"
        "--disable-javaxpcom"
      ] ++ commonConfigureFlags ++ ffXulConfigureFlags;

    enableParallelBuilding = true;

    patches = [
      ./system-cairo.patch # https://bugzil.la/722975
    ];

    # Hack to work around make's idea of -lbz2 dependency
    preConfigure =
      ''
        find . -name Makefile.in -execdir sed -i '{}' -e '1ivpath %.so ${
          stdenv.lib.concatStringsSep ":" 
            (map (s : s + "/lib") (buildInputs ++ [stdenv.gcc.libc]))
        }' ';'

        export NIX_LDFLAGS="$NIX_LDFLAGS -L$out/lib/xulrunner-${xulVersion}"

        mkdir ../objdir
        cd ../objdir
        configureScript=../mozilla-release/configure
      ''; # */

    # !!! Temporary hack.
    preBuild =
      ''
        export NIX_ENFORCE_PURITY=
      '';

    installFlags = "SKIP_GRE_REGISTRATION=1";

    postInstall = ''
      # Fix some references to /bin paths in the Xulrunner shell script.
      substituteInPlace $out/bin/xulrunner \
          --replace /bin/pwd "$(type -tP pwd)" \
          --replace /bin/ls "$(type -tP ls)"

      # Fix run-mozilla.sh search
      libDir=$(cd $out/lib && ls -d xulrunner-[0-9]*)
      echo libDir: $libDir
      test -n "$libDir"
      cd $out/bin
      mv xulrunner ../lib/$libDir/

      for i in $out/lib/$libDir/*; do 
          file $i;
          if file $i | grep executable &>/dev/null; then 
              echo -e '#! /bin/sh\n"'"$i"'" "$@"' > "$out/bin/$(basename "$i")";
              chmod a+x "$out/bin/$(basename "$i")";
          fi;
      done
      for i in $out/lib/$libDir/*.so; do
          patchelf --set-rpath "$(patchelf --print-rpath "$i"):$out/lib/$libDir" $i || true
      done
      for i in $out/lib/$libDir/{xpcshell,plugin-container}; do
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
      [ pkgconfig gtk perl zip libIDL libjpeg zlib cairo bzip2 python
        dbus dbus_glib pango freetype fontconfig alsaLib nspr nss libnotify
        xlibs.pixman yasm mesa sqlite file unzip
      ];

    propagatedBuildInputs = [xulrunner];

    configureFlags =
      [ "--enable-application=browser"
        "--with-libxul-sdk=${xulrunner}/lib/xulrunner-devel-${xulrunner.version}"
        "--enable-chrome-format=jar"
        "--disable-elf-hack"
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
        for j in $out/bin/*; do 
	    i="$(readlink "$j")";
            file $i;
            if file $i | grep executable &>/dev/null; then 
	        rm "$out/bin/$(basename "$i")"
                echo -e '#! /bin/sh\nexec "'"$i"'" "$@"' > "$out/bin/$(basename "$i")"
                chmod a+x "$out/bin/$(basename "$i")"
            fi;
        done;
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



  thunderbird = stdenv.mkDerivation rec {
    name = "thunderbird-${thunderbirdVersion}";

    src = fetchurl {
      url = "http://releases.mozilla.org/pub/mozilla.org/thunderbird/releases/${thunderbirdVersion}/source/${name}.source.tar.bz2";
      sha256 = "0fhcy4qbksfgrddwf719d10zry4yfi0h9kw13d6x9sfwq615w8i9";
    };

    enableParallelBuilding = true;

    buildInputs =
      [ pkgconfig perl python zip unzip bzip2 gtk dbus_glib alsaLib libIDL nspr
        libnotify cairo pixman fontconfig yasm mesa nss hunspell
        libjpeg libpng
      ];

    # fix some paths in pngPatch
    # prePatch = ''
    #   substitute ${pngPatch} png.patch --replace "mozilla-release/modules/" "comm-release/mozilla/modules/"
    #   '';

    patches = [
      # "png.patch" # produced by postUnpack

      # Fix weird dependencies such as a so file which depends on "-lpthread".
      # ./thunderbird-build-deps.patch
      ./xpidl-build.patch # https://bugzil.la/736961
      ./system-cairo.patch # https://bugzil.la/722975
    ];

    configureFlags =
      [ "--with-pthreads"
        "--with-system-libxul"
        "--with-system-nspr"
        "--with-system-nss"
        "--with-system-jpeg"
        "--with-system-zlib"
        "--with-system-bz2"
        "--with-system-png"  # png 1.5.x already merged in nixpkgs
        "--enable-system-hunspell"
        "--enable-application=mail"
        # "--enable-default-toolkit=TODO?"
        # "--enable-startup-notification" # disabled
        "--enable-calendar"
      ] ++ stdenv.lib.optional enableOfficialBranding "--enable-official-branding" ++ [
        #"--disable-crashreporter"
        # "--enable-tree-freetype" #TODO:what?
        "--disable-updater"
        "--disable-tests"
        # "--enable-storage" #TODO:what?
        "--enable-system-sqlite"
        #"--enable-safe-browsing" "--enable-url-classifier" #TODO:what?
        "--enable-optimize=-O2"
        "--enable-strip"
        # "--enable-shared-js" #TODO:what?
        "--enable-system-cairo"
        "--disable-necko-wifi"
      ];

    # The Thunderbird Makefiles refer to the variables LIBXUL_DIST,
    # prefix, and PREFIX in some places where they are not set.  In
    # particular, there are some linker flags like
    # `-rpath-link=$(LIBXUL_DIST)/bin'.  Since this expands to
    # `-rpath-link=/bin', the build fails due to the purity checks in
    # the ld wrapper.  So disable the purity check for now.
    preBuild = "NIX_ENFORCE_PURITY=0";

    # This doesn't work:
    #makeFlags = "LIBXUL_DIST=$(out) prefix=$(out) PREFIX=$(out)";

    postInstall =
      ''
        # Fix some references to /bin paths in the Xulrunner shell script.
        substituteInPlace $out/lib/thunderbird-*/thunderbird \
            --replace /bin/pwd "$(type -tP pwd)" \
            --replace /bin/ls "$(type -tP ls)"

        # Create a desktop item.
        mkdir -p $out/share/applications
        cat > $out/share/applications/thunderbird.desktop <<EOF
        [Desktop Entry]
        Type=Application
        Exec=$out/bin/thunderbird
        Icon=$out/lib/thunderbird-${thunderbirdVersion}/chrome/icons/default/default256.png
        Name=Thunderbird
        GenericName=Mail Reader
        Categories=Application;Network;
        EOF
      '';

    meta = with stdenv.lib; {
      description = "Mozilla Thunderbird, a full-featured email client";
      homepage = http://www.mozilla.org/thunderbird/;
      license =
        # Official branding implies thunderbird name and logo cannot be reuse,
        # see http://www.mozilla.org/foundation/licensing.html
        if enableOfficialBranding then licenses.proprietary else licenses.mpl11;
      maintainers = with maintainers; [ pierron ];
      platforms = with platforms; linux;
    };
  };
}
