

import 'package:barberdz/Client/clientLayout.dart';
import 'package:barberdz/Livreur/livreurlayout.dart';
import 'package:barberdz/Restaurant/resto_layout.dart';
import 'package:barberdz/clientInscription.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'config.dart';


class Login extends StatefulWidget {
  final int option;

  const Login({Key key, this.option}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}
String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
bool obscureText=true;
class _LoginState extends State<Login> {
  final _scaffoldKey2=new GlobalKey<ScaffoldState>();

  bool proceed;
  final Map<String,dynamic> signInData={'email':null,'password':null};

  final _formKey=new GlobalKey<FormState>();

  final focusPassword=new FocusNode();
  ProgressDialog pg;

  Future<void> validate() async {
    pg=new ProgressDialog(context);
    pg.style(
      message: 'Connexion en cours ...',
    );
    final FormState _form=_formKey.currentState;
    if(!_form.validate()){
      _form.save();
      try{
        pg.show();
        UserCredential result=await FirebaseAuth.instance.signInWithEmailAndPassword(email: signInData['email'], password: signInData['password']);
        print(result.user.uid);
        Food.user=result.user;
      }on PlatformException catch(e){
        print(e.message.toString());
        await pg.hide();
        _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text(e.message.toString())));

      }catch(e){
        await pg.hide();
        _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text(e.message.toString())));

      }
    }else{
      print("Echec");
    }
    if(Food.user!=null){
      readData(Food.user);
    }
  }
  Future readData(User user) async{
    await pg.hide();
    switch(widget.option) {
      case 0:
        {
          FirebaseFirestore.instance.collection("clients").doc(user.uid).get().whenComplete((){}).then((dataSnap) async {
            if(dataSnap.data()!=null)
            {
              proceed=true;
              await Food.sharedPreferences.setString(Food.clientUID, dataSnap.data()[Food.clientUID]);
              await Food.sharedPreferences.setString(Food.clientEmail, dataSnap.data()[Food.clientEmail]);
              await Food.sharedPreferences.setString(Food.clientName, dataSnap.data()[Food.clientName]);
              await Food.sharedPreferences.setString(Food.clientPhone, dataSnap.data()[Food.clientPhone]);
              await Food.sharedPreferences.setString(Food.clientDate, dataSnap.data()[Food.clientDate]);
              await Food.sharedPreferences.setString(Food.clientLatitude, dataSnap.data()[Food.clientLatitude].toString());
              await Food.sharedPreferences.setString(Food.clientLongitude, dataSnap.data()[Food.clientLongitude].toString());
              await Food.sharedPreferences.setString(Food.clientAppart, dataSnap.data()[Food.clientAppart]);
              await Food.sharedPreferences.setString(Food.FoodCurrentUser, "0");

            }else{
              setState(() {
                proceed=false;
              });
            }
          }).whenComplete(() {
          }
          ).then((value) {
            if(proceed){

              Navigator.push(context, new MaterialPageRoute(builder: (context) => widget.option == 0 ? ClientLayout() : widget.option == 1 ? RestoLayout() : CoursierLayout()));
            }else{
              _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text("Vous essayer de se connecter en tant que Restaurant alors vous ne l'etes pas !"),duration: Duration(milliseconds: 3000),));
            }
          });
          break;
        }
      case 1:
        {
          FirebaseFirestore.instance.collection("restos").doc(user.uid).get().whenComplete((){}).then((dataSnap) async {
            if(dataSnap.data()!=null)
            {
              proceed=true;
              await Food.sharedPreferences.setString(Food.restoUID, dataSnap.data()[Food.restoUID]);
              await Food.sharedPreferences.setString(Food.restoEmail, dataSnap.data()[Food.restoEmail]);
              await Food.sharedPreferences.setString(Food.restoName, dataSnap.data()[Food.restoName]);
              await Food.sharedPreferences.setString(Food.restoPhone, dataSnap.data()[Food.restoPhone]);
              await Food.sharedPreferences.setString(Food.FoodCurrentUser, "1");
              await Food.sharedPreferences.setString(Food.restoLongitude, dataSnap.data()[Food.restoLongitude].toString());
              await Food.sharedPreferences.setString(Food.restoLatitude, dataSnap.data()[Food.restoLatitude].toString());
              await Food.sharedPreferences.setString(Food.restoRating, dataSnap.data()[Food.restoRating].toString());
              await Food.sharedPreferences.setString(Food.restoBalance, dataSnap.data()[Food.restoBalance].toString());
              await Food.sharedPreferences.setString(Food.restoOuvert, dataSnap.data()[Food.restoOuvert].toString());
              if(dataSnap.data()[Food.restoAutorise]=='0')
              {
                setState(() async {
                  proceed=false;
                  await Food.auth.signOut();
                  _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text("Vous n'etes pas autorisé à acceder à notre platforme pour le moment, vous y serez autorisé dés qu'on finisse le traitement de votre demande")));
                });

              }
            }
            else{
              setState(() {
                proceed=false;
              });
              await Food.auth.signOut();
            }
          }).whenComplete(() {
          }
          ).then((value) {
            if(proceed){
              // Navigator.pop(context);
              Navigator.push(context, new MaterialPageRoute(builder: (context) => widget.option == 0 ? ClientLayout() : widget.option == 1 ? RestoLayout() : CoursierLayout()));
            }else{
              _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text("Vous essayer de se connecter en tant que bar de shisha alors vous ne l'etes pas !"),duration: Duration(milliseconds: 3000),));
            }
          });
          break;
        }
      case 2:
        {
          FirebaseFirestore.instance.collection("livreurs").doc(user.uid).get().whenComplete((){}).then((dataSnap) async {
            if(dataSnap.data()!=null){
              proceed=true;
              await Food.sharedPreferences.setString(Food.livreurUID, dataSnap.data()[Food.livreurUID]);
              await Food.sharedPreferences.setString(Food.livreurEmail, dataSnap.data()[Food.livreurEmail]);
              await Food.sharedPreferences.setString(Food.livreurName, dataSnap.data()[Food.livreurName]);
              await Food.sharedPreferences.setString(Food.FoodCurrentUser, "2");
              await Food.sharedPreferences.setString(Food.livreurPhone, dataSnap.data()[Food.livreurPhone]);
              await Food.sharedPreferences.setString(Food.livreurLongitude, dataSnap.data()[Food.livreurLongitude].toString());
              await Food.sharedPreferences.setString(Food.livreurLatitude, dataSnap.data()[Food.livreurLatitude].toString());
              await Food.sharedPreferences.setString(Food.livreurRating, dataSnap.data()[Food.livreurRating].toString());
              await Food.sharedPreferences.setString(Food.livreurBalance, dataSnap.data()[Food.livreurBalance].toString());
              await Food.sharedPreferences.setString(Food.livreurType, dataSnap.data()[Food.livreurType].toString());
              await Food.sharedPreferences.setString(Food.livreurCouleur, dataSnap.data()[Food.livreurCouleur].toString());
              await Food.sharedPreferences.setString(Food.livreurImageUrl, dataSnap.data()[Food.livreurImageUrl].toString());
              if(dataSnap.data()[Food.livreurAutorise]=='0')
              {
                setState(() async {
                  proceed=false;
                  await Food.auth.signOut();
                  _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text("Vous n'etes pas autorisé à acceder à notre platforme pour le moment, vous y serez autorisé dés qu'on finisse le traitement de votre demande")));
                });

              }
            }else{
              setState(() {
                proceed=false;
              });
              await Food.auth.signOut();
            }
          }).whenComplete(() {
          }
          ).then((value) {
            if(proceed){
              // Navigator.pop(context);
              Navigator.push(context, new MaterialPageRoute(builder: (context) => widget.option == 0 ? ClientLayout() : widget.option == 1 ? RestoLayout() : CoursierLayout()));
            }else{
              _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text("Vous essayer de se connecter en tant que livreur alors vous ne l'etes pas !"),duration: Duration(milliseconds: 3000),));
            }
          });
          break;
        }

    }


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey2,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          WavyImageRestaurantPage(),
          Padding(
            padding: const EdgeInsets.only(top:230),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text("Connexion",style: GoogleFonts.changa(fontSize: 55,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.05,
                  ),
                  Form(
                    key: _formKey,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: new
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusPassword);
                                    },
                                    onSaved: (String value){
                                      signInData['email']=value;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black)
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      hintStyle: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                      hintText: 'Email',
                                      prefixIcon: Icon(Icons.mail,color: Colors.black,),
                                    ),
                                    validator: (String value){
                                      if (value.isEmpty){
                                        return "Champs Obligatoire";
                                      }
                                      else if(!regExp.hasMatch(value)){
                                        return "Adresse email invalide";
                                      }
                                      return "";
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: new TextFormField(obscureText: obscureText,
                                    focusNode: focusPassword,
                                    style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                    onFieldSubmitted: (v){
                                      if(_formKey.currentState.validate())
                                      {
                                        _formKey.currentState.save();
                                      }
                                    },
                                    onSaved: (String value){
                                      signInData['password']=value;
                                    },
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(0,0,0,1))
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(0,0,0,1))
                                        ),
                                        hintText: 'Mot de Passe',
                                        hintStyle: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                        prefixIcon: Icon(Icons.lock,color: Colors.black,),
                                        suffixIcon: GestureDetector(
                                          child: Icon(Icons.visibility,color: Colors.black,),
                                          onTap: (){
                                            setState(() {
                                              obscureText=!obscureText;
                                            });
                                          },
                                        )
                                    ),
                                    validator: (String value){
                                      if(value.trim().isEmpty)
                                      {
                                        return'Champs obligatoire';
                                      }else if (value.length<6)
                                      {
                                        return "Mot de passe doit etre de longueur superieure à 6";
                                      }
                                      return "";
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  ClipOval(
                    child: Container(
                      child: InkWell(
                        onTap: (){
                          validate();

                        },
                        child: new Icon(Icons.arrow_forward,size: 40,color: Colors.white,),
                      ),
                      height: MediaQuery.of(context).size.height*0.1,
                      width: MediaQuery.of(context).size.width*0.2,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.01,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(child: Text("Mot de passe oublié",style: GoogleFonts.abel(fontSize: 12,fontWeight: FontWeight.w400),))
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Inscription(option: widget.option,)));
                        },
                        child:Text("Nouveau compte",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.black)
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
class WavyImageHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Image.asset('assets/header.jpg'),
      clipper: BottomWaveClipperHomePage(),

    );
  }
}
class BottomWaveClipperHomePage extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path=Path();
    path.lineTo(0, size.height*0.9);
    path.cubicTo(size.width/3, size.height*0.8, 2*size.width/3, size.height*0.8, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}