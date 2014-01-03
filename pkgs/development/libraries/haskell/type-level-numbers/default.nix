{ cabal }:

cabal.mkDerivation (self: {
  pname = "type-level-numbers";
  version = "0.1.0.4";
  sha256 = "1c89v30ir1jvvh909r0i11npfh5zwcjwxrarcym9njkpi0yr19d3";
  meta = {
    description = "Type level numbers implemented using type families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
