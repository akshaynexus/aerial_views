import 'package:json_annotation/json_annotation.dart';

import 'abstract_video.dart';

part 'amazon_video.g.dart';

@JsonSerializable()
class AmazonVideo extends AbstractVideo {
  const AmazonVideo({
    super.video1080h264,
    super.video1080sdr,
    super.video1080hdr,
    super.video4ksdr,
    super.video4khdr,
    super.description,
    super.pointsOfInterest,
    super.timeOfDay,
    super.scene,
  });

  factory AmazonVideo.fromJson(Map<String, dynamic> json) =>
      _$AmazonVideoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AmazonVideoToJson(this);

}

@JsonSerializable()
class AmazonVideos {
  final List<AmazonVideo>? assets;

  const AmazonVideos({this.assets});

  factory AmazonVideos.fromJson(Map<String, dynamic> json) =>
      _$AmazonVideosFromJson(json);

  Map<String, dynamic> toJson() => _$AmazonVideosToJson(this);
}
