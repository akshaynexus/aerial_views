# Providers

All providers implement the same interface: `fetch()` returns `List<AerialMedia>`, and `fetchMetadata(media)` enriches items with descriptions and points of interest.

## BundledVideoProvider (Abstract Base)

Base class for providers that load from bundled JSON assets.

```dart
abstract class BundledVideoProvider {
  final VideoQuality quality;
  final Set<TimeOfDay> timeOfDayFilter;
  final Set<SceneType> sceneFilter;
  final bool enabled;

  String get assetJsonPath;
  String get stringsJsonPath;
  AerialMediaSource get mediaSource;

  Future<List<AerialMedia>> fetch();
  List<AerialMedia> fetchMetadata(List<AerialMedia> media);
}
```

Subclasses override three getters and optionally `resolveUri()` for custom URL handling.

## AppleProvider

Loads Apple aerial videos from `assets/tvos26.json` and `assets/tvos26_strings.json`.

```dart
final provider = AppleProvider(
  quality: VideoQuality.video4kSdr,
  timeOfDayFilter: {TimeOfDay.day, TimeOfDay.sunset},
  sceneFilter: {SceneType.beach, SceneType.city},
);
final videos = await provider.fetch();
```

**Special behavior:** Rewrites `https://` URLs to `http://` (Apple uses invalid certificates).

## AmazonProvider

Loads Amazon/Fire TV videos from `assets/fireos8.json` and `assets/fireos8_strings.json`.

```dart
final provider = AmazonProvider(quality: VideoQuality.video1080Sdr);
final videos = await provider.fetch();
```

## Comm1Provider / Comm2Provider

Load community-contributed videos from `assets/comm1.json` and `assets/comm2.json` respectively.

```dart
final provider = Comm1Provider(quality: VideoQuality.video1080H264);
final videos = await provider.fetch();
```

## CustomFeedProvider

Fetches media from user-provided URLs. Supports multiple feed formats:

| URL Pattern | Handler |
|-------------|---------|
| `rtsp://...` | Added as RTSP stream |
| `*.m3u8` | Added as HLS stream |
| `*.csv` | Parsed for video/image URLs |
| `entries.json` | Parsed as video feed entries |
| `manifest.json` | Parsed for nested entry URLs |

```dart
final provider = CustomFeedProvider(
  quality: VideoQuality.video1080Sdr,
  urls: {
    'https://example.com/manifest.json',
    'rtsp://camera.local/stream',
    'https://example.com/videos.csv',
  },
);
final videos = await provider.fetch();
```

## ImmichProvider

Orchestrates fetching from a self-hosted Immich photo server.

```dart
final provider = ImmichProvider(
  prefs: ImmichMediaPrefs(
    url: 'http://192.168.1.100:2283',
    apiKey: 'your-api-key',
    authType: ImmichAuthType.apiKey,
    mediaType: ProviderMediaType.videos,
    selectedAlbumIds: {'album-id-1'},
    includeFavorites: '10',
    includeRandom: '20',
    includeRecent: '10',
  ),
);
final videos = await provider.fetch();
final albums = await provider.fetchAlbums();
```

### Auth Modes

| Mode | Field | Description |
|------|-------|-------------|
| `ImmichAuthType.apiKey` | `apiKey` | Direct API key authentication |
| `ImmichAuthType.sharedLink` | `pathName`, `password` | Shared link with optional password |

### Media Filtering

`ImmichMediaPrefs.mediaType` controls which media types are fetched:
- `ProviderMediaType.videos` - Only videos
- `ProviderMediaType.photos` - Only images
- `ProviderMediaType.videosPhotos` - Both (default)

### Optional Asset Sources

These only work with `ImmichAuthType.apiKey`:
- `includeFavorites` - Number of favorite assets (or `'DISABLED'`)
- `includeRatings` - Set of rating thresholds
- `includeRandom` - Number of random assets
- `includeRecent` - Number of recent assets
