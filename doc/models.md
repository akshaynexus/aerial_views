# Models

## Core Types

### AerialMedia

The primary type returned by all providers.

```dart
class AerialMedia {
  final String url;
  final AerialMediaType type;      // video or image
  final AerialMediaSource source;  // which provider created it
  final AerialMediaMetadata metadata;
}
```

### AerialMediaMetadata

```dart
class AerialMediaMetadata {
  final String shortDescription;
  final Map<int, String> pointsOfInterest;  // seconds → description
  final TimeOfDay timeOfDay;
  final SceneType scene;
}
```

## Enums

### VideoQuality

| Value | JSON Key | Description |
|-------|----------|-------------|
| `video1080H264` | `url-1080-H264` | 1080p H.264 |
| `video1080Sdr` | `url-1080-SDR` | 1080p SDR |
| `video1080Hdr` | `url-1080-HDR` | 1080p HDR |
| `video4kSdr` | `url-4K-SDR` | 4K SDR |
| `video4kHdr` | `url-4K-HDR` | 4K HDR |

### AerialMediaSource

`unknown`, `apple`, `comm1`, `comm2`, `amazon`, `rtsp`, `hls`, `custom`, `local`, `samba`, `webdav`, `immich`

### TimeOfDay

`unknown`, `day`, `night`, `sunset`, `sunrise`

### SceneType

`unknown`, `nature`, `countryside`, `waterfall`, `beach`, `city`, `sea`, `space`, `patterns`, `fire`

## Bundled Video Models

All extend `AbstractVideo` which provides default `uriAtQuality()` and `allUrls()` implementations.

### AbstractVideo

```dart
abstract class AbstractVideo {
  final String? video1080sdr;
  final String? video4ksdr;
  // ... other quality fields

  String uriAtQuality(VideoQuality? quality);
  List<String> allUrls();
}
```

### AppleVideo / AmazonVideo / CommVideo

Subclasses add only `accessibilityLabel`, `pointsOfInterest`, and optional quality-specific fields (e.g., `video1080h264`).

## Immich Models

### ImmichMediaPrefs

Configuration for the Immich provider (see [Immich Integration](immich.md)).

### ImmichAsset

```dart
class ImmichAsset {
  final String id;
  final String type;           // 'VIDEO' or 'IMAGE'
  final String originalPath;
  final String? localDateTime;
  final String? description;
  final ExifInfo? exifInfo;
  final String? albumName;     // populated after processing
}
```

### ImmichAlbum

```dart
class ImmichAlbum {
  final String id;
  final String name;
  final String description;
  final String type;           // 'INDIVIDUAL', 'ALBUM', etc.
  final List<ImmichAsset> assets;
  final int assetCount;
}
```

### SharedLinkResponse

Returned by the shared links API. Contains album metadata, assets, and access controls.

### SearchMetadataRequest

```dart
const request = SearchMetadataRequest(
  isFavorite: true,
  rating: 5,
  size: 100,
  withExif: true,
  type: 'VIDEO',
);
```

## Custom Feed Models

### FeedManifest / FeedVideo

Used by `CustomFeedProvider` to parse `manifest.json` and `entries.json` formats.
