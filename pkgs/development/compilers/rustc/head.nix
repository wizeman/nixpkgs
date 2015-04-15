{ stdenv, callPackage }:
callPackage ./makeRustcDerivation.nix {
  shortVersion = "1.0.0-dev";
  isRelease = false;
  # src rev for master on 2015-05-11
  srcRev = "4b88e8f63eeaf557c916a0a1e73150b028c44c52";
  srcSha = "0gds85i8wm9snk928fxbpg6dpz1vw3qvcnvs5a4vyjs1hcyizdkq";
  snapshotHashLinux686 = "0bc8cffdce611fb71fd7d3d8e7cdbfaf748a4f16";
  snapshotHashLinux64 = "94089740e48167c5975c92c139ae9c286764012f";
  snapshotHashDarwin686 = "54cc35e76497e6e94fddf38d6e40e9d168491ddb";
  snapshotHashDarwin64 = "43a1c1fba0d1dfee4c2ca310d506f8f5f51b3f6f";
  snapshotDate = "2015-04-27";
  snapshotRev = "857ef6e";
  patches = [
    ./patches/head.patch
  ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}

