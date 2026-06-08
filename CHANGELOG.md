## 0.1.0

- Refactored Immich integration: merged `ImmichUrlBuilder` into `ImmichApi`, merged `ImmichAssetMapper` into `ImmichRepository`
- Removed intermediate types (`ImmichMediaItem`, `ImmichMediaMetadata`, `ImmichExifMetadata`) — providers now map directly to `AerialMedia`
- Consolidated `ImmichAssetPrefs`/`ImmichUrlPrefs` into `ImmichMediaPrefs`
- Extracted shared utilities (`qualityUrlKeys`, `detectMediaType`, `enrichMetadata`) to `utils.dart`
- Created `BundledVideoProvider` base class, reducing provider boilerplate from ~180 lines to ~25 lines each
- Reduced codebase from 2,500+ to ~2,200 lines
- Added documentation (architecture, providers, models, Immich integration)

## 0.0.1

- Initial release
