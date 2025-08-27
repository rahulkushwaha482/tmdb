import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final int id;
  final String title;
  @JsonKey(name: "poster_path")
  final String? posterPath;
  final String? overview;
  final String? original_language;
  final String? release_date;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.overview,
    this.original_language,
    this.release_date,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
