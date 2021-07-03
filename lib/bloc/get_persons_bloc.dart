import 'package:movie_app/model/person_response.dart';
import 'package:movie_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class PersonsListBloc{
  final MovieRepository repository=MovieRepository();
  //rxdart
  final BehaviorSubject<PersonResponse> _subject=BehaviorSubject<PersonResponse>();

  getPersons()async{
    PersonResponse response =await repository.getPersons();
    _subject.sink.add(response);
  }

  dispose(){
    _subject.close();
  }
  BehaviorSubject<PersonResponse> get subject => _subject;

}

final personsBloc=PersonsListBloc();