/* Automatically generated by `update-gcc.sh', do not edit.
   For GCC 4.6.1.  */
{ fetchurl, optional, version, langC, langCC, langFortran, langJava, langAda,
  langGo }:

assert version == "4.6.1";
optional /* langC */ true (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-core-${version}.tar.bz2";
  sha256 = "0bbb8f754a31f29013f6e9ad4c755d92bb0f154a665c4b623e86ae7174d98e33";
}) ++
optional langCC (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-g++-${version}.tar.bz2";
  sha256 = "44a91149bf4608aceb03b22209e5ec14ffe0c4003b11e3a368d6cebe5a327901";
}) ++
optional langFortran (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-fortran-${version}.tar.bz2";
  sha256 = "a0069a4452572b46cc20f1a1b52dc839b69c1d25e19c147a782e439d6be0156b";
}) ++
optional langJava (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-java-${version}.tar.bz2";
  sha256 = "728462275a0532714063803282d1ea815e35b5fd91a96f65a1f0a14da355765f";
}) ++
optional langAda (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-ada-${version}.tar.bz2";
  sha256 = "0e2958b7be2e7ec9d7847658262ce9276d6c75f91d53c48d7141848cfe3cd093";
}) ++
optional langGo (fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-go-${version}.tar.bz2";
  sha256 = "9512347a76c46528d25295cd762f262c8265e99cee497dc2d66caddf9c021198";
}) ++
[]
