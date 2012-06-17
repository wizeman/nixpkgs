{ kde, alsaLib, libvorbis, taglib, flac, cdparanoia, lame, kdelibs, ffmpeg_0_9,
  libmusicbrainz3, libtunepimp, pulseaudio }:

  # doesn't build with ffmpeg 0.11

kde {

  buildInputs =
    # Note: kdemultimedia can use xine-lib, but it doesn't seem useful
    # without the Phonon Xine backend.
    [ kdelibs cdparanoia taglib libvorbis libmusicbrainz3 libtunepimp ffmpeg_0_9
      flac lame pulseaudio
    ];

  meta = {
    description = "KDE multimedia programs such as a movie player and volume utility";
    license = "GPL";
  };
}
