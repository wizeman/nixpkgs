{ stdenv, fetchurl, lib, pkgconfig, xorg, alsaLib, mesa, aalib
, libvorbis, libtheora, speex, zlib, libdvdcss, perl, ffmpeg
, flac, libcaca, pulseaudio, libmng, libcdio, libv4l, vcdimager
, libmpcdec, a52dec, faad2, libmad
, vdpauSupport ? false, libvdpau
}:
# TODO:
#   - missing libdts (using internal)
#   - missing mpeg encoder (fame or rte)

stdenv.mkDerivation rec {
  name = "xine-lib-1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "1mjk686h1qzqj51h4xs4xvagfgnnhm8czbzzjvr5w034pr8n8rg1";
  };

  patches = [ ./ffmpeg.patch ]; # from Gentoo, to build with ffmpeg-11

  buildNativeInputs = [ pkgconfig perl ];

  buildInputs = [
    xorg.libX11 xorg.libXv xorg.libXinerama xorg.libxcb xorg.libXext
    alsaLib mesa aalib libvorbis libtheora speex perl ffmpeg flac
    libcaca pulseaudio libmng libcdio libv4l vcdimager libmpcdec zlib
    a52dec faad2 libmad
  ] ++ lib.optional vdpauSupport libvdpau;

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xine-project.org/;
    description = "A high-performance, portable and reusable multimedia playback engine";
  };
}
