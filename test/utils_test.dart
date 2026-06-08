import 'package:flutter_test/flutter_test.dart';
import 'package:aerial_views/aerial_views.dart';

void main() {
  group('filenameWithoutExtension', () {
    test('extracts filename from URL', () {
      expect(filenameWithoutExtension('https://example.com/video.mov'), 'video');
    });

    test('handles URL with query parameters', () {
      expect(filenameWithoutExtension('https://example.com/video.mov?quality=high'), 'video');
    });

    test('handles URL with hash fragment', () {
      expect(filenameWithoutExtension('https://example.com/video.mov#t=10'), 'video');
    });

    test('handles URL with multiple path segments', () {
      expect(filenameWithoutExtension('https://example.com/path/to/video.mp4'), 'video');
    });

    test('returns lowercase', () {
      expect(filenameWithoutExtension('https://example.com/VIDEO.MOV'), 'video');
    });

    test('handles URL without extension', () {
      expect(filenameWithoutExtension('https://example.com/noext'), 'noext');
    });

    test('handles invalid URL', () {
      expect(filenameWithoutExtension('not a url'), 'not a url');
    });

    test('handles empty path', () {
      expect(filenameWithoutExtension('https://example.com'), 'https://example.com');
    });
  });

  group('isSupportedVideoType', () {
    test('supports .mov', () {
      expect(isSupportedVideoType('video.mov'), isTrue);
    });

    test('supports .mp4', () {
      expect(isSupportedVideoType('video.mp4'), isTrue);
    });

    test('supports .m4v', () {
      expect(isSupportedVideoType('video.m4v'), isTrue);
    });

    test('supports .webm', () {
      expect(isSupportedVideoType('video.webm'), isTrue);
    });

    test('supports .mkv', () {
      expect(isSupportedVideoType('video.mkv'), isTrue);
    });

    test('supports .ts', () {
      expect(isSupportedVideoType('video.ts'), isTrue);
    });

    test('supports .m3u8', () {
      expect(isSupportedVideoType('stream.m3u8'), isTrue);
    });

    test('rejects .jpg', () {
      expect(isSupportedVideoType('image.jpg'), isFalse);
    });

    test('rejects .png', () {
      expect(isSupportedVideoType('image.png'), isFalse);
    });

    test('rejects unknown extension', () {
      expect(isSupportedVideoType('file.xyz'), isFalse);
    });

    test('case insensitive', () {
      expect(isSupportedVideoType('VIDEO.MOV'), isTrue);
      expect(isSupportedVideoType('Video.MP4'), isTrue);
    });
  });

  group('isSupportedImageType', () {
    test('supports .jpg', () {
      expect(isSupportedImageType('image.jpg'), isTrue);
    });

    test('supports .jpeg', () {
      expect(isSupportedImageType('image.jpeg'), isTrue);
    });

    test('supports .gif', () {
      expect(isSupportedImageType('image.gif'), isTrue);
    });

    test('supports .webp', () {
      expect(isSupportedImageType('image.webp'), isTrue);
    });

    test('supports .heic', () {
      expect(isSupportedImageType('image.heic'), isTrue);
    });

    test('supports .png', () {
      expect(isSupportedImageType('image.png'), isTrue);
    });

    test('supports .avif', () {
      expect(isSupportedImageType('image.avif'), isTrue);
    });

    test('rejects .mp4', () {
      expect(isSupportedImageType('video.mp4'), isFalse);
    });

    test('rejects unknown extension', () {
      expect(isSupportedImageType('file.xyz'), isFalse);
    });

    test('case insensitive', () {
      expect(isSupportedImageType('IMAGE.JPG'), isTrue);
    });
  });

  group('cleanSharedLinkKey', () {
    test('strips leading slashes', () {
      expect(cleanSharedLinkKey('/abc123'), 'abc123');
    });

    test('strips trailing slashes', () {
      expect(cleanSharedLinkKey('abc123/'), 'abc123');
    });

    test('strips share/ prefix', () {
      expect(cleanSharedLinkKey('share/abc123'), 'abc123');
    });

    test('strips s/ prefix', () {
      expect(cleanSharedLinkKey('s/abc123'), 'abc123');
    });

    test('strips leading and trailing whitespace', () {
      expect(cleanSharedLinkKey('  abc123  '), 'abc123');
    });

    test('handles complex path', () {
      expect(cleanSharedLinkKey('/share/abc123/'), 'abc123');
    });

    test('handles plain key', () {
      expect(cleanSharedLinkKey('abc123'), 'abc123');
    });
  });

  group('detectMediaType', () {
    test('detects video', () {
      expect(detectMediaType('video.mp4'), AerialMediaType.video);
    });

    test('detects image', () {
      expect(detectMediaType('image.jpg'), AerialMediaType.image);
    });

    test('returns null for unsupported', () {
      expect(detectMediaType('file.xyz'), isNull);
    });
  });

  group('qualityUrlKeys', () {
    test('maps video1080H264', () {
      expect(qualityUrlKeys[VideoQuality.video1080H264], 'url-1080-H264');
    });

    test('maps video1080Sdr', () {
      expect(qualityUrlKeys[VideoQuality.video1080Sdr], 'url-1080-SDR');
    });

    test('maps video1080Hdr', () {
      expect(qualityUrlKeys[VideoQuality.video1080Hdr], 'url-1080-HDR');
    });

    test('maps video4kSdr', () {
      expect(qualityUrlKeys[VideoQuality.video4kSdr], 'url-4K-SDR');
    });

    test('maps video4kHdr', () {
      expect(qualityUrlKeys[VideoQuality.video4kHdr], 'url-4K-HDR');
    });
  });

  group('enrichMetadata', () {
    test('enriches media with matching metadata', () {
      final media = [
        AerialMedia(
          url: 'https://example.com/video.mp4',
          type: AerialMediaType.video,
          source: AerialMediaSource.apple,
        ),
      ];
      final metadata = {
        'video': Pair<String, Map<int, String>>('A beautiful video', {0: 'Scene 1', 10: 'Scene 2'}),
      };

      final enriched = enrichMetadata(media, metadata);
      expect(enriched.first.metadata.shortDescription, 'A beautiful video');
      expect(enriched.first.metadata.pointsOfInterest, {0: 'Scene 1', 10: 'Scene 2'});
    });

    test('returns original media when metadata is empty', () {
      final media = [
        AerialMedia(
          url: 'https://example.com/video.mp4',
          type: AerialMediaType.video,
          source: AerialMediaSource.apple,
        ),
      ];

      final enriched = enrichMetadata(media, {});
      expect(enriched.first.metadata.shortDescription, '');
    });

    test('returns original media when no match found', () {
      final media = [
        AerialMedia(
          url: 'https://example.com/video.mp4',
          type: AerialMediaType.video,
          source: AerialMediaSource.apple,
        ),
      ];
      final metadata = {
        'other': Pair<String, Map<int, String>>('Other description', {}),
      };

      final enriched = enrichMetadata(media, metadata);
      expect(enriched.first.metadata.shortDescription, '');
    });
  });
}
