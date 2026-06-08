import '../models/models.dart';
import 'bundled_video_provider.dart';

/// Provider that loads Community 2 aerial videos from bundled JSON assets.
///
/// Parses `comm2.json` for video metadata and `comm2_strings.json`
/// for localized description strings.
class Comm2Provider extends BundledVideoProvider {
  Comm2Provider({
    required super.quality,
    super.timeOfDayFilter,
    super.sceneFilter,
    super.enabled,
  });

  @override
  String get assetJsonPath => 'assets/comm2.json';

  @override
  String get stringsJsonPath => 'assets/comm2_strings.json';

  @override
  AerialMediaSource get mediaSource => AerialMediaSource.comm2;

  /// Comm2 maps 1080-HDR to 1080-SDR (10bit colour space alone is not HDR).
  @override
  String resolveUri(Map<String, dynamic> assetMap, VideoQuality q) {
    if (q == VideoQuality.video1080Sdr) {
      return (assetMap['url-1080-HDR'] as String?) ?? '';
    }
    return super.resolveUri(assetMap, q);
  }
}