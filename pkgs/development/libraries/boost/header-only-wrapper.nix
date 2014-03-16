{ stdenv, fetchurl, boost }:

let
  version = stdenv.lib.removePrefix "boost-" boost.name;
  pkgid = stdenv.lib.replaceChars ["-" "."] ["_" "_"] boost.name;
in

stdenv.mkDerivation {
  name = "boost-headers-${version}";

  src = boost.src;

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
