# Immich Integration

## Overview

The Immich integration fetches photos and videos from a self-hosted [Immich](https://immich.app/) server. It supports two authentication modes and can combine assets from multiple sources.

## Architecture

```
ImmichProvider
├── ImmichApi         (HTTP client + URL building)
└── ImmichRepository  (asset fetching, filtering, processing)
```

### ImmichApi

Handles all HTTP communication with the Immich server:
- Album fetching (regular, shared, by ID)
- Asset searching (favorites, recent, random, by rating)
- Asset URL construction with proper auth tokens
- Shared link key resolution

### ImmichRepository

Orchestrates data access:
- Fetches and filters assets by media type
- Deduplicates assets across albums
- Maps `ImmichAsset` → `AerialMedia`
- Enriches assets with album names and EXIF descriptions

## Authentication

### API Key

```dart
ImmichMediaPrefs(
  url: 'http://192.168.1.100:2283',
  apiKey: 'your-api-key',
  authType: ImmichAuthType.apiKey,
)
```

Required for: favorites, ratings, random, recent, album selection.

### Shared Link

```dart
ImmichMediaPrefs(
  url: 'http://192.168.1.100:2283',
  pathName: 'share/abc123',
  password: 'optional-password',
  authType: ImmichAuthType.sharedLink,
)
```

The `pathName` is cleaned automatically (strips leading `/`, `share/`, `s/` prefixes).

## Asset Sources

### Primary Source

- **Shared Link mode:** Fetches the shared link, then loads its album (or inline assets for `INDIVIDUAL` type)
- **API Key mode:** Fetches all selected album IDs from `selectedAlbumIds`

### Optional Sources (API Key only)

| Source | Pref | Description |
|--------|------|-------------|
| Favorites | `includeFavorites` | Number of favorite assets to fetch |
| Ratings | `includeRatings` | Set of rating thresholds (e.g., `{'5', '4'}`) |
| Random | `includeRandom` | Number of random assets |
| Recent | `includeRecent` | Number of most recent assets |

## Asset Processing

1. **Filter** - Remove assets not matching `mediaType` (video/photo/both)
2. **URL Build** - Construct proper playback/thumbnail URL with auth
3. **Deduplicate** - Remove duplicate assets across all sources
4. **Enrich** - Add album name and EXIF description metadata

### Video URL Patterns

| Video Type | URL Pattern |
|------------|-------------|
| Transcoded | `/api/assets/{id}/video/playback` |
| Original | `/api/assets/{id}/original` |

### Image URL Patterns

| Image Type | URL Pattern |
|------------|-------------|
| Original | `/api/assets/{id}/original` |
| Fullsize | `/api/assets/{id}/thumbnail?size=fullsize` |
| Preview | `/api/assets/{id}/thumbnail?size=preview` |

## Error Handling

- Fetching individual asset sources (favorites, random, etc.) fails silently and returns empty
- Album fetch failures in multi-album mode are skipped
- Shared link failures fall back to inline assets when available
