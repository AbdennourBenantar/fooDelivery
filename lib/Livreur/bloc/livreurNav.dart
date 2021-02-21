import 'package:barberdz/Livreur/courses.dart';
import 'package:barberdz/Livreur/profil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../accueilLivreur.dart';

enum CoursierNavEvents{
  AccueilClickedEvent,
  CommandesClickedEvent,
  ProfileClickedEvent,
}

abstract class NavStates{}

class CoursierNavBloc extends Bloc<CoursierNavEvents,NavStates>{
  @override
  NavStates get initialState => AccueilCoursier();

  @override
  Stream<NavStates> mapEventToState(CoursierNavEvents event) async*{
    switch(event){
      case CoursierNavEvents.AccueilClickedEvent:yield AccueilCoursier();
      break;
      case CoursierNavEvents.ProfileClickedEvent: yield Profile();
      break;
      case CoursierNavEvents.CommandesClickedEvent:yield Courses();
      break;
    }
  }

}