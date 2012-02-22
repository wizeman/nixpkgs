{ stdenv, fetchurl, zlib, readline }:

let version = "9.1.2"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0c6vwlfxppjvrikqfq6s87sxmxxvsx1qq03bwgk589sv9x8zym4d";
  };

  buildInputs = [ zlib readline ];

  enableParallelBuilding = true;

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.0";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
