import 'package:flutter_test/flutter_test.dart';
import 'package:aerial_views/aerial_views.dart';

void main() {
  group('AerialMedia', () {
    test('constructs with required fields', () {
      final media = AerialMedia(
        url: 'https://example.com/video.mp4',
        type: AerialMediaType.video,
        source: AerialMediaSource.apple,
      );
      expect(media.url, 'https://example.com/video.mp4');
      expect(media.type, AerialMediaType.video);
      expect(media.source, AerialMediaSource.apple);
    });

    test('has default metadata', () {
      final media = AerialMedia(
        url: 'https://example.com/video.mp4',
      );
      expect(media.metadata.shortDescription, '');
      expect(media.metadata.pointsOfInterest, isEmpty);
      expect(media.metadata.timeOfDay, TimeOfDay.unknown);
      expect(media.metadata.scene, SceneType.unknown);
    });

    test('has default type', () {
      final media = AerialMedia(url: 'https://example.com/video.mp4');
      expect(media.type, AerialMediaType.video);
    });

    test('has default source', () {
      final media = AerialMedia(url: 'https://example.com/video.mp4');
      expect(media.source, AerialMediaSource.unknown);
    });
  });

  group('AerialMediaMetadata', () {
    test('constructs with default values', () {
      const metadata = AerialMediaMetadata();
      expect(metadata.shortDescription, '');
      expect(metadata.pointsOfInterest, isEmpty);
      expect(metadata.timeOfDay, TimeOfDay.unknown);
      expect(metadata.scene, SceneType.unknown);
    });

    test('constructs with values', () {
      const metadata = AerialMediaMetadata(
        shortDescription: 'Beach sunset',
        pointsOfInterest: {0: 'Waves', 10: 'Sunset'},
        timeOfDay: TimeOfDay.sunset,
        scene: SceneType.beach,
      );
      expect(metadata.shortDescription, 'Beach sunset');
      expect(metadata.pointsOfInterest, {0: 'Waves', 10: 'Sunset'});
      expect(metadata.timeOfDay, TimeOfDay.sunset);
      expect(metadata.scene, SceneType.beach);
    });

    test('copyWith creates new instance', () {
      const original = AerialMediaMetadata(
        shortDescription: 'Original',
        timeOfDay: TimeOfDay.day,
      );
      final copied = original.copyWith(shortDescription: 'Updated');
      expect(copied.shortDescription, 'Updated');
      expect(copied.timeOfDay, TimeOfDay.day);
    });

    test('copyWith preserves unmodified fields', () {
      const original = AerialMediaMetadata(
        shortDescription: 'Original',
        pointsOfInterest: {0: 'Scene'},
        timeOfDay: TimeOfDay.night,
        scene: SceneType.city,
      );
      final copied = original.copyWith(scene: SceneType.space);
      expect(copied.shortDescription, 'Original');
      expect(copied.pointsOfInterest, {0: 'Scene'});
      expect(copied.timeOfDay, TimeOfDay.night);
      expect(copied.scene, SceneType.space);
    });

    test('copyWith null keeps original', () {
      const original = AerialMediaMetadata(
        shortDescription: 'Original',
        timeOfDay: TimeOfDay.day,
      );
      final copied = original.copyWith();
      expect(copied.shortDescription, 'Original');
      expect(copied.timeOfDay, TimeOfDay.day);
    });
  });
}
