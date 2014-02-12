{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  patches = [ ./knetwalk-clearlocks.patch ./knetwalk-keyboard.patch ];
  meta = {
    description = "a small game where you have to build up a computer network by rotating the wires to connect the terminals to the server";
  };
}
