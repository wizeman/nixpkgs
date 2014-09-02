{ pkgs, fetchFromGitHub, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  version = "1.9.1-git-2015-05-13";
  name = "gmvault-${version}";

  src = fetchFromGitHub {
    owner = "gaubert";
    repo = "gmvault";
    rev = "ffc31893a687451df24f448624991ef60c42763e";
    sha256 = "0rs983gcxwx56j99z16ddm35hmi4nqkszav40wq58ybcryn3i7z8";
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
