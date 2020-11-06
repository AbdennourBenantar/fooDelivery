import 'package:barberdz/Client/accueil.dart';
import 'package:barberdz/Client/historique.dart';
import 'package:barberdz/Client/mesCommandes.dart';
import 'package:barberdz/Restaurant/restaurantDash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Restaurant/RestaurantPlats.dart';
import '../../Restaurant/parametre.dart';
import '../../Restaurant/restaurantCommandes.dart';

enum NavigationEvents{
  DashPageClickedEvent,
  PlatsClickedEvent,
  CommandesClickedEvent,
  ParametresClickedEvent,
}
enum ClientNavigationEvents{
  ParametresClickedEvent,
  AccueilClickedEvent,
  MesCommandesClickedEvent,
  HistoriqueClickedEvent,
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
      case NavigationEvents.PlatsClickedEvent: yield RestaurantPlats();
      break;
      case NavigationEvents.CommandesClickedEvent: yield RestaurantCommandes();
      break;
      case NavigationEvents.ParametresClickedEvent: yield Parametres();
      break;
    }
  }

}

class ClientNavBloc extends Bloc<ClientNavigationEvents,NavigationStates>{
  NavigationStates get initialState => Accueil();

  @override
  Stream<NavigationStates> mapEventToState(ClientNavigationEvents event) async*{
    switch(event){
      case ClientNavigationEvents.AccueilClickedEvent: yield Accueil();
      break;
      case ClientNavigationEvents.MesCommandesClickedEvent: yield Cart();
      break;
      case ClientNavigationEvents.HistoriqueClickedEvent: yield Historique();
      break;
      case ClientNavigationEvents.ParametresClickedEvent: yield Parametres();
      break;
    }
  }
}