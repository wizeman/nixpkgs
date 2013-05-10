{ kde, kdelibs, kactivities, qjson, pyqt4, sip }:

kde {
  dontStrip = true;
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=debugfull" ];
#todo: PythonLibrary, SIP, PyQt4, PyKDE4
  buildInputs = [ kdelibs kactivities qjson pyqt4 sip ];

  meta = {
    description = "Kate, the KDE Advanced Text Editor, as well as KWrite";
    license = "GPLv2";
  };
}
