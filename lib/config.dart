import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Food
{
  static const String appName = 'Food';
  static SharedPreferences sharedPreferences;
  static User user;
  static FirebaseAuth auth;
  static FirebaseFirestore firestore ;

  static String collectionUser = "users";
  static String collectionOrders = "orders";

  static String subCollectionAddress = 'userAddress';
  static String FoodCurrentUser="currentUser";

  //clients
  static final String clientName = 'clientName';
  static final String clientEmail = 'clientEmail';
  static final String clientPhotoUrl = 'clientPhotoUrl';
  static final String clientUID = 'clientUID';
  static final String clientPhone = 'clientPhone';
  static final String clientDate = 'clientDate';
  static final String clientAppart = 'clientAppart';
  static final String clientLatitude = 'clientLatitude';
  static final String clientLongitude = 'clientLongitude';
  static final String clientCardExpiry = 'clientCardExpiry';
  static final String clientCardCVV = 'clientCardCVV';
  static String clientCardList = 'clientCard';


  //bars
  static final String restoName = 'restoName';
  static final String restoEmail = 'restoEmail';
  static final String restoPhotoUrl = 'restoPhotoUrl';
  static final String restoUID = 'restoUID';
  static final String restoLongitude ='restoLongitude';
  static final String restoLatitude ='restoLatitude';
  static final String restoPhone = 'restoPhone';
  static final String restoRating = 'restoRating';
  static final String restoRatingCount = 'restoRatingCount';
  static final String restoBalance='restoBalance';
  static String restoCardList = 'restoCardList';
  static final String restoAutorise = 'restoAutorise';
  static final String restoOuvert="restoOuvert";




  static String restoChichas= 'restoChichas';
  static String restoGouts ='restoGouts';
  static String restoSupps ='restoSupps';
  static String restoBoissons ='restoBoissons';
  static String restoAccos ='restoAccos';




  //livreurs
  static final String livreurName = 'livreurName';
  static final String livreurEmail = 'livreurEmail';
  static final String livreurPhotoUrl = 'livreurPhotoUrl';
  static final String livreurUID = 'livreurUID';
  static final String livreurPhone = 'livreurPhone';
  static final String livreurLatitude = 'livreurLatitude';
  static final String livreurLongitude = 'livreurLongitude';
  static final String livreurRating = 'livreurRating';
  static final String livreurRatingCount = 'livreurRatingCount';
  static final String livreurBalance = 'livreurBalance';
  static final String livreurAutorise = 'livreurAutorise';
  static final String livreurCouleur = 'livreurCouleur';
  static final String livreurType = 'livreurType';
  static final String livreurImageUrl = 'livreurImageUrl';
  static String livreurCard = 'livreurCard';


}