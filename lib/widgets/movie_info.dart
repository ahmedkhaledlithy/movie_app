import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_movieDetails_bloc.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/model/movie_details.dart';
import 'package:movie_app/model/movie_detalis_response.dart';

class MovieInfo extends StatefulWidget {
  final int id;

  MovieInfo({@required this.id});

  @override
  _MovieInfoState createState() => _MovieInfoState(id);
}

class _MovieInfoState extends State<MovieInfo> {
  final int id;

  _MovieInfoState(this.id);

  @override
  void initState() {
    movieDetailsBloc..getMoviesDetails(id);
    super.initState();
  }

  @override
  void dispose() {
    movieDetailsBloc..drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailsResponse>(
      stream: movieDetailsBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieDetailsResponse> snapshot) {
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
              return _drawMovieInfo(snapshot.data);
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

  Widget _drawMovieInfo(MovieDetailsResponse data) {
    MovieDetails movieDetails = data.movieDetails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "budget".toUpperCase(),
                    style: TextStyle(
                      color: Style.ColorsApp.titleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    movieDetails.budget.toString() + "\$",
                    style: TextStyle(
                      color: Style.ColorsApp.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Duration".toUpperCase(),
                    style: TextStyle(
                      color: Style.ColorsApp.titleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    movieDetails.runtime.toString() + "min",
                    style: TextStyle(
                      color: Style.ColorsApp.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Release date".toUpperCase(),
                    style: TextStyle(
                      color: Style.ColorsApp.titleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    movieDetails.releaseDate,
                    style: TextStyle(
                      color: Style.ColorsApp.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(
          height: 20,
        ),

        Divider(
          height: 1,
          color: Colors.grey.shade900,
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Genres".toUpperCase(),style: TextStyle(
                color: Style.ColorsApp.titleColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),),
              SizedBox(height: 10,),

              Container(
                height: 40,
                padding: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movieDetails.genres.length,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          ),
                        ),
                        child: Text(
                          movieDetails.genres[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
}
