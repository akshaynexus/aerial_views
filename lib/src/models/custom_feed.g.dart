// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedVideos _$FeedVideosFromJson(Map<String, dynamic> json) => FeedVideos(
  assets: (json['assets'] as List<dynamic>?)
      ?.map((e) => Comm1Video.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FeedVideosToJson(FeedVideos instance) =>
    <String, dynamic>{'assets': instance.assets};

FeedManifest _$FeedManifestFromJson(Map<String, dynamic> json) => FeedManifest(
  name: json['name'] as String,
  description: json['description'] as String?,
  manifestUrl: json['manifestUrl'] as String,
);

Map<String, dynamic> _$FeedManifestToJson(FeedManifest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'manifestUrl': instance.manifestUrl,
    };

FeedManifests _$FeedManifestsFromJson(Map<String, dynamic> json) =>
    FeedManifests(
      sources: (json['sources'] as List<dynamic>)
          .map((e) => FeedManifest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedManifestsToJson(FeedManifests instance) =>
    <String, dynamic>{'sources': instance.sources};
