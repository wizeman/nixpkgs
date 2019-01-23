{ buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  # also bump cryptography
  pname = "cryptography_vectors";
  version = "2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "333649b96300ddf2edaddda1adb407665de34ca11c7ef0410ec1096eefa00e97";
  };

  # No tests included
  doCheck = false;
}
