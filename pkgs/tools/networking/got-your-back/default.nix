{ pkgs, fetchFromGitHub, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  version = "2015-03-18";
  name = "got-your-back-${version}";

  src = fetchFromGitHub {
    owner = "jay0lee";
    repo = "got-your-back";
    rev = "3b087e78c330f43574ba388ffb03326280ac7d40";
    sha256 = "1m45g7q6dg9m99nx6fr520iyviliafwdjq6ckczry8l4wjx49wwv";
  };

  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [
    sqlite3
  ];

  patches = [ ./homedir.patch ];

  postPatch = ''
    rm setup.py setup-64.py

    substituteInPlace gyb.py \
        --replace "CLIENT_SECRETS = getProgPath()+" \
                  "CLIENT_SECRETS = \"$out/share/\"+" \
        --replace "ca_certs=getProgPath()+" \
                  "ca_certs=\"$out/share/\"+" \
        --replace "certFile = getProgPath()+" \
                  "certFile = \"$out/share/\"+"

    echo '#!/usr/bin/env python' > gyb
    tail -n +2 gyb.py >> gyb

    cat <<EOF > ./setup.py
    #!/usr/bin/env python

    from distutils.core import setup
    import glob

    setup(name='gyb',
          version='${version}',
          scripts=['gyb'],
          py_modules=[x[:-3] for x in glob.glob('*.py') if x != 'setup.py'],
          packages=['apiclient', 'httplib2', 'oauth2client', 'uritemplate'],
          data_files=[('share', ['client_secrets.json', 'cacert.pem'])]
          )
    EOF
  '';

  # `wrapPythonPrograms` inserts code before the module's docstring, which means
  # that python won't recognize it as a docstring anymore (i.e. `__doc__` will
  # be `None`). This breaks the `--help` command.
  #
  # Since the added code is not really needed, let's delete it.
  postPhases = [ "fixScript" ];
  fixScript = ''
    sed -i "$out/bin/.gyb-wrapped" -e '{
      /import sys; sys.argv/d
    }'
  '';

  meta = {
    description = "Command line tool for backing up your Gmail messages to your local computer";
    longDescription = ''
      Got Your Back (GYB) is a command line tool for backing up your Gmail
      messages to your local computer. It uses the standard IMAP protocol but
      also takes advantage of some custom Gmail IMAP extensions.
    '';
    homepage = https://github.com/jay0lee/got-your-back;
    license = pkgs.lib.licenses.asl20;
  };
}
