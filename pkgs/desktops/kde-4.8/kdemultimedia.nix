{ kde, alsaLib, libvorbis, taglib, flac, cdparanoia, lame, kdelibs, ffmpeg_0_9,
  libmusicbrainz3, libtunepimp, pulseaudio }:

  # doesn't build with ffmpeg 0.11

kde {

  buildInputs =
    [ kdelibs cdparanoia taglib libvorbis libmusicbrainz3 libtunepimp ffmpeg_0_9
      flac lame pulseaudio
    ];

  meta = {
    description = "KDE multimedia programs such as a movie player and volume utility";
    license = "GPL";
  };
}
