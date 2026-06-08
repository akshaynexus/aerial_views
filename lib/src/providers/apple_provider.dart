import '../models/models.dart';
import 'bundled_video_provider.dart';

/// Provider that loads Apple aerial videos from bundled JSON assets.
///
/// Parses `tvos26.json` for video metadata and `tvos26_strings.json`
/// for localized description strings.
class AppleProvider extends BundledVideoProvider {
  AppleProvider({
    required super.quality,
    super.timeOfDayFilter,
    super.sceneFilter,
    super.enabled,
  });

  @override
  String get assetJsonPath => 'assets/tvos26.json';

  @override
  String get stringsJsonPath => 'assets/tvos26_strings.json';

  @override
  AerialMediaSource get mediaSource => AerialMediaSource.apple;

  /// Returns HTTPS URL (preferred). Certificate is valid as of 2026.
  @override
  String resolveUri(Map<String, dynamic> assetMap, VideoQuality q) {
    return super.resolveUri(assetMap, q);
  }

  /// Returns HTTP fallback URL for when HTTPS certificate validation fails.
  static String httpFallback(String httpsUrl) {
    return httpsUrl.replaceFirst('https://', 'http://');
  }
}