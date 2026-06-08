import 'package:flutter_test/flutter_test.dart';
import 'package:aerial_views/aerial_views.dart';

void main() {
  group('FeedVideos', () {
    test('fromJson parses assets', () {
      final json = {
        'assets': [
          {
            'url-1080-H264': 'http://a.mp4',
            'accessibilityLabel': 'Video A',
          },
        ],
      };
      final feed = FeedVideos.fromJson(json);
      expect(feed.assets!.length, 1);
      expect(feed.assets![0].video1080h264, 'http://a.mp4');
    });

    test('fromJson handles null assets', () {
      final json = <String, dynamic>{};
      final feed = FeedVideos.fromJson(json);
      expect(feed.assets, isNull);
    });

    test('toJson serializes correctly', () {
      const feed = FeedVideos(assets: []);
      final json = feed.toJson();
      expect(json['assets'], isEmpty);
    });
  });

  group('FeedManifest', () {
    test('constructs with required fields', () {
      const manifest = FeedManifest(
        name: 'My Feed',
        manifestUrl: 'http://example.com/manifest.json',
      );
      expect(manifest.name, 'My Feed');
      expect(manifest.manifestUrl, 'http://example.com/manifest.json');
      expect(manifest.description, isNull);
    });

    test('fromJson parses correctly', () {
      final json = {
        'name': 'My Feed',
        'manifestUrl': 'http://example.com/manifest.json',
        'description': 'A test feed',
      };
      final manifest = FeedManifest.fromJson(json);
      expect(manifest.name, 'My Feed');
      expect(manifest.description, 'A test feed');
    });

    test('toJson serializes correctly', () {
      const manifest = FeedManifest(
        name: 'My Feed',
        manifestUrl: 'http://example.com/manifest.json',
      );
      final json = manifest.toJson();
      expect(json['name'], 'My Feed');
    });
  });

  group('FeedManifests', () {
    test('fromJson parses sources', () {
      final json = {
        'sources': [
          {
            'name': 'Feed 1',
            'manifestUrl': 'http://example.com/1.json',
          },
          {
            'name': 'Feed 2',
            'manifestUrl': 'http://example.com/2.json',
          },
        ],
      };
      final manifests = FeedManifests.fromJson(json);
      expect(manifests.sources.length, 2);
      expect(manifests.sources[0].name, 'Feed 1');
    });

    test('toJson serializes correctly', () {
      const manifests = FeedManifests(sources: []);
      final json = manifests.toJson();
      expect(json['sources'], isEmpty);
    });
  });
}
