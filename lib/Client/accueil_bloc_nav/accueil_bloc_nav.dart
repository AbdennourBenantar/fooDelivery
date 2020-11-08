import 'package:flutter_bloc/flutter_bloc.dart';

import '../assietteList.dart';
import '../pizzasList.dart';
import '../recentList.dart';
import '../sandList.dart';

enum AccueilNavEvents{
  RecentClickedEvent,
  PizzaClickedEvent,
  SandsClickedEvent,
  AssiClickedEvent
}

abstract class NavStates{}

class AccueilNavBloc extends Bloc<AccueilNavEvents,NavStates>{
  NavStates get initialState=> RecentList();

  @override
  Stream<NavStates> mapEventToState(AccueilNavEvents event) async*{
    switch(event){
      case AccueilNavEvents.RecentClickedEvent : yield RecentList();
      break;
      case AccueilNavEvents.AssiClickedEvent: yield AssietteList();
      break;
      case AccueilNavEvents.PizzaClickedEvent: yield PizzaList();
      break;
      case AccueilNavEvents.SandsClickedEvent: yield SandList();
      break;
    }
  }
}