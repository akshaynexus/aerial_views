enum AerialMediaSource {
  unknown,
  apple,
  comm1,
  comm2,
  rtsp,
  amazon,
  custom,
  local,
  samba,
  webdav,
  immich,
  hls,
}

enum AerialMediaType { video, image }

enum VideoQuality { video1080H264, video1080Sdr, video1080Hdr, video4kSdr, video4kHdr }

enum TimeOfDay {
  unknown,
  day,
  night,
  sunset,
  sunrise;

  factory TimeOfDay.fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'day':
        return TimeOfDay.day;
      case 'night':
        return TimeOfDay.night;
      case 'sunset':
        return TimeOfDay.sunset;
      case 'sunrise':
        return TimeOfDay.sunrise;
      default:
        return TimeOfDay.unknown;
    }
  }
}

enum SceneType {
  unknown,
  nature,
  countryside,
  waterfall,
  beach,
  city,
  sea,
  space,
  patterns,
  fire;

  factory SceneType.fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'nature':
        return SceneType.nature;
      case 'countryside':
        return SceneType.countryside;
      case 'waterfall':
        return SceneType.waterfall;
      case 'beach':
        return SceneType.beach;
      case 'city':
        return SceneType.city;
      case 'sea':
        return SceneType.sea;
      case 'space':
        return SceneType.space;
      case 'patterns':
        return SceneType.patterns;
      case 'fire':
        return SceneType.fire;
      default:
        return SceneType.unknown;
    }
  }
}

enum ImmichAuthType { apiKey, sharedLink }

enum ImmichVideoType { transcoded, original }

enum ImmichImageType { original, fullsize, preview }

enum ProviderSourceType { remote, local }
