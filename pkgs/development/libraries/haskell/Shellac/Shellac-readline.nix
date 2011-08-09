{ cabal, Shellac, readline }:

cabal.mkDerivation (self: {
  pname = "Shellac-readline";
  version = "0.9";
  sha256 = "3edffecf2225c199f0a4df55e3685f7deee47755ae7f8d03f5da7fac3c2ab878";
  buildDepends = [ Shellac readline ];
  meta = {
    description = "Readline backend module for Shellac";
    license = self.stdenv.lib.licenses.bsd3;
  };
})
