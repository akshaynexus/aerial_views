// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abstract_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbstractVideo _$AbstractVideoFromJson(Map<String, dynamic> json) =>
    AbstractVideo(
      video1080h264: json['url-1080-H264'] as String?,
      video1080sdr: json['url-1080-SDR'] as String?,
      video1080hdr: json['url-1080-HDR'] as String?,
      video4ksdr: json['url-4K-SDR'] as String?,
      video4khdr: json['url-4K-HDR'] as String?,
      description: json['accessibilityLabel'] as String? ?? '',
      pointsOfInterest:
          (json['pointsOfInterest'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      timeOfDay: json['timeOfDay'] as String? ?? '',
      scene: json['scene'] as String? ?? '',
    );

Map<String, dynamic> _$AbstractVideoToJson(AbstractVideo instance) =>
    <String, dynamic>{
      'url-1080-H264': instance.video1080h264,
      'url-1080-SDR': instance.video1080sdr,
      'url-1080-HDR': instance.video1080hdr,
      'url-4K-SDR': instance.video4ksdr,
      'url-4K-HDR': instance.video4khdr,
      'accessibilityLabel': instance.description,
      'pointsOfInterest': instance.pointsOfInterest,
      'timeOfDay': instance.timeOfDay,
      'scene': instance.scene,
    };
