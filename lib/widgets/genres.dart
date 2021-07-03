import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_genres_bloc.dart';
import 'package:movie_app/model/genre.dart';
import 'package:movie_app/model/genre_response.dart';
import 'package:movie_app/widgets/genres_list.dart';

class GeneresScreen extends StatefulWidget {
  @override
  _GeneresScreenState createState() => _GeneresScreenState();
}

class _GeneresScreenState extends State<GeneresScreen> {
  @override
  void initState() {
    super.initState();
    genresBloc.getGenresList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
      stream: genresBloc.subject.stream,
      builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
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
              return _drawGenres(snapshot.data);
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

  Widget _drawGenres(GenreResponse data) {
    List<Genre> genres = data.genres;
    if (genres.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("No Movies",style: TextStyle(color: Colors.white),),
          ],
        ),
      );
    } else {
        return GenresList(
          genres: genres,
        );
    }
  }
}
