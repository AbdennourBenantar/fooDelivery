import 'dart:io';

import 'package:badges/badges.dart';
import 'package:barberdz/Livreur/bloc/livreurNav.dart';
import 'package:barberdz/Restaurant/RestaurantPlats.dart';
import 'package:barberdz/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../config.dart';
class AccueilCoursier extends StatefulWidget with NavStates{
  @override
  _AccueilCoursierState createState() => _AccueilCoursierState();
}

class _AccueilCoursierState extends State<AccueilCoursier> {
  Position current;
  File _imgFile;
  String url;
  int nb;


  void _getCurrentLocation() {
    Geolocator.getCurrentPosition().then((Position position){
      setState(() async {
        current=position;
        FirebaseFirestore.instance.collection("livreurs").doc(Food.sharedPreferences.getString(Food.livreurUID)).update({
          Food.livreurLatitude:current.latitude,
          Food.livreurLongitude:current.longitude,
        });
        await Food.sharedPreferences.setString(Food.livreurLatitude, current.latitude.toString());
        await Food.sharedPreferences.setString(Food.livreurLongitude,current.longitude.toString());
      });
    }).catchError((e){
      print(e);
    });
  }
  Future chooseImage() async {
    final pickedFile= await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imgFile=File(pickedFile.path);
    });
  }
  Future uploadImagetoFirestore(BuildContext context) async {
    String fileName=_imgFile.path;
    Reference firebaseStorageRef=FirebaseStorage.instance.ref().child(fileName);
    TaskSnapshot taskSnapshot=await firebaseStorageRef.putFile(_imgFile).whenComplete(() => null);
    do{
      print(taskSnapshot.bytesTransferred);
    }while(taskSnapshot.bytesTransferred<taskSnapshot.totalBytes);
    var img=await taskSnapshot.ref.getDownloadURL();
    setState(() {
      url=img;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if((Food.sharedPreferences.getString(Food.livreurLatitude)=='0') &&(Food.sharedPreferences.getString(Food.livreurLongitude)=='0'))
    {
      _getCurrentLocation();
      print("///////////////////////////////////////////////////");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Background(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.4,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.1,),
                Padding(
                  padding: EdgeInsets.only(left: 48,right: 48),
                  child: Material(
                    animationDuration: Duration(milliseconds: 500),
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bonjour ! ',style: GoogleFonts.abel(fontSize: 26,fontWeight: FontWeight.bold,color: Colors.white),),
                          Text('Voici vos informations,',style: GoogleFonts.abel(fontSize: 16,color: Colors.white),),
                          Text('Les clients utiliseront ces informations pour vous reconnaitre',style: GoogleFonts.abel(fontSize: 16,color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.05,),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Material(
                    color: Colors.black,
                    animationDuration: Duration(milliseconds: 500),
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child:Column(
                      children: [
                        Table(
                          children: [
                            TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.person,size: 18,color: Colors.orange.shade400,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text("Nom",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold,color: Colors.white),)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(Food.sharedPreferences.getString(Food.livreurName),style: GoogleFonts.abel(fontSize:14,color: Colors.white),)),
                                  ),
                                ]
                            ),
                            TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.phone,size: 18,color: Colors.orange.shade400,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text("Telephone",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold,color: Colors.white),)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(Food.sharedPreferences.getString(Food.livreurPhone),style: GoogleFonts.abel(fontSize:14,color: Colors.white),)),
                                  ),
                                ]
                            ),
                            TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.motorcycle,size: 18,color:Colors.orange.shade400,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text("Type",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold,color: Colors.white),)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(Food.sharedPreferences.getString(Food.livreurType)==''?'-':Food.sharedPreferences.getString(Food.livreurType),style: GoogleFonts.abel(fontSize:14,color: Colors.white),)),
                                  ),
                                ]
                            ),
                            TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.color_lens,size: 18,color: Colors.orange.shade400,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text('Couleur',style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold,color: Colors.white),)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(Food.sharedPreferences.getString(Food.livreurCouleur)==''?'-':Food.sharedPreferences.getString(Food.livreurCouleur),style: GoogleFonts.abel(fontSize:14,color: Colors.white),)),
                                  ),
                                ]
                            ),

                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:18.0),
                          child: FlatButton(
                              color: Colors.orange.withOpacity(1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              onPressed: (){
                                BlocProvider.of<CoursierNavBloc>(context).add(CoursierNavEvents.ProfileClickedEvent);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.update,color: Colors.white,),
                                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                  Center(child: Text('Mettre à jour mes informations',style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),)),
                                ],
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.03,),
                Column(
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection("livreurs").doc(Food.sharedPreferences.getString(Food.livreurUID)).snapshots(),
                        builder: (context, snapshot) {
                          return !snapshot.hasData? Center(child: Text("Chargement ..."),)
                              :
                          snapshot.data.data()[Food.livreurImageUrl]==''?
                          Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: Center(child: Text("Aucune image à afficher, Veuillez importer une image de votre vehicule"),),
                          ):Image.network(snapshot.data.data()[Food.livreurImageUrl],height: MediaQuery.of(context).size.height*0.2,);
                        }
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: FlatButton(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          onPressed: (){
                            chooseImage().whenComplete(() => null).then((value) => uploadImagetoFirestore(context)).whenComplete(() => null).then((value) {
                              if(url!="")
                              {
                                FirebaseFirestore.instance.collection("livreurs").doc(Food.sharedPreferences.getString(Food.livreurUID)).update({
                                  Food.livreurImageUrl:url
                                }).whenComplete(() {
                                  setState(() {
                                    url="";
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Image importé avec succés")));
                                  });
                                });
                              }
                              else{
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Veuillez importer une image sans arriere plan de votre véhicule")));
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.file_upload,color: Colors.white,),
                              SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                              Center(child: Text('Importer une image de votre véhicule',style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),)),
                            ],
                          )
                      ),
                    ),
                  ],
                ),

              ],
            ),
            Positioned(
              bottom: 0,
              left: 7,
              right: 5,
              child:
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("courses").snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData?Center(child: Text(""),): Badge(
                      badgeContent: null,
                      position: BadgePosition.bottomEnd(bottom:30,end:5),
                      child: FlatButton(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          onPressed: (){
                            BlocProvider.of<CoursierNavBloc>(context).add(CoursierNavEvents.CommandesClickedEvent);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.motorcycle,color: Colors.white,),
                              SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                              Center(child: Text('Commencer des courses',style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),)),
                            ],
                          )
                      ),
                    );
                  }
              ),
            )

          ],
        ),
      ),
    );
  }
}
