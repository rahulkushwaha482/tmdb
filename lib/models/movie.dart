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

  Map<String, dynamic> toDbJson() {
    return {
      "id": id,
      "title": title,
      "posterPath": posterPath,
      "overview": overview,
      "original_language": original_language,
      "release_date": release_date,
    };
  }

  factory Movie.fromDbJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['posterPath'],
      overview: json['overview'],
      original_language: json['original_language'],
      release_date: json['release_date'],
    );
  }
}
