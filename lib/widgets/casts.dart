import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_casts_bloc.dart';
import 'package:movie_app/model/cast.dart';
import 'package:movie_app/model/cast_response.dart';
import 'package:movie_app/style/theme.dart' as Style;

class Casts extends StatefulWidget {
  final int id;

  Casts({@required this.id});

  @override
  _CastsState createState() => _CastsState(id);
}

class _CastsState extends State<Casts> {
  final int id;

  _CastsState(this.id);

  @override
  void initState() {
    super.initState();
    castsBloc..getCasts(id);
  }

  @override
  void dispose() {
    castsBloc..drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          height: 10,
        ),
        Divider(
          height: 1,
          color: Colors.grey.shade900,
        ),

        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            "Casts".toUpperCase(),
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
        StreamBuilder<CastResponse>(
          stream: castsBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastResponse> snapshot) {
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
                  return _drawMovieCasts(snapshot.data);
                }
                break;
            }
            return null;
          },
        ),
      ],
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

  Widget _drawMovieCasts(CastResponse data) {
   final List<Cast> casts = data.casts;
    return Container(
      height: 150,
      padding: EdgeInsets.only(left: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: casts.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Style.ColorsApp.secondColor,
                    radius: 35,
                    backgroundImage: NetworkImage(
                        "https://image.tmdb.org/t/p/w500/${casts[index].image.toString()}"
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    casts[index].name,
                    style: TextStyle(
                      height: 1.3,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Flexible(
                    child: Text(
                      casts[index].character,
                      style: TextStyle(
                        height: 1.3,
                        color: Style.ColorsApp.titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
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
