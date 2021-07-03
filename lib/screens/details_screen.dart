import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/bloc/get_movie_videos_bloc.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/video.dart';
import 'package:movie_app/model/video_response.dart';
import 'package:movie_app/screens/video_player.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/widgets/casts.dart';
import 'package:movie_app/widgets/movie_info.dart';
import 'package:movie_app/widgets/similar_movie.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailsScreen({@required this.movie});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState(movie);
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final Movie movie;

  _MovieDetailsScreenState(this.movie);

  @override
  void initState() {
    super.initState();
    movieVideosBloc.getMoviesVideos(movie.id);
  }

  @override
  void dispose() {
    movieVideosBloc..drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.ColorsApp.mainColor,
      body: Builder(
        builder: (context) {
          return SliverFab(
            floatingPosition: FloatingPosition(
              right: 20,
            ),
            floatingWidget: StreamBuilder<VideoResponse>(
              stream: movieVideosBloc.subject.stream,
              builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
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
                      return _drawVideo(snapshot.data);
                    }
                    break;
                }
                return null;
              },
            ),
            expandedHeight: 200,
            slivers: [
              SliverAppBar(
                backgroundColor: Style.ColorsApp.mainColor,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    movie.title.length > 40
                        ? movie.title.substring(0, 37) + "...."
                        : movie.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/" +
                                      movie.backPoster),
                              fit: BoxFit.cover),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.0),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(0.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              movie.rating.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            RatingBar(
                              itemSize: 26,
                              initialRating: movie.rating / 2,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemBuilder: (context, _) {
                                return IconButton(
                                    icon: Icon(
                                      EvaIcons.star,
                                      color: Style.ColorsApp.secondColor,
                                    ),
                                    onPressed: () {});
                              },
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        child: Text(
                          "OverView".toUpperCase(),
                          style: TextStyle(
                            color: Style.ColorsApp.titleColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          movie.overview,
                          style: TextStyle(
                            color: Colors.white,
                            height: 1.4,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MovieInfo(
                        id: movie.id,
                      ),
                      Casts(
                        id: movie.id,
                      ),
                      SimilarMovies(
                        id: movie.id,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
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

  Widget _drawVideo(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
      backgroundColor: Style.ColorsApp.secondColor,
      child: Icon(Icons.play_arrow),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              controller: YoutubePlayerController(
                initialVideoId: videos[0].key,
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
