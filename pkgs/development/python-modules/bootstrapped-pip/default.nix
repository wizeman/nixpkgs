{ stdenv, python, fetchPypi, fetchFromGitHub, makeWrapper, unzip }:

let
  wheel_source = fetchPypi {
    pname = "wheel";
    version = "0.30.0";
    format = "wheel";
    sha256 = "e721e53864f084f956f40f96124a74da0631ac13fbbd1ba99e8e2b5e9cafdf64";
  };
  setuptools_source = fetchPypi {
    pname = "setuptools";
    version = "36.4.0";
    format = "wheel";
    sha256 = "4d54c0bfee283e78609169213f9c075827d5837086f58b588b417b093c23464b";
  };

in stdenv.mkDerivation rec {
  pname = "pip";
  version = "9.0.2.dev0";
  name = "${python.libPrefix}-bootstrapped-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "pip";
    rev = "1a872bc8e22ac8deb3514bae7bc9d857a646c260";
    sha256 = "0ap6al8j93gp62z80f0i900h4zvwimc0s5vgfdfr3scjalsii6in";
  };

  unpackPhase = ''
    mkdir -p $out/${python.sitePackages}
    rmdir $out/${python.sitePackages}
    cp -r $src $out/${python.sitePackages}
    find $out/${python.sitePackages} -type d -exec chmod 755 {} \;
    unzip -d $out/${python.sitePackages} ${setuptools_source}
    unzip -d $out/${python.sitePackages} ${wheel_source}
  '';

  patchPhase = ''
    mkdir -p $out/bin
  '';

  buildInputs = [ python makeWrapper unzip ];

  installPhase = ''

    # install pip binary
    echo '#!${python.interpreter}' > $out/bin/pip
    echo 'import sys;from pip import main' >> $out/bin/pip
    echo 'sys.exit(main())' >> $out/bin/pip
    chmod +x $out/bin/pip

    # wrap binaries with PYTHONPATH
    for f in $out/bin/*; do
      wrapProgram $f --prefix PYTHONPATH ":" $out/${python.sitePackages}/
    done
  '';
}
