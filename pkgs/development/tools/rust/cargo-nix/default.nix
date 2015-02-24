{ stdenv, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonPackage {
  name = "cargo-nix-git-2015-02-24";

  src = fetchFromGitHub {
    owner = "wizeman";
    repo = "cargo-nix";
    rev = "94284de419c99cf0d74ccd70cfdbb22f34326b10";
    sha256 = "05idydl84m460rqbdb6sjjb9cl50dzkkrsy30v6qwk08qaq8m0zc";
  };

  propagatedBuildInputs = with pythonPackages; [ toml ];

  meta = with stdenv.lib; {
    homepage = https://github.com/wizeman/cargo-nix;
    description = "Utilities for packaging Cargo programs with Nix";
    maintainers = with maintainers; [ wizeman ];
    platforms = platforms.all;
  };
}
