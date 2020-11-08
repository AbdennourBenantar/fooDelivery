
import 'package:barberdz/Restaurant/restaurantDash.dart';
import 'package:barberdz/Restaurant/restaurantInscription.dart';
import 'package:barberdz/Restaurant/sidebar_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class Restaurant extends StatelessWidget {
  final Map<String,dynamic> signInData={'phone':null,'password':null};
  final _formKey=new GlobalKey<FormState>();
  final focusPhone=new FocusNode();
  final focusPassword=new FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          WavyImageRestaurantPage(),
          Padding(
            padding: const EdgeInsets.only(top:230),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text("Restaurant",style: GoogleFonts.changa(fontSize: 55,fontWeight: FontWeight.bold),),
                  Text("Login",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w100),),
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
                                  child: new TextFormField(keyboardType: TextInputType.phone,
                                    style: GoogleFonts.changa(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusPassword);
                                    },
                                    onSaved: (String value){
                                      signInData['phone']=value;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black)
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                      ),
                                      hintStyle: GoogleFonts.changa(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                      hintText: 'Phone Number',
                                      prefixIcon: Icon(Icons.phone,color: Colors.black,),
                                    ),
                                    validator: (String value){
                                      if(value.trim().isEmpty)
                                      {
                                        return'Phone Number is required';
                                      }else{
                                        return"";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: new TextFormField(obscureText: true,
                                    focusNode: focusPassword,
                                    style: GoogleFonts.changa(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),
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
                                      hintText: 'Password',
                                      hintStyle: GoogleFonts.changa(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                      prefixIcon: Icon(Icons.lock,color: Colors.black,),
                                    ),
                                    validator: (String value){
                                      if(value.trim().isEmpty)
                                      {
                                        return 'Password is required';
                                      }
                                      else{
                                        return "";
                                      }
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
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>SidebarLayout()));
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
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RestaurantInscription()));
                        },
                        child:Text("New Account",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
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
