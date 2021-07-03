import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/widgets/genres.dart';
import 'package:movie_app/widgets/now_playing.dart';
import 'package:movie_app/widgets/persons.dart';
import 'package:movie_app/widgets/top_movies.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.ColorsApp.mainColor,
      appBar: AppBar(
        backgroundColor: Style.ColorsApp.mainColor,
        leading: IconButton(
            icon: Icon(
              EvaIcons.menu2Outline,
              color: Colors.white,
            ),
            onPressed: () {}),
        title: Text("Movie App"),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          NowPlayingScreen(),
          GeneresScreen(),
          PersonsList(),
          TopMovies(),
        ],
      ),
    );
  }
}
