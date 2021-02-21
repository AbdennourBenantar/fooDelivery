import 'dart:io';
import 'dart:math';

import 'package:barberdz/Restaurant/option.dart';
import 'package:barberdz/config.dart';
import 'package:barberdz/dishes.dart';
import 'package:barberdz/Restaurant/plat_card_shape.dart';
import 'package:barberdz/Restaurant/plat_details.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sweetalert/sweetalert.dart';
import '../bloc/bloc_navigation/navigation_bloc.dart';


class RestaurantPlats extends StatefulWidget with NavigationStates {
  @override
  _RestaurantPlatsState createState() => _RestaurantPlatsState();
}

class _RestaurantPlatsState extends State<RestaurantPlats> {
  int selectedOption=0;
  final _formKey2 = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  String url;
  File _imgFile;
  TextEditingController tedc=TextEditingController();
  TextEditingController tedc4=TextEditingController();
  TextEditingController tedc3=TextEditingController();
  TextEditingController tedc2=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
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
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(
            width: width*0.52,
            height: height*0.8,
            color: Colors.orange.withOpacity(0.8),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('restos').doc(Food.sharedPreferences.getString(Food.restoUID)).collection('categories').snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData?Text("Chargement"):
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Titlee(text: 'Nos Plats',),
                    ],
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height*0.01
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50,right: 1,top: 5),
                    child: Text(
                      "Veuillez suspendre les plats dont vous ne disposez pas actuellement",
                      style: GoogleFonts.abel(color: Colors.black,
                          fontSize: 12,fontWeight: FontWeight.normal
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.add),
                              Text(
                                "Ajouter un plat à ce menu",
                                style: GoogleFonts.abel(color: Colors.black,
                                    fontSize: 12,fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          onTap: (){
                            Alert(
                                context: context,
                                title: 'Ajouter un nouveau plat au menu '+snapshot.data.docs[selectedOption].data()['id'],
                                content: Form(
                                  key: _formKey2,
                                  child: Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical:8.0),
                                        child: Text('Nom du plat',style: GoogleFonts.abel(color: Colors.black,fontSize: 12),),
                                      ),
                                      TextFormField(
                                          controller: tedc,
                                          decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderSide: BorderSide(),
                                            ),
                                            fillColor: Colors.blue.shade100,
                                          ),
                                          keyboardType: TextInputType.text,
                                          validator: (value){
                                            if(value.isEmpty)
                                              return 'Veuillez Entrer le nom de votre plat';
                                            setState(() {
                                            });
                                            return null;
                                          }
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical:8.0),
                                        child: Text('Desciption ',style: GoogleFonts.abel(color: Colors.black,fontSize: 12),),
                                      ),
                                      TextFormField(
                                          controller: tedc4,
                                          decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderSide: BorderSide(),
                                            ),
                                            fillColor: Colors.blue.shade100,
                                          ),
                                          keyboardType: TextInputType.text,
                                          validator: (value){
                                            if(value.isEmpty)
                                              return 'Veuillez Entrer une description de votre plat';
                                            setState(() {
                                            });
                                            return null;
                                          }
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical:8.0),
                                        child: Text('Prix',style: GoogleFonts.abel(color: Colors.black,fontSize: 12),),
                                      ),
                                      TextFormField(
                                          controller: tedc3,
                                          decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderSide: BorderSide(),
                                            ),
                                            fillColor: Colors.blue.shade100,
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value){
                                            if(value.isEmpty)
                                              return 'Veuillez Entrer le prix de votre plat';
                                            setState(() {
                                            });
                                            return null;
                                          }
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical:8.0),
                                        child: Text('Photo du plat',style: GoogleFonts.abel(color: Colors.black,fontSize: 12),),
                                      ),
                                      FlatButton(
                                          color: Colors.green.shade400,
                                          shape:RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          onPressed: chooseImage,
                                          child: Text("Importer une image")
                                      )

                                    ],
                                  ),
                                ),
                                buttons: [
                                  DialogButton(
                                    color: Colors.blueAccent.shade100,
                                    onPressed: (){
                                      _formKey2.currentState.validate();
                                      uploadImagetoFirestore(context).whenComplete(() {
                                        if(url!="")
                                        {

                                          FirebaseFirestore.instance.collection("restos/"+Food.sharedPreferences.getString(Food.restoUID)+"/categories/"+snapshot.data.docs[selectedOption].reference.id+"/elements").doc().set({
                                            "nom":tedc.text,
                                            "description":tedc4.text,
                                            "prix":(int.parse(tedc3.text)*1.2).toStringAsFixed(2),
                                            "etat":'1',
                                            "img":url
                                          }).then((value) {
                                          }).whenComplete(() {
                                            tedc.clear();
                                            tedc4.clear();
                                            tedc3.clear();
                                            setState(() {
                                              url="";
                                              Navigator.of(context).pop();
                                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Plat ajouté avec succés")));
                                            });
                                          });
                                        }
                                        else{
                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Veuillez importer une image sans arriere plan pour votre plat")));
                                        }
                                      });


                                    },
                                    child: Text('Ajouter un plat',style: GoogleFonts.abel(color: Colors.black),),
                                  )
                                ]
                            ).show();

                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.42,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('restos').doc(Food.sharedPreferences.getString(Food.restoUID)).collection('categories').doc(snapshot.data.docs[selectedOption].reference.id).collection('elements').snapshots(),
                      builder: (context, dsnapshot) {
                        return !dsnapshot.hasData?Text('Chargement'):
                            PageView.builder(
                            itemCount: dsnapshot.data.docs.length,
                            controller: PageController(viewportFraction: 0.72),
                            itemBuilder: (context, i) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: InkWell(
                                  onTap: () {
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Hero(
                                        tag: "background-$i",
                                        child: Material(
                                          elevation: 10,
                                          shape: PlatCardShape(
                                              MediaQuery.of(context).size.width* 0.65,
                                              MediaQuery.of(context).size.height * 0.38),
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            32, 32, 32, 60),
                                        child: Align(
                                          child: Image.network(
                                            dsnapshot.data.docs[i].data()['img'], height: 140,
                                            width: 140,),
                                          alignment: Alignment(0, 0),),
                                      ),
                                      Positioned(
                                        bottom: 40,
                                        left: 32,
                                        right: 32,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Center(
                                              child: InkWell(
                                                onTap: () {
                                                  if(dsnapshot.data.docs[i].data()['etat']=='1')
                                                    {
                                                      FirebaseFirestore.instance.collection('restos').doc(Food.sharedPreferences.getString(Food.restoUID)).collection('categories').doc(snapshot.data.docs[selectedOption].reference.id).collection('elements').doc(dsnapshot.data.docs[i].reference.id).update({
                                                        'etat':'0'
                                                      });
                                                    }
                                                  else{
                                                    if(dsnapshot.data.docs[i].data()['etat']=='0')
                                                      {
                                                        FirebaseFirestore.instance.collection('restos').doc(Food.sharedPreferences.getString(Food.restoUID)).collection('categories').doc(snapshot.data.docs[selectedOption].reference.id).collection('elements').doc(dsnapshot.data.docs[i].reference.id).update({
                                                          'etat':'1'
                                                        });
                                                      }
                                                  }
                                                },
                                                child: Text(dsnapshot.data.docs[i].data()['etat']=='1'?'Suspendre':'Activer',
                                                  style: GoogleFonts.abel(
                                                      color: dsnapshot.data.docs[i].data()['etat']=='1'?Colors.red:Colors.green,fontSize: 18),),
                                              ),
                                            ),
                                            Text(dsnapshot.data.docs[i].data()['nom'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800
                                              ),),
                                            Text(dsnapshot.data.docs[i].data()['description'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300
                                              ),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            32, 32, 32, 60),
                                        child: Align(
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            iconSize: 25,
                                            color: Colors.black.withOpacity(0.8),
                                            onPressed: () {
                                              Alert(
                                                  context: context,
                                                  title: 'Confirm removal',
                                                  content: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        "Are you sure deleting this dish ? your clients won't be able to order it again",
                                                        style: GoogleFonts.changa(
                                                            fontSize: 12,
                                                            color: Colors.black),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                  buttons: [
                                                    DialogButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          Navigator.pop(context);
                                                        });
                                                      },
                                                      child: Center(
                                                        child: Text("Confirm",
                                                          style: GoogleFonts.changa(
                                                              fontSize: 22,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              color: Colors.white),
                                                        ),
                                                      ),
                                                      color: Colors.black,
                                                    )
                                                  ]
                                              ).show();
                                            },
                                          ),
                                          alignment: Alignment(1.3, -1.2),),
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:18.0),
                    child: Center(
                      child: Text("Menu "+snapshot.data.docs[selectedOption].data()['id'],style: GoogleFonts.abel(fontWeight: FontWeight.bold,fontSize: 26),),
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int index=0;index<snapshot.data.docs.length;index++)
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Material(
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        width: index==selectedOption?MediaQuery.of(context).size.width*0.16:MediaQuery.of(context).size.width*0.15,
                                        height: index==selectedOption?MediaQuery.of(context).size.height*0.08:MediaQuery.of(context).size.height*0.07,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: index==selectedOption?Colors.black:Colors.white,
                                        ),
                                        child: Image.network(snapshot.data.docs[index].data()['img'],color:index==selectedOption?Colors.white:Colors.black,)
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  setState(() {
                                    selectedOption=index;
                                  });
                                },
                              ),
                        ],
                      ),
                    ),
                  ),


                ],
              );
            }
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height*0.06,
                child: FlatButton(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    onPressed: (){
                      int isSelected=1;
                      int i;
                      Alert(
                          context: context,
                          title: 'Ajouter une nouvelle catégorie de plats',
                          content: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical:8.0),
                                  child: Text('Catégorie :',style: GoogleFonts.abel(color: Colors.black,fontSize: 12),),
                                ),
                                TextFormField(
                                    controller: tedc2,
                                    decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                      fillColor: Colors.blue.shade100,
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value){
                                      if(value.isEmpty)
                                        return 'Veuillez entrer une catégorie \nex. Asiatique';
                                      setState(() {
                                      });
                                      return null;
                                    }
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical:8.0),
                                  child: Text('Choisir une image répresentative de cette catégorie :',style: GoogleFonts.abel(color: Colors.black,fontSize: 12),),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int index=0;index<3;index++)
                                      InkWell(
                                        child: _OptionWidget(option: options[isSelected-1],isSelected:options[index].id==isSelected,pathNum: index,),
                                        onTap: (){
                                          i=index;
                                          setState(() {
                                            SweetAlert.show(context,title: "Image sauvegardée avec succés !",confirmButtonColor:Colors.green.shade400,subtitle: "Cliquez sur ajouter pour terminer",style: SweetAlertStyle.success,
                                                onPress: (bool isConfirm){
                                                  if(isConfirm) {
                                                  }
                                                  return true;
                                                });
                                          });
                                        },
                                      ),
                                  ],
                                )
                                
                              ],
                            ),
                          ),
                          buttons: [
                            DialogButton(
                              color: Colors.black,
                              onPressed: (){
                                if(i!=null)
                                  {
                                    _formKey.currentState.validate();
                                    FirebaseFirestore.instance.collection("restos/"+Food.sharedPreferences.getString(Food.restoUID)+"/categories").doc().set({
                                      "id":tedc2.text,
                                      "img":i==0?"https://firebasestorage.googleapis.com/v0/b/foodelivery-c6b47.appspot.com/o/pizza.png?alt=media&token=fe0a7a6a-2098-429e-b9f5-6533c5ed1259":i==1?
                                            "https://firebasestorage.googleapis.com/v0/b/foodelivery-c6b47.appspot.com/o/sandwich.png?alt=media&token=99ba73c4-5ada-422e-ba72-320c01568c2f"
                                            :"https://firebasestorage.googleapis.com/v0/b/foodelivery-c6b47.appspot.com/o/plat.png?alt=media&token=62f46185-2cac-44a6-852b-7ff2575f305b"
                                    }).then((value) {
                                    }).whenComplete(() {
                                      setState(() {
                                        tedc2.clear();
                                        Navigator.of(context).pop();
                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Catégorie de plats ajoutée avec succés")));
                                      });
                                    });
                                  }else{
                                  SweetAlert.show(context,title: "Choisissez une image !",confirmButtonColor:Colors.red,subtitle: "Cliquez sur une des images proposées ci-dessus",style: SweetAlertStyle.error,
                                      onPress: (bool isConfirm){
                                        if(isConfirm) {
                                        }
                                        return true;
                                      });
                                }
                              },
                              child: Text('Ajouter',style: GoogleFonts.abel(color: Colors.white,fontWeight: FontWeight.bold),),
                            )
                          ]
                      ).show();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.add_circle,color: Colors.white,),
                        Text("Ajouter une nouvelle catégorie de plats",style: GoogleFonts.abel(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),),
                      ],
                    )),
              )
          )

        ],
      ),
    );
  }
}

