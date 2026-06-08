# aerial_views

Flutter library for discovering and streaming aerial videos from Apple, Community, Amazon, Immich, and custom feeds.

Ported from the [AerialViews Android TV](https://github.com/user/AerialViews) app.

## Features

- **Apple Aerial Videos** - macOS/iOS screensaver videos with 4K HDR support
- **Community Videos** - Community-contributed aerial footage
- **Amazon/Fire TV Videos** - Fire TV aerial screensaver content
- **Immich Integration** - Self-hosted photo server video streaming
- **Custom Feeds** - RTSP, HLS, CSV, and JSON manifest support
- **Quality Selection** - 1080p H.264, 1080p SDR/HDR, 4K SDR/HDR
- **Metadata** - Description, points of interest, time of day, scene type

## Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  aerial_views:
    path: ../aerial_views  # or from pub.dev
```

## Usage

### Apple Videos

```dart
import 'package:aerial_views/aerial_views.dart';

final provider = AppleProvider(
  quality: VideoQuality.video4kSdr,
  timeOfDayFilter: {TimeOfDay.day, TimeOfDay.sunset},
  sceneFilter: {SceneType.beach, SceneType.city},
);

final videos = await provider.fetch();
```

### Community Videos

```dart
final provider = Comm1Provider(quality: VideoQuality.video1080H264);
final videos = await provider.fetch();
```

### Amazon/Fire TV Videos

```dart
final provider = AmazonProvider(quality: VideoQuality.video1080Sdr);
final videos = await provider.fetch();
```

### Custom Feeds (RTSP, HLS, CSV, JSON)

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

### Immich (Self-Hosted)

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
  ),
);
final videos = await provider.fetch();
```

## Enriching Metadata

All providers return basic metadata from `fetch()`. To enrich with descriptions and points of interest:

```dart
final provider = AppleProvider(quality: VideoQuality.video4kSdr);
final basicVideos = await provider.fetch();
final enrichedVideos = provider.fetchMetadata(basicVideos);
```

## API Reference

See the [docs/](docs/) folder for detailed documentation:

- [Architecture](docs/architecture.md) - Project structure and data flow
- [Providers](docs/providers.md) - Provider usage and configuration
- [Models](docs/models.md) - Data types and enums
- [Immich Integration](docs/immich.md) - Immich setup and configuration

### Quick Reference

| Provider | Source | Description |
|----------|--------|-------------|
| `AppleProvider` | Bundled JSON | Apple aerial videos |
| `Comm1Provider` | Bundled JSON | Community 1 videos |
| `Comm2Provider` | Bundled JSON | Community 2 videos |
| `AmazonProvider` | Bundled JSON | Amazon/Fire TV videos |
| `CustomFeedProvider` | Network URLs | RTSP, HLS, CSV, JSON feeds |
| `ImmichProvider` | Immich API | Self-hosted photo server |

## License

MIT
