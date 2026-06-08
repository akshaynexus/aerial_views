import 'pair.dart';

/// Validates and parses comma-separated URL strings.
///
/// Supports HTTP/HTTPS URLs and RTSP stream URLs.
class UrlValidator {
  /// Validates a single URL string.
  ///
  /// For RTSP URLs, checks that a host is present.
  /// For other URLs, checks that the string parses as a valid URI.
  static bool isValidUrl(String url) {
    if (url.startsWith('rtsp://')) {
      final uri = Uri.tryParse(url);
      return uri?.host != null && uri!.host.isNotEmpty;
    }
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme;
  }

  /// Parses a comma-separated string of URLs into a list of trimmed URLs.
  ///
  /// Returns only non-blank entries, without validation.
  static List<String> parseUrls(String urlsString) {
    if (urlsString.trim().isEmpty) return [];
    return urlsString
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// Validates a comma-separated string of URLs.
  ///
  /// Returns a list of [Pair]s where `first` is whether the URL is valid
  /// and `second` is the trimmed URL string.
  static List<Pair<bool, String>> validateUrls(String urlsString) {
    if (urlsString.trim().isEmpty) return [];
    return parseUrls(urlsString).map((url) {
      return Pair(isValidUrl(url), url);
    }).toList();
  }
}


