{ cabal, algebra, deepseq, hashable, HUnit, primes, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, testFrameworkTh, typeLevelNumbers
}:

cabal.mkDerivation (self: {
  pname = "finite-field";
  version = "0.7.0";
  sha256 = "1s8qa182glb370s2szyjkc3d9hlkc2xf09kziciw0nyy7j5ncphv";
  buildDepends = [ algebra deepseq hashable typeLevelNumbers ];
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
