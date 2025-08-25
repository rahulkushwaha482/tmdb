import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tmdbapp/core/constant.dart';
import 'package:tmdbapp/models/movie_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/trending/movie/day")
  Future<MovieResponse> getTrendingMovies(@Query("api_key") String apiKey);

  @GET("/movie/now_playing")
  Future<MovieResponse> getNowPlayingMovies(@Query("api_key") String apiKey);

  @GET("/search/movie")
  Future<MovieResponse> searchMovies(
    @Query("api_key") String apiKey,
    @Query("query") String query,
  );
}
