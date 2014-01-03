{ cabal, algebra, deepseq, HUnit, primes, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, testFrameworkTh
, typeLevelNumbers
}:

cabal.mkDerivation (self: {
  pname = "finite-field";
  version = "0.6.0";
  sha256 = "11zayi2cj3p4ky1x28w9czrr5r5fv1vcwxxhy4nr5zwsr442y2qm";
  buildDepends = [ algebra deepseq typeLevelNumbers ];
  testDepends = [
    HUnit primes QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkTh typeLevelNumbers
  ];
  meta = {
    description = "Finite Fields";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
