{ stdenv, callPackage }:
callPackage ./makeRustcDerivation.nix {
  shortVersion = "1.0.0-beta";
  isRelease = true;
  srcSha = "94248e30487723ac6f6c34a0db5a21085c0b1338e6a32bd12b159e1d2cd80451";
  snapshotHashLinux686 = "1ef82402ed16f5a6d2f87a9a62eaa83170e249ec";
  snapshotHashLinux64 = "ef2154372e97a3cb687897d027fd51c8f2c5f349";
  snapshotHashDarwin686 = "0310b1a970f2da7e61770fd14dbbbdca3b518234";
  snapshotHashDarwin64 = "5f35d9c920b8083a7420ef8cf5b00d5ef3085dfa";
  snapshotDate = "2015-03-27";
  snapshotRev = "5520801";
  patches = [
    ./patches/beta.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}
