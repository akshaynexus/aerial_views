import '../models/models.dart';
import 'utils.dart';

/// Parsed CSV media item containing a URL, description, and detected type.
class CsvMediaItem {
  final String url;
  final String description;
  final AerialMediaType type;

  const CsvMediaItem({
    required this.url,
    required this.description,
    required this.type,
  });
}

/// Parser for CSV media lists in "url,description" format.
///
/// Skips header rows where the URL column equals "url" (case-insensitive).
/// Detects media type by file extension.
class CsvParser {
  /// Parses CSV content into a list of [CsvMediaItem]s.
  ///
  /// Each line should be in "url,description" format.
  /// Lines with unrecognized media types or the header row are skipped.
  static List<CsvMediaItem> parse(String content) {
    return content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .map(_parseLine)
        .whereType<CsvMediaItem>()
        .toList();
  }

  static CsvMediaItem? _parseLine(String line) {
    final unquotedLine = _trimWrappingQuotes(line);
    final commaIndex = unquotedLine.indexOf(',');
    final rawUrl =
        commaIndex >= 0 ? unquotedLine.substring(0, commaIndex) : unquotedLine;
    final rawDescription =
        commaIndex >= 0 ? unquotedLine.substring(commaIndex + 1) : '';

    final url = _trimWrappingQuotes(rawUrl.trim());
    if (url.toLowerCase() == 'url') return null;

    final mediaType = _mediaTypeFor(url);
    if (mediaType == null) return null;

    return CsvMediaItem(
      url: url,
      description: _trimWrappingQuotes(rawDescription.trim()),
      type: mediaType,
    );
  }

  static AerialMediaType? _mediaTypeFor(String url) {
    final path = url.split('?').first.split('#').first;
    return detectMediaType(path);
  }

  static String _trimWrappingQuotes(String value) {
    final trimmed = value.trim();
    if (trimmed.length >= 2 &&
        trimmed.startsWith('"') &&
        trimmed.endsWith('"')) {
      return trimmed.substring(1, trimmed.length - 1);
    }
    return trimmed;
  }
}
