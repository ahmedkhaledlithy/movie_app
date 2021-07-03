
import 'package:dio/dio.dart';
import 'package:movie_app/model/cast_response.dart';
import 'package:movie_app/model/genre_response.dart';
import 'package:movie_app/model/movie_detalis_response.dart';
import 'package:movie_app/model/movie_response.dart';
import 'package:movie_app/model/person_response.dart';
import 'package:movie_app/model/video_response.dart';

class MovieRepository {
  final String api_key = "79d8e95dcbb176a778dea0ef4e8ab5d2";
  static String mainUrl = "https://api.themoviedb.org/3";
  final Dio dio = Dio();
  var getPopularUrl = "$mainUrl/movie/top_rated";
  var getMovieUrl = "$mainUrl/discover/movie";
  var getPlayingUrl = "$mainUrl/movie/now_playing";
  var getGenresUrl = "$mainUrl/genre/movie/list";
  var getPersonsUrl = "$mainUrl/trending/person/week";
  var movieUrl="$mainUrl/movie";


  Future<MovieResponse> getMovies() async {
    var params = {
      "api_key": api_key,
      "language": "en-US",
      "page": 1,
    };

    try {
      Response response = await dio.get(getPopularUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception : $error  stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getPlayingMovies() async {
    var params = {
      "api_key": api_key,
      "language": "en-US",
      "page": 1,
    };

    try {
      Response response = await dio.get(getPlayingUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception : $error  stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<GenreResponse> getGenres() async {
    var params = {
      "api_key": api_key,
      "language": "en-US",
      "page": 1,
    };

    try {
      Response response = await dio.get(getGenresUrl, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception : $error  stackTrace: $stacktrace");
      return GenreResponse.withError("$error");
    }
  }

  Future<PersonResponse> getPersons() async {
    var params = {
      "api_key": api_key,
    };

    try {
      Response response = await dio.get(getPersonsUrl, queryParameters: params);
      return PersonResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception : $error  stackTrace: $stacktrace");
      return PersonResponse.witherror("$error");
    }
  }

  Future<MovieResponse> getMoviesByGenre(int id) async {
    var params = {
      "api_key": api_key,
      "language": "en-US",
      "page": 1,
      "with_genres": id
    };

    try {
      Response response = await dio.get(getMovieUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception : $error  stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }


  Future<MovieDetailsResponse> getMoviesDetails(int id) async {
    var params = {
      "api_key": api_key,
      "language": "en-US",
    };

    try {
      Response response = await dio.get(movieUrl + "/$id", queryParameters: params);
      return MovieDetailsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception : $error  stackTrace: $stacktrace");
      return MovieDetailsResponse.withError("$error");
    }
  }

  Future<CastResponse> getCasts(int id) async {
    var params = {
      "api_key": api_key,
      "language": "en-US",
    };

    try {
      Response response = await dio.get(movieUrl + "/$id" + "/credits", queryParameters: params);
      return CastResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception : $error  stackTrace: $stacktrace");
      return CastResponse.withError("$error");
    }
  }

  Future<MovieResponse> getSimilarMovie(int id) async {
    var params = {
      "api_key": api_key,
      "language": "en-US",
    };

    try {
      Response response = await dio.get(movieUrl + "/$id" + "/similar", queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception : $error  stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<VideoResponse> getMoviesVideo(int id) async {
    var params = {
      "api_key": api_key,
      "language": "en-US",
    };

    try {
      Response response = await dio.get(movieUrl + "/$id" + "/videos", queryParameters: params);
      return VideoResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception : $error  stackTrace: $stacktrace");
      return VideoResponse.withError("$error");
    }
  }

}
