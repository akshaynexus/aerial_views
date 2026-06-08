import 'package:flutter_test/flutter_test.dart';
import 'package:aerial_views/aerial_views.dart';

void main() {
  group('AbstractVideo', () {
    test('constructs with all fields', () {
      const video = AbstractVideo(
        video1080h264: 'http://example.com/1080h264.mp4',
        video1080sdr: 'http://example.com/1080sdr.mp4',
        video1080hdr: 'http://example.com/1080hdr.mp4',
        video4ksdr: 'http://example.com/4ksdr.mp4',
        video4khdr: 'http://example.com/4khdr.mp4',
        description: 'Test video',
        pointsOfInterest: {'0': 'Scene 1'},
        timeOfDay: 'day',
        scene: 'beach',
      );
      expect(video.video1080h264, 'http://example.com/1080h264.mp4');
      expect(video.video1080sdr, 'http://example.com/1080sdr.mp4');
      expect(video.description, 'Test video');
    });

    test('constructs with defaults', () {
      const video = AbstractVideo();
      expect(video.video1080h264, isNull);
      expect(video.description, '');
      expect(video.pointsOfInterest, isEmpty);
    });

    group('uriAtQuality', () {
      const video = AbstractVideo(
        video1080h264: 'http://h264.mp4',
        video1080sdr: 'http://sdr.mp4',
        video1080hdr: 'http://hdr.mp4',
        video4ksdr: 'http://4ksdr.mp4',
        video4khdr: 'http://4khdr.mp4',
      );

      test('returns 1080H264 for null quality', () {
        expect(video.uriAtQuality(null), 'http://h264.mp4');
      });

      test('returns 1080H264 for video1080H264', () {
        expect(video.uriAtQuality(VideoQuality.video1080H264), 'http://h264.mp4');
      });

      test('returns 1080SDR', () {
        expect(video.uriAtQuality(VideoQuality.video1080Sdr), 'http://sdr.mp4');
      });

      test('returns 1080HDR', () {
        expect(video.uriAtQuality(VideoQuality.video1080Hdr), 'http://hdr.mp4');
      });

      test('returns 4KSDR', () {
        expect(video.uriAtQuality(VideoQuality.video4kSdr), 'http://4ksdr.mp4');
      });

      test('returns 4KHDR', () {
        expect(video.uriAtQuality(VideoQuality.video4kHdr), 'http://4khdr.mp4');
      });
    });

    group('uriAtQuality with missing values', () {
      test('returns empty string when quality not available', () {
        const video = AbstractVideo();
        expect(video.uriAtQuality(VideoQuality.video1080Sdr), '');
      });

      test('falls back to 1080H264 for null quality', () {
        const video = AbstractVideo(video1080sdr: 'http://sdr.mp4');
        expect(video.uriAtQuality(null), '');
      });
    });

    group('allUrls', () {
      test('returns all non-null URLs', () {
        const video = AbstractVideo(
          video1080h264: 'http://h264.mp4',
          video1080sdr: 'http://sdr.mp4',
          video4ksdr: 'http://4ksdr.mp4',
        );
        expect(video.allUrls().length, 3);
      });

      test('returns empty list when no URLs', () {
        const video = AbstractVideo();
        expect(video.allUrls(), isEmpty);
      });

      test('skips null URLs', () {
        const video = AbstractVideo(
          video1080sdr: 'http://sdr.mp4',
        );
        expect(video.allUrls(), ['http://sdr.mp4']);
      });
    });

    group('JSON serialization', () {
      test('fromJson parses correctly', () {
        final json = {
          'url-1080-H264': 'http://h264.mp4',
          'url-1080-SDR': 'http://sdr.mp4',
          'accessibilityLabel': 'Test',
          'timeOfDay': 'day',
          'scene': 'beach',
        };
        final video = AbstractVideo.fromJson(json);
        expect(video.video1080h264, 'http://h264.mp4');
        expect(video.video1080sdr, 'http://sdr.mp4');
        expect(video.description, 'Test');
      });

      test('toJson serializes correctly', () {
        const video = AbstractVideo(
          video1080h264: 'http://h264.mp4',
          description: 'Test',
        );
        final json = video.toJson();
        expect(json['url-1080-H264'], 'http://h264.mp4');
        expect(json['accessibilityLabel'], 'Test');
      });

      test('roundtrip preserves data', () {
        const original = AbstractVideo(
          video1080h264: 'http://h264.mp4',
          video1080sdr: 'http://sdr.mp4',
          description: 'Test video',
          timeOfDay: 'sunset',
          scene: 'city',
        );
        final restored = AbstractVideo.fromJson(original.toJson());
        expect(restored.video1080h264, original.video1080h264);
        expect(restored.description, original.description);
      });
    });
  });
}
