{ cabal, comonad, comonadTransformers, contravariant, distributive
, free, keys, mtl, representableFunctors, semigroupoids
, transformers, void
}:

cabal.mkDerivation (self: {
  pname = "adjunctions";
  version = "3.2";
  sha256 = "11fg5bw1n4pvx9bw8hiysymb8wn9m1zrzr7i0vrra7m59nvfqpw9";
  buildDepends = [
    comonad comonadTransformers contravariant distributive free keys
    mtl representableFunctors semigroupoids transformers void
  ];
  meta = {
    homepage = "http://github.com/ekmett/adjunctions/";
    description = "Adjunctions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
