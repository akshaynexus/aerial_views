import 'package:flutter_test/flutter_test.dart';
import 'package:aerial_views/aerial_views.dart';

void main() {
  group('CsvParser.parse', () {
    test('parses video entries', () {
      final csv = 'https://example.com/video.mp4,Beach sunset\n'
          'https://example.com/clip.mov,Mountain view';
      final items = CsvParser.parse(csv);
      expect(items.length, 2);
      expect(items[0].url, 'https://example.com/video.mp4');
      expect(items[0].description, 'Beach sunset');
      expect(items[0].type, AerialMediaType.video);
      expect(items[1].url, 'https://example.com/clip.mov');
      expect(items[1].description, 'Mountain view');
    });

    test('parses image entries', () {
      final csv = 'https://example.com/photo.jpg,A beautiful photo';
      final items = CsvParser.parse(csv);
      expect(items.length, 1);
      expect(items[0].type, AerialMediaType.image);
    });

    test('skips header row', () {
      final csv = 'url,description\n'
          'https://example.com/video.mp4,Beach sunset';
      final items = CsvParser.parse(csv);
      expect(items.length, 1);
      expect(items[0].url, 'https://example.com/video.mp4');
    });

    test('skips header case insensitive', () {
      final csv = 'URL,Description\n'
          'https://example.com/video.mp4,Beach sunset';
      final items = CsvParser.parse(csv);
      expect(items.length, 1);
    });

    test('skips unsupported media types', () {
      final csv = 'https://example.com/file.xyz,Unknown file\n'
          'https://example.com/video.mp4,Valid video';
      final items = CsvParser.parse(csv);
      expect(items.length, 1);
      expect(items[0].url, 'https://example.com/video.mp4');
    });

    test('skips empty lines', () {
      final csv = 'https://example.com/video.mp4,Beach sunset\n'
          '\n'
          'https://example.com/clip.mov,Mountain view';
      final items = CsvParser.parse(csv);
      expect(items.length, 2);
    });

    test('handles URLs with query parameters', () {
      final csv = 'https://example.com/video.mp4?quality=high,Beach sunset';
      final items = CsvParser.parse(csv);
      expect(items.length, 1);
      expect(items[0].url, 'https://example.com/video.mp4?quality=high');
    });

    test('handles URLs with hash fragments', () {
      final csv = 'https://example.com/video.mp4#t=10,Beach sunset';
      final items = CsvParser.parse(csv);
      expect(items.length, 1);
    });

    test('handles quoted URLs', () {
      final csv = '"https://example.com/video.mp4",Beach sunset';
      final items = CsvParser.parse(csv);
      expect(items.length, 1);
      expect(items[0].url, 'https://example.com/video.mp4');
    });

    test('handles empty content', () {
      final items = CsvParser.parse('');
      expect(items.isEmpty, isTrue);
    });

    test('handles single entry without description', () {
      final csv = 'https://example.com/video.mp4';
      final items = CsvParser.parse(csv);
      expect(items.length, 1);
      expect(items[0].url, 'https://example.com/video.mp4');
      expect(items[0].description, '');
    });

    test('handles RTSP URLs', () {
      final csv = 'rtsp://camera.local/stream,Security camera';
      final items = CsvParser.parse(csv);
      expect(items.length, 0); // RTSP is not a supported file type
    });
  });
}
