# Architecture

## Overview

`aerial_views` is a Flutter library structured around three layers: **Models**, **Providers**, and **Utilities**.

```
lib/
├── aerial_views.dart              # Public API barrel export
└── src/
    ├── models/                    # Data classes and enums
    │   ├── models.dart            # Barrel export
    │   ├── aerial_media.dart      # Core AerialMedia + AerialMediaMetadata
    │   ├── abstract_video.dart    # Base for bundled video models
    │   ├── apple_video.dart       # Apple-specific video model
    │   ├── amazon_video.dart      # Amazon-specific video model
    │   ├── comm_video.dart        # Community 1 & 2 video models
    │   ├── custom_feed.dart       # Feed manifest models
    │   ├── immich_models.dart     # Immich API domain models
    │   └── enums.dart             # All enums
    └── providers/                 # Data fetching and processing
        ├── providers.dart         # Barrel export
        ├── utils.dart             # Shared utilities
        ├── pair.dart              # Generic Pair<A,B>
        ├── bundled_video_provider.dart  # Base for bundled JSON providers
        ├── apple_provider.dart    # Apple aerial videos
        ├── amazon_provider.dart   # Amazon/Fire TV videos
        ├── comm1_provider.dart    # Community 1 videos
        ├── comm2_provider.dart    # Community 2 videos
        ├── custom_feed_provider.dart    # RTSP, HLS, CSV, JSON feeds
        ├── csv_parser.dart        # CSV media list parser
        ├── url_validator.dart     # URL validation utilities
        ├── immich.dart            # Immich barrel export
        ├── immich_api.dart        # Immich HTTP API client
        ├── immich_repository.dart # Immich data access + asset processing
        └── immich_provider.dart   # High-level Immich orchestrator
```

## Data Flow

All providers follow the same pattern:

```
Provider.fetch() → List<AerialMedia>
                     ↓
Provider.fetchMetadata(media) → List<AerialMedia> (with descriptions/POI enriched)
```

1. **`fetch()`** - Loads raw media items (from bundled JSON or network)
2. **`fetchMetadata()`** - Enriches items with descriptions and points of interest

## Class Hierarchy

### Bundled Video Providers

```
BundledVideoProvider (abstract)
├── AppleProvider    (assets/tvos26.json)
├── AmazonProvider   (assets/fireos8.json)
├── Comm1Provider    (assets/comm1.json)
└── Comm2Provider    (assets/comm2.json)
```

`BundledVideoProvider` handles:
- Loading JSON assets via `rootBundle`
- Filtering by time of day and scene type
- Quality-based URL resolution (delegated to `qualityUrlKeys`)
- Metadata enrichment via `enrichMetadata()`

Subclasses only specify:
- `assetJsonPath` / `stringsJsonPath` - bundle paths
- `mediaSource` - enum identifier
- `resolveUri()` - optional override for special URL handling

### Immich Stack

```
ImmichProvider (orchestrator)
├── ImmichApi        (HTTP client + URL building)
└── ImmichRepository (asset fetching, filtering, processing)
```

## Key Types

### AerialMedia

The core type returned by all providers:

```dart
class AerialMedia {
  final String url;
  final AerialMediaType type;      // video or image
  final AerialMediaSource source;  // apple, immich, custom, etc.
  final AerialMediaMetadata metadata;
}
```

### AerialMediaMetadata

```dart
class AerialMediaMetadata {
  final String shortDescription;
  final Map<int, String> pointsOfInterest;  // timestamp → description
  final TimeOfDay timeOfDay;
  final SceneType scene;
}
```

## Shared Utilities (`utils.dart`)

| Function | Purpose |
|----------|---------|
| `filenameWithoutExtension(url)` | Extract filename stem for metadata lookup |
| `isSupportedVideoType(filename)` | Check `.mov`, `.mp4`, etc. |
| `isSupportedImageType(filename)` | Check `.jpg`, `.png`, etc. |
| `detectMediaType(filename)` | Returns `AerialMediaType?` |
| `cleanSharedLinkKey(input)` | Normalize Immich shared link paths |
| `qualityUrlKeys` | Maps `VideoQuality` → JSON key |
| `enrichMetadata(media, metadata)` | Attach descriptions/POI to media items |
