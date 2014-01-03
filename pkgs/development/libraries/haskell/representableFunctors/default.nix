{ fetchurl, cabal, comonad, comonadsFd, comonadTransformers, contravariant
, distributive, free, keys, mtl, semigroupoids, semigroups
, transformers
}:

cabal.mkDerivation (self: {
  pname = "representable-functors";
  version = "3.2.0.2";
  sha256 = "156rhm9hqxkwpv4ppg6647gz2q95mp61rx6ii0nk6i0ygmjvw1l2";

  patches = [(fetchurl { # hand-added
    url = "https://raw.github.com/gentoo-haskell/gentoo-haskell/7ae0b0d0167816a7eedc4db4e50716311e96a731"
      + "/dev-haskell/representable-functors/files/representable-functors-3.2.0.2-comonad-4.0.patch";
    sha256 = "1hr71dshvqip57brmxyy38gplsmvdvf12wfi7zvg3637arpjf54x";
  })];

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
