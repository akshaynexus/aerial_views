/// Shared utility functions for media file handling across providers.
library;

import '../models/models.dart';
import 'pair.dart';

String filenameWithoutExtension(String url) {
  final parsed = Uri.tryParse(url);
  if (parsed == null) return url.toLowerCase();
  final pathSegments = parsed.pathSegments;
  if (pathSegments.isEmpty) return url.toLowerCase();
  final filename = pathSegments.last;
  final dotIndex = filename.lastIndexOf('.');
  final name = dotIndex > 0 ? filename.substring(0, dotIndex) : filename;
  return name.toLowerCase();
}

const _videoExtensions = ['.mov', '.mp4', '.m4v', '.webm', '.mkv', '.ts', '.m3u8'];

bool isSupportedVideoType(String filename) {
  final lower = filename.toLowerCase();
  return _videoExtensions.any(lower.endsWith);
}

const _imageExtensions = ['.jpg', '.jpeg', '.gif', '.webp', '.heic', '.png', '.avif'];

bool isSupportedImageType(String filename) {
  final lower = filename.toLowerCase();
  return _imageExtensions.any(lower.endsWith);
}

String cleanSharedLinkKey(String input) {
  var result = input.trim();
  result = result.replaceFirst(RegExp(r'^/+'), '');
  result = result.replaceFirst(RegExp(r'/+$'), '');
  result = result.replaceFirst(RegExp(r'^(share|s)/'), '');
  return result;
}

/// Maps each [VideoQuality] to its corresponding JSON key in asset maps.
const qualityUrlKeys = {
  VideoQuality.video1080H264: 'url-1080-H264',
  VideoQuality.video1080Sdr: 'url-1080-SDR',
  VideoQuality.video1080Hdr: 'url-1080-HDR',
  VideoQuality.video4kSdr: 'url-4K-SDR',
  VideoQuality.video4kHdr: 'url-4K-HDR',
};

/// Returns the [AerialMediaType] for a given filename, or null if unsupported.
AerialMediaType? detectMediaType(String filename) {
  if (isSupportedVideoType(filename)) return AerialMediaType.video;
  if (isSupportedImageType(filename)) return AerialMediaType.image;
  return null;
}

/// Enriches [media] items with metadata from [metadata] map.
List<AerialMedia> enrichMetadata(
  List<AerialMedia> media,
  Map<String, Pair<String, Map<int, String>>> metadata,
) {
  if (metadata.isEmpty) return media;
  return media.map((item) {
    final data = metadata[filenameWithoutExtension(item.url)];
    if (data != null) {
      return AerialMedia(
        url: item.url,
        type: item.type,
        source: item.source,
        metadata: item.metadata.copyWith(
          shortDescription: data.first,
          pointsOfInterest: data.second,
        ),
      );
    }
    return item;
  }).toList();
}
