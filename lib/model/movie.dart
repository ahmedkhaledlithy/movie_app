class Movie{
  final int id;
  final double popularity;
  final String title;
  final String poster;
  final String backPoster;
  final String overview;
  final double rating;

  Movie(this.id, this.popularity, this.title, this.poster, this.backPoster,
      this.overview, this.rating);

  Movie.fromJson(Map<String,dynamic>json):
   id=json["id"],
   popularity=json["popularity"],
   title=json["title"],
   poster=json["poster_path"],
   backPoster=json["backdrop_path"],
   overview=json["overview"],
   rating=json["vote_average"].toDouble();

}