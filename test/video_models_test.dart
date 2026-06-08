import 'package:flutter_test/flutter_test.dart';
import 'package:aerial_views/aerial_views.dart';

void main() {
  group('AppleVideo', () {
    test('constructs with fields', () {
      const video = AppleVideo(
        video1080sdr: 'https://example.com/sdr.mp4',
        description: 'Test',
      );
      expect(video.video1080sdr, 'https://example.com/sdr.mp4');
      expect(video.description, 'Test');
    });

    test('uriAtQuality rewrites https to http', () {
      const video = AppleVideo(
        video1080sdr: 'https://example.com/sdr.mp4',
      );
      expect(video.uriAtQuality(VideoQuality.video1080Sdr), 'http://example.com/sdr.mp4');
    });

    test('uriAtQuality returns empty for missing quality', () {
      const video = AppleVideo();
      expect(video.uriAtQuality(VideoQuality.video1080Sdr), '');
    });

    test('fromJson parses correctly', () {
      final json = {
        'url-1080-SDR': 'https://example.com/sdr.mp4',
        'accessibilityLabel': 'Test',
      };
      final video = AppleVideo.fromJson(json);
      expect(video.video1080sdr, 'https://example.com/sdr.mp4');
    });

    test('toJson serializes correctly', () {
      const video = AppleVideo(video1080sdr: 'https://example.com/sdr.mp4');
      final json = video.toJson();
      expect(json['url-1080-SDR'], 'https://example.com/sdr.mp4');
    });
  });

  group('AppleVideos', () {
    test('fromJson parses list', () {
      final json = {
        'assets': [
          {'url-1080-SDR': 'http://a.mp4'},
          {'url-1080-SDR': 'http://b.mp4'},
        ],
      };
      final videos = AppleVideos.fromJson(json);
      expect(videos.assets!.length, 2);
    });

    test('fromJson handles null assets', () {
      final json = <String, dynamic>{};
      final videos = AppleVideos.fromJson(json);
      expect(videos.assets, isNull);
    });
  });

  group('AmazonVideo', () {
    test('constructs with fields', () {
      const video = AmazonVideo(
        video1080sdr: 'http://example.com/sdr.mp4',
        description: 'Test',
      );
      expect(video.video1080sdr, 'http://example.com/sdr.mp4');
    });

    test('fromJson parses correctly', () {
      final json = {
        'url-1080-SDR': 'http://example.com/sdr.mp4',
        'accessibilityLabel': 'Test',
      };
      final video = AmazonVideo.fromJson(json);
      expect(video.video1080sdr, 'http://example.com/sdr.mp4');
    });

    test('toJson serializes correctly', () {
      const video = AmazonVideo(video1080sdr: 'http://example.com/sdr.mp4');
      final json = video.toJson();
      expect(json['url-1080-SDR'], 'http://example.com/sdr.mp4');
    });
  });

  group('AmazonVideos', () {
    test('fromJson parses list', () {
      final json = {
        'assets': [
          {'url-1080-SDR': 'http://a.mp4'},
        ],
      };
      final videos = AmazonVideos.fromJson(json);
      expect(videos.assets!.length, 1);
    });

    test('fromJson handles null assets', () {
      final json = <String, dynamic>{};
      final videos = AmazonVideos.fromJson(json);
      expect(videos.assets, isNull);
    });
  });

  group('Comm1Video', () {
    test('constructs with fields', () {
      const video = Comm1Video(
        video1080h264: 'http://example.com/h264.mp4',
        description: 'Test',
      );
      expect(video.video1080h264, 'http://example.com/h264.mp4');
    });

    test('fromJson parses correctly', () {
      final json = {
        'url-1080-H264': 'http://example.com/h264.mp4',
        'accessibilityLabel': 'Test',
      };
      final video = Comm1Video.fromJson(json);
      expect(video.video1080h264, 'http://example.com/h264.mp4');
    });
  });

  group('Comm1Videos', () {
    test('fromJson parses list', () {
      final json = {
        'assets': [
          {'url-1080-H264': 'http://a.mp4'},
        ],
      };
      final videos = Comm1Videos.fromJson(json);
      expect(videos.assets!.length, 1);
    });
  });

  group('Comm2Video', () {
    test('constructs with fields', () {
      const video = Comm2Video(
        video1080h264: 'http://example.com/h264.mp4',
        video1080hdr: 'http://example.com/hdr.mp4',
        description: 'Test',
      );
      expect(video.video1080h264, 'http://example.com/h264.mp4');
    });

    test('uriAtQuality maps 1080Sdr to 1080Hdr', () {
      const video = Comm2Video(
        video1080h264: 'http://h264.mp4',
        video1080hdr: 'http://hdr.mp4',
        video4ksdr: 'http://4ksdr.mp4',
      );
      // Comm2 maps 1080Sdr to 1080Hdr
      expect(video.uriAtQuality(VideoQuality.video1080Sdr), 'http://hdr.mp4');
    });

    test('uriAtQuality returns 4kSdr', () {
      const video = Comm2Video(video4ksdr: 'http://4ksdr.mp4');
      expect(video.uriAtQuality(VideoQuality.video4kSdr), 'http://4ksdr.mp4');
    });

    test('uriAtQuality defaults to 1080H264', () {
      const video = Comm2Video(video1080h264: 'http://h264.mp4');
      expect(video.uriAtQuality(null), 'http://h264.mp4');
    });

    test('uriAtQuality returns empty for missing quality', () {
      const video = Comm2Video();
      expect(video.uriAtQuality(VideoQuality.video1080Sdr), '');
    });
  });

  group('Comm2Videos', () {
    test('fromJson parses list', () {
      final json = {
        'assets': [
          {'url-1080-H264': 'http://a.mp4'},
        ],
      };
      final videos = Comm2Videos.fromJson(json);
      expect(videos.assets!.length, 1);
    });
  });
}
