{ cabal, comonad, comonadsFd, comonadTransformers, contravariant
, distributive, free, keys, mtl, semigroupoids, semigroups
, transformers
}:

cabal.mkDerivation (self: {
  pname = "representable-functors";
  version = "3.1";
  sha256 = "04yp1mdqvd2xpz467wz1pdayvwhxwikv3r4wky1fpa23x5jvwwq7";
  buildDepends = [
    comonad comonadsFd comonadTransformers contravariant distributive
    free keys mtl semigroupoids semigroups transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/representable-functors/";
    description = "Representable functors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
