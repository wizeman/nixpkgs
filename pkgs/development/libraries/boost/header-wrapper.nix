{ stdenv, fetchurl, buildEnv }: libs:

let
  version = (builtins.parseDrvName libs.name).version;
  pkgid = "boost_" + stdenv.lib.replaceChars ["-" "."] ["_" "_"] version;

  boost = (buildEnv {
    name = "boost-${version}";
    paths = boost.list;
  }) // { inherit libs headers; list = [ libs headers ]; };

headers =
stdenv.mkDerivation {
  name = "boost-headers-${version}";

  src = libs.src;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    tar xf $src -C $out/include --strip-components=1 ${pkgid}/boost
  '' + /* relativize filenames in assert messages to avoid runtime dependency */ ''
    (
      cd "$out"
      find ./include -name '*.hpp' -exec sed '1i#line 1 "{}"' -i '{}' \;
    )
  '';

  preferLocalBuild = true;

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.viric stdenv.lib.maintainers.simons ];
  };
}

; in boost

