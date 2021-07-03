import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_movie_byGenre_bloc.dart';
import 'package:movie_app/model/genre.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/widgets/genre_movie.dart';

class GenresList extends StatefulWidget {
  final List<Genre> genres;

  GenresList({@required this.genres});

  @override
  _GenresListState createState() => _GenresListState(genres);
}

class _GenresListState extends State<GenresList>
    with SingleTickerProviderStateMixin {
  final List<Genre> genres;

  _GenresListState(this.genres);

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: genres.length, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if(_tabController.indexIsChanging){
        moviesByGenreBloc.drainStream();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: Style.ColorsApp.mainColor,
          appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Style.ColorsApp.mainColor,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Style.ColorsApp.secondColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                unselectedLabelColor: Style.ColorsApp.titleColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: genres.map((Genre genre) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 15, top: 10),
                    child: Text(genre.name.toUpperCase(),style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),),
                  );
                }).toList(),
              ),
            ),
            preferredSize: Size.fromHeight(50),
          ),
          body: TabBarView(
            controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: genres.map((Genre genre){
                return GenreMovie(genreId: genre.id);
              }).toList(),
          ),
        ),
      ),
    );
  }
}
