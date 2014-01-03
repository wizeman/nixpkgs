{ cabal, comonad, comonadTransformers, contravariant, distributive
, free, keys, mtl, representableFunctors, semigroupoids
, transformers, void
}:

cabal.mkDerivation (self: {
  pname = "adjunctions";
  version = "3.2.1.1";
  sha256 = "1102l9zkl2crb33lbyb48ikqn5gxysvg037n9lf4js48v4shga5f";

  patches = [ ./loosen-deps.patch ]; # hand-added

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
