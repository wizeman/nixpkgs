{ pkgs, fetchFromGitHub, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  version = "1.9.1-git-2015-08-27";
  name = "gmvault-${version}";

  src = fetchFromGitHub {
    owner = "gaubert";
    repo = "gmvault";
    rev = "7d948b430a80509b1d2fdb73155a9aef6d4f38b9";
    sha256 = "15nhc5qack9dv5z9vwi4d0viccxgxqs9p27ccz06nrwr4297dibd";
  };

  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [
    argparse Logbook IMAPClient chardet
  ];

  startScript = ./gmvault.py;

  postPatch = ''
    cat ${startScript} > etc/scripts/gmvault
    chmod +x etc/scripts/gmvault
  '';

  meta = {
    description = "Backup and restore your gmail account";
    homepage = "http://gmvault.org";
    license = pkgs.lib.licenses.agpl3Plus;
  };
}
