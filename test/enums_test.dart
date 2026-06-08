import 'package:flutter_test/flutter_test.dart';
import 'package:aerial_views/aerial_views.dart';

void main() {
  group('TimeOfDay.fromString', () {
    test('parses day', () {
      expect(TimeOfDay.fromString('day'), TimeOfDay.day);
    });

    test('parses night', () {
      expect(TimeOfDay.fromString('night'), TimeOfDay.night);
    });

    test('parses sunset', () {
      expect(TimeOfDay.fromString('sunset'), TimeOfDay.sunset);
    });

    test('parses sunrise', () {
      expect(TimeOfDay.fromString('sunrise'), TimeOfDay.sunrise);
    });

    test('case insensitive', () {
      expect(TimeOfDay.fromString('DAY'), TimeOfDay.day);
      expect(TimeOfDay.fromString('Night'), TimeOfDay.night);
    });

    test('returns unknown for null', () {
      expect(TimeOfDay.fromString(null), TimeOfDay.unknown);
    });

    test('returns unknown for empty string', () {
      expect(TimeOfDay.fromString(''), TimeOfDay.unknown);
    });

    test('returns unknown for unrecognized value', () {
      expect(TimeOfDay.fromString('morning'), TimeOfDay.unknown);
    });
  });

  group('SceneType.fromString', () {
    test('parses nature', () {
      expect(SceneType.fromString('nature'), SceneType.nature);
    });

    test('parses countryside', () {
      expect(SceneType.fromString('countryside'), SceneType.countryside);
    });

    test('parses waterfall', () {
      expect(SceneType.fromString('waterfall'), SceneType.waterfall);
    });

    test('parses beach', () {
      expect(SceneType.fromString('beach'), SceneType.beach);
    });

    test('parses city', () {
      expect(SceneType.fromString('city'), SceneType.city);
    });

    test('parses sea', () {
      expect(SceneType.fromString('sea'), SceneType.sea);
    });

    test('parses space', () {
      expect(SceneType.fromString('space'), SceneType.space);
    });

    test('parses patterns', () {
      expect(SceneType.fromString('patterns'), SceneType.patterns);
    });

    test('parses fire', () {
      expect(SceneType.fromString('fire'), SceneType.fire);
    });

    test('case insensitive', () {
      expect(SceneType.fromString('NATURE'), SceneType.nature);
      expect(SceneType.fromString('Beach'), SceneType.beach);
    });

    test('returns unknown for null', () {
      expect(SceneType.fromString(null), SceneType.unknown);
    });

    test('returns unknown for empty string', () {
      expect(SceneType.fromString(''), SceneType.unknown);
    });

    test('returns unknown for unrecognized value', () {
      expect(SceneType.fromString('mountain'), SceneType.unknown);
    });
  });

  group('Enums values', () {
    test('AerialMediaSource has all values', () {
      expect(AerialMediaSource.values.length, 12);
    });

    test('AerialMediaType has all values', () {
      expect(AerialMediaType.values.length, 2);
    });

    test('VideoQuality has all values', () {
      expect(VideoQuality.values.length, 5);
    });

    test('TimeOfDay has all values', () {
      expect(TimeOfDay.values.length, 5);
    });

    test('SceneType has all values', () {
      expect(SceneType.values.length, 10);
    });

    test('ImmichAuthType has all values', () {
      expect(ImmichAuthType.values.length, 2);
    });

    test('ImmichVideoType has all values', () {
      expect(ImmichVideoType.values.length, 2);
    });

    test('ImmichImageType has all values', () {
      expect(ImmichImageType.values.length, 3);
    });

    test('ProviderMediaType has all values', () {
      expect(ProviderMediaType.values.length, 3);
    });

    test('ProviderSourceType has all values', () {
      expect(ProviderSourceType.values.length, 2);
    });
  });
}
