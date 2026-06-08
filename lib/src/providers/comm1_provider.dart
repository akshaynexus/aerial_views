import '../models/models.dart';
import 'bundled_video_provider.dart';

/// Provider that loads Community 1 aerial videos from bundled JSON assets.
///
/// Parses `comm1.json` for video metadata and `comm1_strings.json`
/// for localized description strings.
class Comm1Provider extends BundledVideoProvider {
  Comm1Provider({
    required super.quality,
    super.timeOfDayFilter,
    super.sceneFilter,
    super.enabled,
  });

  @override
  String get assetJsonPath => 'assets/comm1.json';

  @override
  String get stringsJsonPath => 'assets/comm1_strings.json';

  @override
  AerialMediaSource get mediaSource => AerialMediaSource.comm1;
}