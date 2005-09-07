{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "batik-1.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://apache.cs.uu.nl/dist/xml/batik/batik-1.6.zip;
    md5 = "edff288fc64f968ff96ca49763d50f3c";
  };

  buildInputs = [unzip];
}
