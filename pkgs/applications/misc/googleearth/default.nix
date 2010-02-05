{ stdenv, fetchurl, glibc, mesa, freetype, glib, libSM, libICE, libXi, libXv,
libXrender, libXrandr, libXfixes, libXcursor, libXinerama, libXext, libX11,
zlib, patchelf05 }:

/* I haven't found any x86_64 package from them */
assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "googleearth-5.1.3533.1731";

  src = fetchurl {
    url = http://dl.google.com/earth/client/current/GoogleEarthLinux.bin;
    sha256 = "1sxs1nwb2zh2j8dbwm65r04byn66yn79kpzhilhswly6r8d7yivg";
  };

  buildInputs = [
    glibc
    glib
    stdenv.gcc.gcc
    libSM 
    libICE 
    libXi 
    libXv
    mesa
    libXrender 
    libXrandr 
    libXfixes 
    libXcursor 
    libXinerama 
    freetype 
    libXext 
    libX11 
    zlib
  ];

  phases = "unpackPhase installPhase";
  unpackPhase = ''
    bash $src --noexec --target unpacked
    cd unpacked
  '';
  installPhase =''
    ensureDir $out/{opt/googleearth/,bin};
    tar xf googleearth-data.tar -C $out/opt/googleearth
    tar xf googleearth-linux-x86.tar -C $out/opt/googleearth
    cp bin/googleearth $out/opt/googleearth
    cat > $out/bin/googleearth << EOF
    #!/bin/sh
    export GOOGLEEARTH_DATA_PATH=$out/opt/googleearth
    exec $out/opt/googleearth/googleearth
    EOF
    chmod +x $out/bin/googleearth

    fullPath=
    for i in $buildInputs; do
      fullPath=$fullPath:$i/lib
    done
          
    ${patchelf05}/bin/patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath $fullPath \
      $out/opt/googleearth/googleearth-bin

    for a in $out/opt/googleearth/*.so* ; do
      ${patchelf05}/bin/patchelf --set-rpath $fullPath $a
    done
  '';

  meta = {
    description = "A world sphere viewer";
    homepage = http://earth.google.com;
    license = "unfree";
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
