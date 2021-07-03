import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/bloc/get_now_Playing_bloc.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/movie_response.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:movie_app/style/theme.dart' as Style;

class NowPlayingScreen extends StatefulWidget {
  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  @override
  void initState() {
    super.initState();
    nowPlayingMoviesBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingMoviesBloc.subject.stream,
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
              return _drawNowPlaying(snapshot.data);
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

  Widget _drawNowPlaying(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
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
      return Container(
        height: 220,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          indicatorSpace: 8,
          padding: EdgeInsets.all(5),
          indicatorColor: Style.ColorsApp.titleColor,
          indicatorSelectorColor: Style.ColorsApp.secondColor,
          shape: IndicatorShape.circle(size: 8),
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/original/" +
                                  movies[index].backPoster),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Style.ColorsApp.mainColor.withOpacity(0.1),
                          Style.ColorsApp.mainColor.withOpacity(0.0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0.8, 0.9],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.playCircle,
                          color: Style.ColorsApp.secondColor,
                          size: 45,
                        ),
                        onPressed: (){}),
                  ),
                  Positioned(
                    bottom: 30,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movies[index].title,
                            style: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          length: movies.take(5).length,
        ),
      );
    }
  }
}
