import 'package:barberdz/restaurantDash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../RestaurantPlats.dart';
import '../../restaurantCommandes.dart';

enum NavigationEvents{
  DashPageClickedEvent,
  PlatsClickedEvent,
  CommandesClickedEvent
}

abstract class NavigationStates{}

class NavigationBloc extends Bloc<NavigationEvents,NavigationStates>{
  @override
  NavigationStates get initialState =>  RestaurantDash();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch(event){
      case NavigationEvents.DashPageClickedEvent: yield RestaurantDash();
      break;
      case NavigationEvents.PlatsClickedEvent:yield RestaurantPlats();
      break;
      case NavigationEvents.CommandesClickedEvent: yield RestaurantCommandes();
      break;
    }
  }

}