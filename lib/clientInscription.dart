import 'package:barberdz/Livreur/livreurlayout.dart';
import 'package:barberdz/clientLogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Restaurant/resto_layout.dart';
import 'client/clientLayout.dart';
import 'config.dart';
import 'package:progress_dialog/progress_dialog.dart';


class Inscription extends StatefulWidget {
  final int option;

  const Inscription({Key key, this.option}) : super(key: key);
  @override
  _InscriptionState createState() => _InscriptionState();
}
String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
bool obscureText=true;
class _InscriptionState extends State<Inscription> {
  final Map<String,dynamic> signUpData={'email':null,'username':null,'phone':null,'password':null};

  final _formKey=new GlobalKey<FormState>();
  final _scaffoldKey=new GlobalKey<ScaffoldState>();

  final focusUsername=new FocusNode();

  final focusPhone=new FocusNode();

  final focusPassword=new FocusNode();


  void validate() async{
    final FormState _form=_formKey.currentState;
    ProgressDialog pg=new ProgressDialog(context);
    pg.style(
      message: 'Inscription en cours ...',
    );
    if(!_form.validate()){
      _form.save();
      try{
        pg.show();
        UserCredential result=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: signUpData['email'], password: signUpData['password']);
        print(result.user.uid);
        Food.user=result.user;

        if(Food.user!=null){
          saveUserToFirestore(Food.user).then((value) async {
            await pg.hide();
            switch(widget.option){
              case 0:
                Navigator.push(context, new MaterialPageRoute(builder: (context) => widget.option == 0 ? ClientLayout() : widget.option == 1 ? RestoLayout() : CoursierLayout()));

                break;
              case 1:
                FirebaseFirestore.instance.collection("restos").doc(Food.sharedPreferences.getString(Food.restoUID)).get().then((bar) {
                  if(bar.data()[Food.restoAutorise]=='0')
                  {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Vous n'etes pas autorisé à acceder à notre platforme pour le moment, vous y serez autorisé dés qu'on finisse le traitement de votre demande"))).closed.then((value) => Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>Login(option: widget.option,))));

                  }
                  else{
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => widget.option == 0 ? ClientLayout() : widget.option == 1 ? RestoLayout() : CoursierLayout()));
                  }
                });
                break;
              case 2:
                FirebaseFirestore.instance.collection("livreurs").doc(Food.sharedPreferences.getString(Food.livreurUID)).get().then((livreur) {
                  if(livreur.data()[Food.livreurAutorise]=='0')
                  {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Vous n'etes pas autorisé à acceder à notre platforme pour le moment, vous y serez autorisé dés qu'on finisse le traitement de votre demande"))).closed.then((value) => Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>Login(option: widget.option,))));
                  }
                  else{
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => widget.option == 0 ? ClientLayout() : widget.option == 1 ? RestoLayout() : CoursierLayout()));
                  }
                });
                break;
            }
          });
        }
      }on PlatformException catch(e){
        await pg.hide();
        print(e.message.toString());
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
      catch(e){
        await pg.hide();
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    }else{
      print("Echec");
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
      key: _scaffoldKey,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          WavyImageRestaurantPage(),
          Padding(
            padding: const EdgeInsets.only(top:130),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text("Inscription",style: GoogleFonts.changa(fontSize: 55,fontWeight: FontWeight.bold),),
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
                                  child:
                                  TextFormField(keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusUsername);
                                    },
                                    onSaved: (String value){
                                      signUpData['email']=value;
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
                                        return "Adresse mail invalide";
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
                                  child:
                                  TextFormField(keyboardType: TextInputType.name,
                                    focusNode: focusUsername,
                                    style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusPhone);
                                    },
                                    onSaved: (String value){
                                      signUpData['username']=value;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black)
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      hintStyle: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                      hintText: "Nom d'utilisateur",
                                      prefixIcon: Icon(Icons.person,color: Colors.black,),
                                    ),
                                    validator: (String value){
                                      if(value.trim().isEmpty)
                                      {
                                        return'Champs obligatoire';
                                      }else if(value.length<6){
                                        return"Doit etre de longueur superieure à 6'";
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
                                  child:
                                  TextFormField(keyboardType: TextInputType.phone,
                                      focusNode: focusPhone,
                                      style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v){
                                        FocusScope.of(context).requestFocus(focusPassword);
                                      },
                                      onSaved: (String value){
                                        signUpData['phone']=value;
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black)
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        hintStyle: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                        hintText: 'Téléphone',
                                        prefixIcon: Icon(Icons.phone,color: Colors.black,),
                                      ),
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return "Champs Obligatoire";
                                        }
                                        else if (value.length!=10){
                                          return "Numéro de téléphone doit etre de longueur 10";
                                        }
                                        return "";
                                      }
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: new TextFormField(
                                    obscureText: obscureText,
                                    focusNode: focusPassword,

                                    style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                    onFieldSubmitted: (v){
                                      if(_formKey.currentState.validate())
                                      {
                                        _formKey.currentState.save();
                                      }
                                    },
                                    onSaved: (String value){
                                      signUpData['password']=value;
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
                                            FocusScope.of(context).unfocus();
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
                          /*Alert(
                              context: context,
                              title: 'Code de verification',
                              content: Column(
                                children: <Widget>[
                                  Text('Un code de verification a été envoyé à votre numéro de téléphone',
                                    style: GoogleFonts.changa(fontSize: 12,color: Colors.black),textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: new TextFormField(keyboardType: TextInputType.number,
                                            style: GoogleFonts.changa(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),
                                            textInputAction: TextInputAction.done,
                                            onFieldSubmitted: (v){
                                            },
                                            onSaved: (String value){
                                            },
                                            decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black)
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                              hintStyle: GoogleFonts.changa(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                              hintText: 'Code',
                                              prefixIcon: Icon(Icons.lock_outline,color: Colors.black,),
                                            ),
                                            validator: (String value){
                                              if(value.trim().isEmpty)
                                              {
                                                return'Code is required';
                                              }else{
                                                return"";
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  onPressed: (){
                                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>widget.option==0?ClientLayout():widget.option==1?BarLayout():widget.option==2?CoursierLayout():MagasinLayout()));
                                  },
                                  child: Text("Valider",
                                    style: GoogleFonts.changa(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                  color: Colors.black,
                                )
                              ]
                          ).show();*/
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
                      FlatButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                        },
                        child:Text("Login",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
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

  Future saveUserToFirestore(User user) async{
    switch(widget.option) {
      case 0:
        {
          FirebaseFirestore.instance.collection("clients").doc(user.uid).set({
            Food.clientUID:user.uid,
            Food.clientEmail:user.email,
            Food.clientName:signUpData['username'],
            Food.clientCardList:"",
            Food.clientPhone:signUpData['phone'],
            Food.clientDate:'jj-mm-aaaa',
            Food.clientLatitude:'0',
            Food.clientLongitude:'0',
            Food.clientAppart:'',
          });



          await Food.sharedPreferences.setString(Food.clientUID, user.uid);
          await Food.sharedPreferences.setString(Food.clientEmail, user.email);
          await Food.sharedPreferences.setString(Food.clientPhone, signUpData['phone']);
          await Food.sharedPreferences.setString(Food.FoodCurrentUser, "0");
          await Food.sharedPreferences.setString(Food.clientName, signUpData['username']);
          await Food.sharedPreferences.setString(Food.clientCardList, "");
          await Food.sharedPreferences.setString(Food.clientDate,'jj-mm-aaaa');
          await Food.sharedPreferences.setString(Food.clientAppart,'');
          await Food.sharedPreferences.setString(Food.clientLatitude,'0');
          await Food.sharedPreferences.setString(Food.clientLongitude,'0');
          break;
        }
      case 1:
        {
          FirebaseFirestore.instance.collection("restos").doc(user.uid).set({
            Food.restoUID:user.uid,
            Food.restoEmail:user.email,
            Food.restoName:signUpData['username'],
            Food.restoPhone:signUpData['phone'],
            Food.restoLatitude:0,
            Food.restoLongitude:0,
            Food.restoRating:0,
            Food.restoRatingCount:0,
            Food.restoBalance:'0',
            Food.restoAutorise:'0',
            Food.restoOuvert:'1'
          });


          await Food.sharedPreferences.setString(Food.restoUID, user.uid);
          await Food.sharedPreferences.setString(Food.restoEmail, user.email);
          await Food.sharedPreferences.setString(Food.restoName, signUpData['username']);
          await Food.sharedPreferences.setString(Food.restoPhone, signUpData['phone']);
          await Food.sharedPreferences.setString(Food.FoodCurrentUser, "1");
          await Food.sharedPreferences.setString(Food.restoLatitude, '0');
          await Food.sharedPreferences.setString(Food.restoLongitude,'0');
          await Food.sharedPreferences.setString(Food.restoRating, "0");
          await Food.sharedPreferences.setString(Food.restoRatingCount, "0");
          await Food.sharedPreferences.setString(Food.restoBalance, "0");
          await Food.sharedPreferences.setString(Food.restoOuvert, "1");

          break;
        }
      case 2:
        {
          FirebaseFirestore.instance.collection("livreurs").doc(user.uid).set({
            Food.livreurUID:user.uid,
            Food.livreurEmail:user.email,
            Food.livreurName:signUpData['username'],
            Food.livreurPhone:signUpData['phone'],
            Food.livreurAutorise:'0',
            Food.livreurLongitude:0,
            Food.livreurLatitude:0,
            Food.livreurRating:0,
            Food.livreurRatingCount:0,
            Food.livreurBalance:'0',
            Food.livreurCouleur:'',
            Food.livreurType:'',
            Food.livreurImageUrl:'',

          });

          await Food.sharedPreferences.setString(Food.livreurUID, user.uid);
          await Food.sharedPreferences.setString(Food.livreurEmail, user.email);
          await Food.sharedPreferences.setString(Food.FoodCurrentUser, "2");
          await Food.sharedPreferences.setString(Food.livreurName, signUpData['username']);
          await Food.sharedPreferences.setString(Food.livreurPhone, signUpData['phone']);
          await Food.sharedPreferences.setString(Food.livreurLatitude, '0');
          await Food.sharedPreferences.setString(Food.livreurLongitude,'0');
          await Food.sharedPreferences.setString(Food.livreurRating, "0");
          await Food.sharedPreferences.setString(Food.livreurRatingCount, "0");
          await Food.sharedPreferences.setString(Food.livreurBalance, "0");
          await Food.sharedPreferences.setString(Food.livreurCouleur, "");
          await Food.sharedPreferences.setString(Food.livreurType, "");
          await Food.sharedPreferences.setString(Food.livreurImageUrl, "");
          break;
        }
    }
  }
}
class WavyImageRestaurantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Image.asset('assets/header.jpg'),
      clipper: BottomWaveClipperRestaurantPage(),
    );
  }
}
class BottomWaveClipperRestaurantPage extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path=Path();
    path.lineTo(0, size.height*0.4);
    path.cubicTo(size.width/3, size.height*0.5, 2*size.width/3, size.height*0.5, size.width, size.height*0.8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
