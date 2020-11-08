import 'package:barberdz/Client/accueil_bloc_nav/accueil_bloc_nav.dart';
import 'package:barberdz/Client/clientLogin.dart';
import 'package:barberdz/Restaurant/restaurantLogin.dart';
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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            WavyImageHomePage(),
            Text("Are you a :",style: GoogleFonts.abel(fontSize: 40,fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
              child: Row(
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
                              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>Restaurant()));
                            },
                          ),
                          height: MediaQuery.of(context).size.height*0.15,
                          width: MediaQuery.of(context).size.width*0.3
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Restaurant",style: GoogleFonts.changa(fontSize: 25,fontWeight: FontWeight.bold),)
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
                              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>Client()));

                            },
                          ),
                            height: MediaQuery.of(context).size.height*0.15,
                            width: MediaQuery.of(context).size.width*0.3
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Client",style: GoogleFonts.changa(fontSize: 25,fontWeight: FontWeight.bold),)
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