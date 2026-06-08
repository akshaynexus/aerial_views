import 'enums.dart';

class AerialMedia {
  final String url;
  final AerialMediaType type;
  final AerialMediaSource source;
  final AerialMediaMetadata metadata;

  AerialMedia({
    required this.url,
    this.type = AerialMediaType.video,
    this.source = AerialMediaSource.unknown,
    this.metadata = const AerialMediaMetadata(),
  });
}

class AerialMediaMetadata {
  final String shortDescription;
  final Map<int, String> pointsOfInterest;
  final TimeOfDay timeOfDay;
  final SceneType scene;

  const AerialMediaMetadata({
    this.shortDescription = '',
    this.pointsOfInterest = const {},
    this.timeOfDay = TimeOfDay.unknown,
    this.scene = SceneType.unknown,
  });

  AerialMediaMetadata copyWith({
    String? shortDescription,
    Map<int, String>? pointsOfInterest,
    TimeOfDay? timeOfDay,
    SceneType? scene,
  }) {
    return AerialMediaMetadata(
      shortDescription: shortDescription ?? this.shortDescription,
      pointsOfInterest: pointsOfInterest ?? this.pointsOfInterest,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      scene: scene ?? this.scene,
    );
  }
}
