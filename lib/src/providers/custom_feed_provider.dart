import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';
import 'csv_parser.dart';
import 'pair.dart';
import 'utils.dart';

/// Provider that fetches aerial media from custom user-provided URLs.
///
/// Supports multiple feed formats:
/// - RTSP streams (added directly)
/// - HLS streams (.m3u8, added directly)
/// - CSV media lists (.csv, parsed for video/image URLs)
/// - Video feed entries (entries.json format)
/// - Manifest feeds (manifest.json with sources pointing to entries.json)
class CustomFeedProvider {
  final VideoQuality quality;
  final Set<String> urls;
  final bool enabled;

  List<AerialMedia> videos = [];
  Map<String, Pair<String, Map<int, String>>> metadata = {};

  CustomFeedProvider({
    required this.quality,
    required this.urls,
    this.enabled = true,
  });

  Future<List<AerialMedia>> fetch() async {
    videos.clear();
    metadata.clear();

    if (!enabled || urls.isEmpty) return videos;

    for (final url in urls) {
      try {
        if (url.startsWith('rtsp://')) {
          _processStream(url, AerialMediaSource.rtsp, 'RTSP Stream');
        } else if (url.endsWith('.m3u8') || url.contains('.m3u8?')) {
          _processStream(url, AerialMediaSource.hls, 'HLS Stream');
        } else if (_isCsvUrl(url)) {
          await _processCsvUrl(url);
        } else if (url.endsWith('entries.json')) {
          await _processEntriesUrl(url);
        } else {
          await _processManifestUrl(url);
        }
      } catch (e) {
        // Skip URLs that fail to load
      }
    }

    return videos;
  }

  List<AerialMedia> fetchMetadata(List<AerialMedia> media) =>
      enrichMetadata(media, metadata);

  void _processStream(String url, AerialMediaSource source, String label) {
    videos.add(AerialMedia(
      url: url,
      type: AerialMediaType.video,
      source: source,
      metadata: const AerialMediaMetadata(),
    ));
    metadata[url] = Pair('$label: $url', {});
  }

  Future<String> _fetchBody(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    return utf8.decode(response.bodyBytes);
  }

  Future<dynamic> _fetchJson(String url) async {
    final body = await _fetchBody(url);
    return jsonDecode(body);
  }

  void _addVideo(String url) {
    videos.add(AerialMedia(
      url: url,
      type: AerialMediaType.video,
      source: AerialMediaSource.custom,
      metadata: const AerialMediaMetadata(),
    ));
  }

  Future<void> _processCsvUrl(String url) async {
    final csvItems = CsvParser.parse(await _fetchBody(url));
    for (final item in csvItems) {
      videos.add(AerialMedia(
        url: item.url,
        type: item.type,
        source: AerialMediaSource.custom,
        metadata: AerialMediaMetadata(shortDescription: item.description),
      ));
    }
  }

  Future<void> _processEntriesUrl(String url) async {
    final decoded = await _fetchJson(url);
    final assets = (decoded['assets'] as List<dynamic>?) ?? [];

    for (final asset in assets) {
      final assetMap = asset as Map<String, dynamic>;
      final videoUrl = _uriAtQuality(assetMap);
      if (videoUrl.isEmpty) continue;

      final description = (assetMap['accessibilityLabel'] as String?) ?? '';
      final poiRaw =
          (assetMap['pointsOfInterest'] as Map<String, dynamic>?) ?? {};
      final poi = poiRaw.map((k, v) =>
          MapEntry(int.tryParse(k.toString()) ?? 0, v.toString()));

      _addVideo(videoUrl);

      final data = Pair(description, poi);
      for (final url in _allUrls(assetMap)) {
        metadata[filenameWithoutExtension(url)] = data;
      }
    }
  }

  Future<void> _processManifestUrl(String inputUrl) async {
    final baseUrl = inputUrl.endsWith('/')
        ? inputUrl.substring(0, inputUrl.length - 1)
        : inputUrl;
    final manifestUrl = inputUrl.endsWith('manifest.json')
        ? inputUrl
        : '$baseUrl/manifest.json';

    final decoded = await _fetchJson(manifestUrl);

    // Try single manifest format: { "name": "...", "manifestUrl": "..." }
    if (decoded is Map<String, dynamic> && decoded.containsKey('manifestUrl')) {
      final entriesUrl = decoded['manifestUrl'] as String;
      if (entriesUrl.isNotEmpty) {
        await _processEntriesUrl(entriesUrl);
      }
      return;
    }

    // Try multi-manifest format: { "sources": [{ "manifestUrl": "..." }] }
    if (decoded is Map<String, dynamic> && decoded.containsKey('sources')) {
      final sources = decoded['sources'] as List<dynamic>? ?? [];
      for (final source in sources) {
        final sourceMap = source as Map<String, dynamic>;
        final entriesUrl = (sourceMap['manifestUrl'] as String?) ?? '';
        if (entriesUrl.isNotEmpty) {
          await _processEntriesUrl(entriesUrl);
        }
      }
    }
  }

  String _uriAtQuality(Map<String, dynamic> asset) {
    return (asset[qualityUrlKeys[quality]] as String?) ?? '';
  }

  List<String> _allUrls(Map<String, dynamic> asset) {
    return qualityUrlKeys.values
        .map((key) => asset[key] as String?)
        .whereType<String>()
        .where((url) => url.isNotEmpty)
        .toList();
  }

  bool _isCsvUrl(String url) =>
      url.endsWith('.csv') || url.contains('.csv?');

}
