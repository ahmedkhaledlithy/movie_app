import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_detalis_response.dart';
import 'package:movie_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailsBloc{
  final MovieRepository repository=MovieRepository();
  //rxdart
  final BehaviorSubject<MovieDetailsResponse> _subject=BehaviorSubject<MovieDetailsResponse>();

  getMoviesDetails(int id)async{
    MovieDetailsResponse response =await repository.getMoviesDetails(id);
    _subject.sink.add(response);
  }

  void drainStream(){
    _subject.value=null;
  }
  @mustCallSuper
  void dispose()async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieDetailsResponse> get subject => _subject;

}

final movieDetailsBloc=MovieDetailsBloc();