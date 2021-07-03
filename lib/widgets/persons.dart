import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/bloc/get_persons_bloc.dart';
import 'package:movie_app/model/person.dart';
import 'package:movie_app/model/person_response.dart';
import 'package:movie_app/style/theme.dart' as Style;

class PersonsList extends StatefulWidget {
  @override
  _PersonsListState createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  @override
  void initState() {
    super.initState();
    personsBloc..getPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            "trending persons on this week".toUpperCase(),
            style: TextStyle(
              color: Style.ColorsApp.titleColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(
          height: 6,
        ),
        StreamBuilder<PersonResponse>(
          stream: personsBloc.subject.stream,
          builder: (context, AsyncSnapshot<PersonResponse> snapshot) {
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
                  return _drawPersons(snapshot.data);
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

  Widget _drawPersons(PersonResponse data) {
    List<Person> persons = data.persons;
    return Container(
      height: 150,
      padding: EdgeInsets.only(left: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: persons.length,
        itemBuilder: (context, index) {
          return Container(
            // width: 100,
            padding: EdgeInsets.only(top: 10, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                persons[index].profileImage == null
                    ? CircleAvatar(
                        radius: 40,
                        backgroundColor: Style.ColorsApp.secondColor,
                        child: Icon(
                          FontAwesomeIcons.userAlt,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            "https://image.tmdb.org/t/p/w200/" +
                                persons[index].profileImage),
                      ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  persons[index].name,
                  maxLines: 2,
                  style: TextStyle(
                    height: 1.4,
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 5,
                ),
                Text(
                  "Trending for ${persons[index].known}",
                  style: TextStyle(
                    color: Style.ColorsApp.titleColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
