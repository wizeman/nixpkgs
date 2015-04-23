# This file defines the source of Rust / cargo's crates registry
#
# buildRustPackage will automatically download dependencies from the registry
# version that we define here. If you're having problems downloading / finding
# a Rust library, try updating this to a newer commit.

{ fetchgit }:

fetchgit {
  url = git://github.com/rust-lang/crates.io-index.git;

  # 2015-04-23
  rev = "965b634156cc5c6f10c7a458392bfd6f27436e7e";
  sha256 = "1hbl3g1d6yz6x2fm76dxmcn8rdrmri4l9n6flvv0pkn4hsid7zw1";

  # cargo needs the 'master' branch to exist
  leaveDotGit = true;
  branchName = "master";
}
