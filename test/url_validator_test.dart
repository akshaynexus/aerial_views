import 'package:flutter_test/flutter_test.dart';
import 'package:aerial_views/aerial_views.dart';

void main() {
  group('UrlValidator.isValidUrl', () {
    test('validates HTTP URL', () {
      expect(UrlValidator.isValidUrl('http://example.com'), isTrue);
    });

    test('validates HTTPS URL', () {
      expect(UrlValidator.isValidUrl('https://example.com'), isTrue);
    });

    test('validates URL with path', () {
      expect(UrlValidator.isValidUrl('https://example.com/video.mp4'), isTrue);
    });

    test('validates RTSP URL', () {
      expect(UrlValidator.isValidUrl('rtsp://camera.local/stream'), isTrue);
    });

    test('rejects empty string', () {
      expect(UrlValidator.isValidUrl(''), isFalse);
    });

    test('rejects string without scheme', () {
      expect(UrlValidator.isValidUrl('example.com'), isFalse);
    });

    test('rejects plain text', () {
      expect(UrlValidator.isValidUrl('not a url'), isFalse);
    });

    test('validates RTSP with port', () {
      expect(UrlValidator.isValidUrl('rtsp://camera.local:554/stream'), isTrue);
    });
  });

  group('UrlValidator.parseUrls', () {
    test('parses comma-separated URLs', () {
      final urls = UrlValidator.parseUrls('http://a.com,http://b.com');
      expect(urls.length, 2);
      expect(urls[0], 'http://a.com');
      expect(urls[1], 'http://b.com');
    });

    test('trims whitespace', () {
      final urls = UrlValidator.parseUrls('  http://a.com  ,  http://b.com  ');
      expect(urls[0], 'http://a.com');
      expect(urls[1], 'http://b.com');
    });

    test('handles empty string', () {
      final urls = UrlValidator.parseUrls('');
      expect(urls.isEmpty, isTrue);
    });

    test('handles whitespace-only string', () {
      final urls = UrlValidator.parseUrls('   ');
      expect(urls.isEmpty, isTrue);
    });

    test('handles single URL', () {
      final urls = UrlValidator.parseUrls('http://example.com');
      expect(urls.length, 1);
    });

    test('skips empty entries', () {
      final urls = UrlValidator.parseUrls('http://a.com,,http://b.com,');
      expect(urls.length, 2);
    });
  });

  group('UrlValidator.validateUrls', () {
    test('validates multiple URLs', () {
      final results = UrlValidator.validateUrls('http://a.com,http://b.com');
      expect(results.length, 2);
      expect(results[0].first, isTrue);
      expect(results[1].first, isTrue);
    });

    test('marks invalid URLs', () {
      final results = UrlValidator.validateUrls('http://a.com,not a url');
      expect(results.length, 2);
      expect(results[0].first, isTrue);
      expect(results[1].first, isFalse);
    });

    test('handles empty string', () {
      final results = UrlValidator.validateUrls('');
      expect(results.isEmpty, isTrue);
    });

    test('preserves URL in pair', () {
      final results = UrlValidator.validateUrls('http://example.com');
      expect(results[0].second, 'http://example.com');
    });
  });
}
