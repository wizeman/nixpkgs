{ cabal }:

cabal.mkDerivation (self: {
  pname = "data-inttrie";
  version = "0.1.0";
  sha256 = "00kzf3cw0y0848cprmx3i7g70rmr92hhfzn60a2x98vb8f7y3814";
  meta = {
    homepage = "http://github.com/luqui/data-inttrie";
    description = "A lazy, infinite trie of integers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
