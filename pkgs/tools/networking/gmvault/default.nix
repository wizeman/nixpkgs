{ pkgs, fetchFromGitHub, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  version = "1.9.1-git-2015-08-06";
  name = "gmvault-${version}";

  src = fetchFromGitHub {
    owner = "gaubert";
    repo = "gmvault";
    rev = "4de847437a9ac29368d2002e8fa8c7f3630dc948";
    sha256 = "16nkpwxaj1rigjqxd159l7ss2p8rywl2vd0cj852ni4vk5n9k2p2";
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
