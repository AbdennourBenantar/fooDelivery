import 'package:barberdz/Client/accueil_bloc_nav/accueil_bloc_nav.dart';
import 'package:barberdz/clientLogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
  MultiBlocProvider(
    providers: [
      BlocProvider<AccueilNavBloc>(
        create: (context)=>AccueilNavBloc(),
      ),
    ],
    child: MyApp(),
  )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FooDz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Online Food Ordering '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp().whenComplete(() async {
      setState((){

      });
      Food.auth=FirebaseAuth.instance;
      Food.sharedPreferences=await SharedPreferences.getInstance();
      Food.firestore=FirebaseFirestore.instance;
    });
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            WavyImageHomePage(),
            Text("Êtes-vous :",style: GoogleFonts.abel(fontSize: 40,fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ClipOval(
                            child: Container(
                              child:
                              InkWell(
                                child: Image.asset('assets/chef.jpg'),
                                onTap: (){
                                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>Login(option: 1,)));
                                },
                              ),
                              height: MediaQuery.of(context).size.height*0.2,
                              width: MediaQuery.of(context).size.width*0.2
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Restaurant",style: GoogleFonts.changa(fontSize: 14,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Column(
                        children: <Widget>[
                          ClipOval(
                            child: Container(
                              child:
                              InkWell(
                                child: Image.asset('assets/buyer.jpg'),
                                onTap: (){
                                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>Login(option: 0,)));

                                },
                              ),
                                height: MediaQuery.of(context).size.height*0.2,
                                width: MediaQuery.of(context).size.width*0.2
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Client",style: GoogleFonts.changa(fontSize: 14,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      SizedBox(
                        width: 50,
                      ),

                      Column(
                        children: <Widget>[
                          ClipOval(
                            child: Container(
                                child:
                                InkWell(
                                  child: Image.asset('assets/scooter.png'),
                                  onTap: (){
                                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>Login(option: 2,)));
                                  },
                                ),
                                height: MediaQuery.of(context).size.height*0.2,
                                width: MediaQuery.of(context).size.width*0.2
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Livreur",style: GoogleFonts.changa(fontSize: 14,fontWeight: FontWeight.bold),)
                        ],
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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