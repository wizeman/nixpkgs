{ cabal, void }:

cabal.mkDerivation (self: {
  pname = "categories";
  version = "1.0.5";
  sha256 = "16vkxlb0l4f0vinc2j6ijlwpcv1ragh70c59a0r2fzmf6mxh3kkz";
  buildDepends = [ void ];
  meta = {
    homepage = "http://github.com/ekmett/categories";
    description = "Categories";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
