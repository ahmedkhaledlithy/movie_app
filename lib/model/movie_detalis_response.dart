import 'package:movie_app/model/movie_details.dart';

class MovieDetailsResponse {
  final MovieDetails movieDetails;
  final String error;

  MovieDetailsResponse(this.movieDetails, this.error);

  MovieDetailsResponse.fromJson(Map<String, dynamic> json)
      : movieDetails = MovieDetails.fromJson(json),
        error = "";

  MovieDetailsResponse.withError(String errorValue)
      : movieDetails = MovieDetails(null, null, null, null, "", null),
        error = errorValue;
}
