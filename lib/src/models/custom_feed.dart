import 'package:json_annotation/json_annotation.dart';

import 'comm_video.dart';

part 'custom_feed.g.dart';

@JsonSerializable()
class FeedVideos {
  final List<Comm1Video>? assets;

  const FeedVideos({this.assets});

  factory FeedVideos.fromJson(Map<String, dynamic> json) =>
      _$FeedVideosFromJson(json);

  Map<String, dynamic> toJson() => _$FeedVideosToJson(this);
}

@JsonSerializable()
class FeedManifest {
  final String name;
  final String? description;
  final String manifestUrl;

  const FeedManifest({
    required this.name,
    this.description,
    required this.manifestUrl,
  });

  factory FeedManifest.fromJson(Map<String, dynamic> json) =>
      _$FeedManifestFromJson(json);

  Map<String, dynamic> toJson() => _$FeedManifestToJson(this);
}

@JsonSerializable()
class FeedManifests {
  final List<FeedManifest> sources;

  const FeedManifests({required this.sources});

  factory FeedManifests.fromJson(Map<String, dynamic> json) =>
      _$FeedManifestsFromJson(json);

  Map<String, dynamic> toJson() => _$FeedManifestsToJson(this);
}
