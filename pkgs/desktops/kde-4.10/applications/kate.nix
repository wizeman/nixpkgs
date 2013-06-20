{ kde, kdelibs, kactivities, qjson, pyqt4, sip, python, pykde4 }:

kde {
  dontStrip = true;
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=debugfull" ];

  buildInputs = [ kdelibs kactivities qjson pyqt4 sip python pykde4];

  meta = {
    description = "Kate, the KDE Advanced Text Editor, as well as KWrite";
    license = "GPLv2";
  };
}
