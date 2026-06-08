import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/models.dart';
import 'pair.dart';
import 'utils.dart';

/// Base class for providers that load aerial videos from bundled JSON assets.
///
/// Subclasses specify the asset/strings file paths, media source, and quality mapping.
abstract class BundledVideoProvider {
  final VideoQuality quality;
  final Set<TimeOfDay> timeOfDayFilter;
  final Set<SceneType> sceneFilter;
  final bool enabled;

  Map<String, Pair<String, Map<int, String>>> metadata = {};
  List<AerialMedia> videos = [];

  BundledVideoProvider({
    required this.quality,
    this.timeOfDayFilter = const {},
    this.sceneFilter = const {},
    this.enabled = true,
  });

  /// Path to the assets JSON file (e.g., 'assets/tvos26.json').
  String get assetJsonPath;

  /// Path to the strings JSON file (e.g., 'assets/tvos26_strings.json').
  String get stringsJsonPath;

  /// The media source identifier.
  AerialMediaSource get mediaSource;

  /// Resolve a quality level to a URL from the raw JSON map.
  /// Override in subclasses for special handling (e.g., Apple's HTTPS rewrite).
  String resolveUri(Map<String, dynamic> assetMap, VideoQuality q) {
    return (assetMap[qualityUrlKeys[q]] as String?) ?? '';
  }

  Future<List<AerialMedia>> fetch() async {
    if (metadata.isNotEmpty) return videos;
    await _buildVideoAndMetadata();
    return videos;
  }

  List<AerialMedia> fetchMetadata(List<AerialMedia> media) =>
      enrichMetadata(media, metadata);

  Future<void> _buildVideoAndMetadata() async {
    final strings = await _loadStrings();
    final assetMaps = await _loadAssetMaps();

    for (final assetMap in assetMaps) {
      final timeOfDay = TimeOfDay.fromString(assetMap['timeOfDay'] as String?);
      final scene = SceneType.fromString(assetMap['scene'] as String?);

      final timeOfDayMatches =
          timeOfDayFilter.isEmpty || timeOfDayFilter.contains(timeOfDay);
      final sceneMatches =
          sceneFilter.isEmpty || sceneFilter.contains(scene);

      if (timeOfDayMatches && sceneMatches && enabled) {
        videos.add(AerialMedia(
          url: resolveUri(assetMap, quality),
          type: AerialMediaType.video,
          source: mediaSource,
          metadata: AerialMediaMetadata(
            timeOfDay: timeOfDay,
            scene: scene,
          ),
        ));
      }

      final description = (assetMap['accessibilityLabel'] as String?) ?? '';
      final poiRaw =
          (assetMap['pointsOfInterest'] as Map<String, dynamic>?) ?? {};
      final poi = poiRaw.map((key, value) {
        return MapEntry(int.tryParse(key.toString()) ?? 0,
            strings[value.toString()] ?? description);
      });
      final data = Pair(description, poi);

      for (final url in _allUrls(assetMap)) {
        metadata[filenameWithoutExtension(url)] = data;
      }
    }
  }

  Future<List<Map<String, dynamic>>> _loadAssetMaps() async {
    final json = await rootBundle.loadString(assetJsonPath);
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return (decoded['assets'] as List<dynamic>? ?? [])
        .map((a) => a as Map<String, dynamic>)
        .toList();
  }

  Future<Map<String, String>> _loadStrings() async {
    try {
      final json = await rootBundle.loadString(stringsJsonPath);
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  List<String> _allUrls(Map<String, dynamic> assetMap) {
    return qualityUrlKeys.values
        .map((key) => assetMap[key] as String?)
        .whereType<String>()
        .where((url) => url.isNotEmpty)
        .toList();
  }
}