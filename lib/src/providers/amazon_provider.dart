import '../models/models.dart';
import 'bundled_video_provider.dart';

/// Provider that loads Amazon (Fire OS) aerial videos from bundled JSON assets.
///
/// Parses `fireos8.json` for video metadata and `fireos8_strings.json`
/// for localized description strings.
class AmazonProvider extends BundledVideoProvider {
  AmazonProvider({
    required super.quality,
    super.timeOfDayFilter,
    super.sceneFilter,
    super.enabled,
  });

  @override
  String get assetJsonPath => 'assets/fireos8.json';

  @override
  String get stringsJsonPath => 'assets/fireos8_strings.json';

  @override
  AerialMediaSource get mediaSource => AerialMediaSource.amazon;
}