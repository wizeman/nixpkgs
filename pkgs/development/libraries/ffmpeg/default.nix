{ stdenv, fetchurl, pkgconfig, yasm, zlib, bzip2
, branch ? "0.11"
, mp3Support ? true, lame ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, vorbisSupport ? true, libvorbis ? null
, vpxSupport ? false, libvpx ? null
, x264Support ? true, x264 ? null
, xvidSupport ? true, xvidcore ? null
, vdpauSupport ? true, libvdpau ? null # not detected anyway, don't know why
, faacSupport ? false, faac ? null
, dc1394Support ? false, libdc1394 ? null
}:

assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert vorbisSupport -> libvorbis != null;
assert vpxSupport -> libvpx != null && builtins.compareVersions branch "0.5" == 1;
assert x264Support -> x264 != null;
assert xvidSupport -> xvidcore != null;
assert vdpauSupport -> libvdpau != null;
assert faacSupport -> faac != null;
assert vdpauSupport -> libvdpau != null;

stdenv.mkDerivation rec {
  name = "ffmpeg-${version}";
  version = if branch == "0.5" then "0.5.9"
    else    if branch == "0.7" then "0.7.12"
    else    if branch == "0.9" then "0.9.2"
    else    branch;

  src = fetchurl {
    url = "http://www.ffmpeg.org/releases/${name}.tar.bz2";
    sha256 =
      if branch == "0.5"  then "05avwmfxhqy32zip1rgdcdn74538a7xgs70f7jykg1qb52hvnsj5" else
      if branch == "0.7"  then "0030ydgx7lpcm7gwrwmq6khlbwa97x50p7zd2vn9a7ssbvbi2rbq" else
      if branch == "0.9"  then "0jcywsgl2vwfff0xqwyz8zw2sarxm3kd6hhjpa175ajhv2gql4gr" else
      if branch == "0.11" then "0bq4198d969b063p3sjb1mw4ywifj4y4r434ih6hghv11mpjyrmi" else
      throw "unsupported ffmpeg branch `${branch}'";
  };

  # `--enable-gpl' (as well as the `postproc' and `swscale') mean that
  # the resulting library is GPL'ed, so it can only be used in GPL'ed
  # applications.
  configureFlags = [
    "--enable-gpl"
    "--enable-postproc"
    "--enable-swscale"
    "--disable-ffplay"
    "--enable-shared"
    "--enable-runtime-cpudetect"
  ]
    ++ stdenv.lib.optional mp3Support "--enable-libmp3lame"
    ++ stdenv.lib.optional speexSupport "--enable-libspeex"
    ++ stdenv.lib.optional theoraSupport "--enable-libtheora"
    ++ stdenv.lib.optional vorbisSupport "--enable-libvorbis"
    ++ stdenv.lib.optional vpxSupport "--enable-libvpx"
    ++ stdenv.lib.optional x264Support "--enable-libx264"
    ++ stdenv.lib.optional xvidSupport "--enable-libxvid"
    ++ stdenv.lib.optional vdpauSupport "--enable-vdpau"
    ++ stdenv.lib.optional faacSupport "--enable-libfaac --enable-nonfree"
    ++ stdenv.lib.optional dc1394Support "--enable-libdc1394";

  buildInputs = [ pkgconfig lame yasm zlib bzip2 ]
    ++ stdenv.lib.optional mp3Support lame
    ++ stdenv.lib.optional speexSupport speex
    ++ stdenv.lib.optional theoraSupport libtheora
    ++ stdenv.lib.optional vorbisSupport libvorbis
    ++ stdenv.lib.optional vpxSupport libvpx
    ++ stdenv.lib.optional x264Support x264
    ++ stdenv.lib.optional xvidSupport xvidcore
    ++ stdenv.lib.optional vdpauSupport libvdpau
    ++ stdenv.lib.optional faacSupport faac
    ++ stdenv.lib.optional dc1394Support libdc1394;

  enableParallelBuilding = true;

  crossAttrs = {
    dontSetConfigureCross = true;
    configureFlags = configureFlags ++ [
      "--cross-prefix=${stdenv.cross.config}"
      "--enable-cross-compile"
      "--target_os=linux"
      "--arch=${stdenv.cross.arch}"
      ];
  };

  meta = {
    homepage = http://www.ffmpeg.org/;
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
  };
}
