{ stdenv, fetchurl, kernel ? null, xlibs, zlib, perl
, gtk, atk, pango, glib, gdk_pixbuf
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

with stdenv.lib;

let versionNumber = "313.18"; in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}${optionalString (!libsOnly) "-${kernel.version}"}";

  builder = ./builder.sh;

  patches = [ ./version-test.patch ];

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}.run";
        sha256 = "13s8yi7paa51h5fq55yd0bz1v4n2whnmsks4954fkb4h30cy5raq";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-no-compat32.run";
        sha256 = "12s0mz4f9cgqnn5gz488hhrvamlvhf3q76jxra3dy7405rwi25jy";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  inherit versionNumber libsOnly;

  kernel = if libsOnly then null else kernel;

  dontStrip = true;

  glPath = stdenv.lib.makeLibraryPath [xlibs.libXext xlibs.libX11 xlibs.libXrandr];

  cudaPath = stdenv.lib.makeLibraryPath [zlib stdenv.gcc.gcc];

  openclPath = stdenv.lib.makeLibraryPath [zlib];

  programPath = optionalString (!libsOnly) (stdenv.lib.makeLibraryPath
    [ gtk atk pango glib gdk_pixbuf xlibs.libXv ] );

  buildInputs = [ perl ];

  meta = {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for NVIDIA graphics cards";
    license = "unfree";
  };
}
