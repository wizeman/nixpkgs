{ fetchzip, stdenv, autoconf, automake, ocamlPackages, coq, isabelle }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "unstable";

  src = fetchzip {
    url = "https://gitlab.inria.fr/why3/why3/repository/archive.tar.gz?ref=4bfdab0de88488896d826b0f77a8dae3c164a486";
    sha256 = "0f237y8r1z8bpywjkx914xy2ri2jcjx1jnd1kq8zvgdrxfc78m0y";
  };

  buildInputs = [ autoconf automake isabelle ] ++ (with ocamlPackages; [
      ocaml findlib lablgtk ocamlgraph zarith menhir ]) ++
    stdenv.lib.optionals (ocamlPackages.ocaml == coq.ocaml ) [
      coq coq.camlp5
    ];

  preConfigure = "autoconf && (automake --add-missing 2> /dev/null || true)";

  installTargets = [ "install" "install-lib" ];

  meta = with stdenv.lib; {
    description = "A platform for deductive program verification";
    homepage    = "http://why3.lri.fr/";
    license     = licenses.lgpl21;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
