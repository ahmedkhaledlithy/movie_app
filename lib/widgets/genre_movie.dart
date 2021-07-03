import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/bloc/get_movie_byGenre_bloc.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/movie_response.dart';
import 'package:movie_app/screens/details_screen.dart';
import 'package:movie_app/style/theme.dart' as Style;

class GenreMovie extends StatefulWidget {
  final int genreId;

  GenreMovie({@required this.genreId});

  @override
  _GenreMovieState createState() => _GenreMovieState(genreId);
}

class _GenreMovieState extends State<GenreMovie> {
  final int genreId;

  _GenreMovieState(this.genreId);

  @override
  void initState() {
    super.initState();
    moviesByGenreBloc.getMoviesByGenre(genreId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: moviesByGenreBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text(
                "No Connection",
                style: TextStyle(color: Colors.white),
              ),
            );
            break;
          case ConnectionState.waiting:
            return _drawLoading();
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return _drawError(snapshot.error.toString());
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("No Data"),
              );
            } else {
              return _drawMovieByGenre(snapshot.data);
            }
            break;
        }
        return null;
      },
    );
  }

  Widget _drawError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Error is : $error",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _drawLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawMovieByGenre(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "No Movies",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 280,
        padding: EdgeInsets.only(left: 18),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MovieDetailsScreen(movie: movies[index])));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    movies[index].poster == null
                        ? Container(
                            width: 120,
                            height: 150,
                            decoration: BoxDecoration(
                                color: Style.ColorsApp.secondColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                shape: BoxShape.rectangle),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  EvaIcons.filmOutline,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ],
                            ),
                          )
                        : Container(
                      width: 130,
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius:BorderRadius.all(Radius.circular(6)),
                          shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: NetworkImage("https://image.tmdb.org/t/p/w500/" + movies[index].poster),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 8,),
                    Container(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        style: TextStyle(
                          height: 1.4,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),

                    SizedBox(height: 4,),

                    Flexible(
                      child: Row(
                        children: [
                          Text(movies[index].rating.toString(),style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          SizedBox(width: 4,),

                          RatingBar(
                            itemSize: 24,
                            initialRating: movies[index].rating / 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context,_){
                            return  IconButton(icon: Icon(EvaIcons.star,color: Style.ColorsApp.secondColor,), onPressed: (){});
                            },
                            onRatingUpdate: (rating){
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
