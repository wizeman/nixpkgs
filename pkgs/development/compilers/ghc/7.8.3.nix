{ stdenv, fetchurl, ghc, perl, gmp, ncurses }:

let
  # The "-Wa,--noexecstack" options might be needed only with GNU ld (as opposed
  # to the gold linker). It prevents binaries' stacks from being marked as
  # executable, which fails to run on a grsecurity/PaX kernel.
  ghcFlags = "-optc-Wa,--noexecstack -opta-Wa,--noexecstack";
  cFlags = "-Wa,--noexecstack";

in stdenv.mkDerivation rec {
  version = "7.8.3";
  name = "ghc-${version}";

  src = fetchurl {
    url = "http://www.haskell.org/ghc/dist/7.8.3/${name}-src.tar.xz";
    sha256 = "0n5rhwl83yv8qm0zrbaxnyrf8x1i3b6si927518mwfxs96jrdkdh";
  };

  buildInputs = [ ghc perl gmp ncurses ];

  enableParallelBuilding = true;

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"
    DYNAMIC_BY_DEFAULT = NO
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    # Set ghcFlags for building ghc itself
    SRC_HC_OPTS += ${ghcFlags}
    SRC_CC_OPTS += ${cFlags}
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure

  '' + stdenv.lib.optionalString stdenv.isLinux ''
    # Set ghcFlags for binaries that ghc builds
    sed -i -e 's|"\$topdir"|"\$topdir" ${ghcFlags}|' ghc/ghc.wrapper

  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '';

  configureFlags = "--with-gcc=${stdenv.gcc}/bin/gcc";

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" "--keep-file-symbols" ];

  meta = with stdenv.lib; {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = [ maintainers.marcweber maintainers.andres maintainers.simons ];
    inherit (ghc.meta) license;
    # Filter old "i686-darwin" platform which is unsupported these days.
    platforms = filter (x: elem x platforms.all) ghc.meta.platforms;
    # Disable Darwin builds: <https://github.com/NixOS/nixpkgs/issues/2689>.
    hydraPlatforms = filter (x: !elem x platforms.darwin) meta.platforms;
  };

}