class _OptionWidget extends StatelessWidget{

  final Option option;
  final bool isSelected;
  final int pathNum;
  const _OptionWidget({Key key,@required this.option,this.isSelected=false,this.pathNum}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var path;
    if(pathNum==0)
    {
      path=options[0].imagePath;
    }else {
      if(pathNum==1){
        path=options[1].imagePath;
      }else{
        path=options[2].imagePath;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
            padding: const EdgeInsets.all(8),
            width: isSelected?MediaQuery.of(context).size.width*0.16:MediaQuery.of(context).size.width*0.15,
            height: isSelected?MediaQuery.of(context).size.height*0.08:MediaQuery.of(context).size.height*0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Image.asset(path,color:Colors.black,)
        ),
      ),
    );
  }
}
class Titlee extends StatelessWidget {
  final String text;

  const Titlee({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final words=text.split(' ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: words[0],
              style: TextStyle(
                height: 0.9,
                fontWeight: FontWeight.w900,
                fontSize: 36,
                letterSpacing: 2,
                color: Colors.black
              )
            ),
            TextSpan(
              text: '\n'
            ),
            TextSpan(
                text: words[1],
                style: TextStyle(
                  height: 0.9,
                    fontWeight: FontWeight.w900,
                    fontSize: 36,
                    letterSpacing: 6,
                    fontFamily: 'Londrina_Outline',
                    color: Colors.black
                )
            )
          ]
        ),
      ),
    );
  }
}


class Background extends StatelessWidget {
  final double width,height;
  final Color color;

  const Background({Key key, this.width, this.height,this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Positioned(
     right: 0,
     width: width,
     top: 0,
     height: height,
     child: ClipRRect(
       child: Container(color: color,),
       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: width==MediaQuery.of(context).size.width?Radius.circular(40):Radius.circular(0)),
     ),
   );
  }
}
