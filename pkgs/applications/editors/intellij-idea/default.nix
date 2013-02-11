{ stdenv, fetchurl, patchelf, makeDesktopItem, ant, jdk } :

stdenv.mkDerivation rec {
  version = "12.0";
  ver_minor = "3";
  name = "intellij-idea-ce-${version}.${ver_minor}";

  src = fetchurl {
    url = "http://download.jetbrains.com/idea/ideaIC-${version}-src.tar.bz2";
    sha256 = "1hnw993vr05mv29nigqaxrnbnhhfiv8bhfylnz0rx0hz7xh0l4mm";
  };

  builder = ./builder.sh;

  desktopItem = makeDesktopItem {
    name = "IntelliJ-IDEA-CE";
    exec = "idea.sh";
    icon = "idea_CE128.png";
    comment = "IntelliJ IDEA Community Edition";
    desktopName = "IntelliJ IDEA CE";
    genericName = "IntelliJ IDEA Community Edition";
    categories = "Application;Development;";
  };

  # TODO(corey): I'm confused on how to provide both the architecture's dynamic linker path.
  notifierToPatch = if stdenv.system == "x86_64-linux"
    then "fsnotifier64"
    else "fsnotifier";

  inherit ant jdk;

  meta = {
    description = "A lightweight IDE for Java SE, Groovy & Scala; community edition";
    homepage = http://jetbrains.org/idea;
    license = "Apache-2";
    platforms = stdenv.lib.platforms.linux; # ToDo: more?
  };
}

