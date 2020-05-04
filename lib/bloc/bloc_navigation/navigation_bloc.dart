import 'package:barberdz/restaurantDash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Restaurantdash 2.dart';
import '../../restaurantdash3.dart';

enum NavigationEvents{
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent
}

abstract class NavigationStates{}

class NavigationBloc extends Bloc<NavigationEvents,NavigationStates>{
  @override
  NavigationStates get initialState =>  RestaurantDash();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch(event){
      case NavigationEvents.HomePageClickedEvent: yield RestaurantDash();
      break;
      case NavigationEvents.MyAccountClickedEvent: yield RestaurantDash2();
      break;
      case NavigationEvents.MyOrdersClickedEvent: yield RestaurantDash3();
      break;
    }
  }

}