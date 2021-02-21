import 'package:barberdz/dishes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../bloc/bloc_navigation/navigation_bloc.dart';
import '../config.dart';
import 'RestaurantPlats.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantDash extends StatefulWidget with NavigationStates {
  @override
  _RestaurantDashState createState() => _RestaurantDashState();
}

class _RestaurantDashState extends State<RestaurantDash> {
  Position current;

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition().then((Position position){
      setState(() async {
        current=position;
        FirebaseFirestore.instance.collection("restos").doc(Food.sharedPreferences.getString(Food.restoUID)).get().then((value) async {
          if(value.data()[Food.restoAutorise]=='1'){
            FirebaseFirestore.instance.collection("restos").doc(Food.sharedPreferences.getString(Food.restoUID)).update({
              Food.restoLatitude:current.latitude,
              Food.restoLongitude:current.longitude,
              Food.restoAutorise:'2'

            });
            await Food.sharedPreferences.setString(Food.restoLatitude, current.latitude.toString());
            await Food.sharedPreferences.setString(Food.restoLongitude,current.longitude.toString());
          }
        });

      });
    }).catchError((e){
      print(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if((Food.sharedPreferences.getString(Food.restoLatitude)=='0') &&(Food.sharedPreferences.getString(Food.restoLongitude)=='0'))
    {
      _getCurrentLocation();
    }else{
      current=Position(latitude: double.parse(Food.sharedPreferences.getString(Food.restoLatitude)),longitude: double.parse(Food.sharedPreferences.getString(Food.restoLongitude)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(
            height: MediaQuery.of(context).size.height*0.45,
            width: MediaQuery.of(context).size.width,
            color: Colors.orange.withOpacity(0.8),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height*0.07,),
              Titlee(text: 'Burger King',),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.07,width: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('40',style: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w800
                        ),),
                        Text("Commandes d'aujourd'hui",style: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                        ),),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('2300 €',style: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w800
                        ),),
                        Text("Gains d'aujourd'hui",style: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                child: Material(
                  animationDuration: Duration(milliseconds: 500),
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("Commandes d'aujourd'hui",style: GoogleFonts.abel(
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),),
                            Text("01 Novembre - 31 Decembre",style: GoogleFonts.abel(
                                fontSize: 8,
                                fontWeight: FontWeight.w100
                            ),),
                            SizedBox(
                              height: MediaQuery.of(context).size.height*0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('1523   ',style: GoogleFonts.abel(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),),
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.green,
                                  size: 29,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:30.0),
                        child: Container(
                          width: 0.6,
                          height: MediaQuery.of(context).size.height*0.07,
                          color: Colors.black45.withOpacity(0.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Gain total',style: GoogleFonts.abel(
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),),
                            Text("01 Novembre - 31 Decembre",style: GoogleFonts.abel(
                                fontSize: 8,
                                fontWeight: FontWeight.w400
                            ),),
                            SizedBox(
                              height: MediaQuery.of(context).size.height*0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('6100 €   ',style: GoogleFonts.abel(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),),
                                Icon(
                                  Icons.remove_circle,
                                  color: Colors.orange,
                                  size: 25,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                child: Material(
                  animationDuration: Duration(milliseconds: 500),
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Nouveaux clients',style: GoogleFonts.abel(
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),),
                            Text("01 Novembre - 31 Decembre",style: GoogleFonts.abel(
                                fontSize: 8,
                                fontWeight: FontWeight.w100
                            ),),
                            SizedBox(
                              height: MediaQuery.of(context).size.height*0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('52   ',style: GoogleFonts.abel(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),),
                                Icon(
                                  Icons.trending_down,
                                  color: Colors.red ,
                                  size: 29,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:30.0),
                        child: Container(
                          width: 0.6,
                          height: MediaQuery.of(context).size.height*0.07,
                          color: Colors.black45.withOpacity(0.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Avis des clients',style: GoogleFonts.abel(
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Icon(
                                  Icons.star_half,
                                  color: Colors.yellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height*0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('4.1/5   ',style: GoogleFonts.abel(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),),

                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Les plats les plus demandés ',
                  style: GoogleFonts.abel(color: Colors.black,
                  fontSize: 26,fontWeight: FontWeight.bold
                  ),
                  ),
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.22,
                child: PageView.builder(
                  itemCount: platFav.length,
                 controller: PageController(viewportFraction: 1.0),
                   itemBuilder: (context,index){
                   return  Padding(
                     padding: const EdgeInsets.all(15.0),
                     child: Material(
                       animationDuration: Duration(milliseconds: 1000),
                       elevation: 8,
                       borderRadius: BorderRadius.circular(8),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                           Container(
                               height: MediaQuery.of(context).size.height*0.15,
                               child: Image.asset(platFav[index].imagePath,fit: BoxFit.contain,)),
                           SizedBox(
                             width: MediaQuery.of(context).size.width*0.02,
                           ),
                           Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[
                               Text(platFav[index].title,style: GoogleFonts.abel(
                                   fontSize: 18,
                                   fontWeight: FontWeight.bold
                               ),),
                               Text("829 commandes",style: GoogleFonts.abel(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w100
                               ),),
                               SizedBox(
                                 height: MediaQuery.of(context).size.height*0.02,
                               ),
                               Text('Avis des clients',style: GoogleFonts.abel(
                                   fontSize: 18,
                                   fontWeight: FontWeight.bold
                               ),),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[
                                   Icon(
                                     Icons.star,
                                     color: Colors.yellow,
                                   ),
                                   Icon(
                                     Icons.star,
                                     color: Colors.yellow,
                                   ),
                                   Icon(
                                     Icons.star,
                                     color: Colors.yellow,
                                   ),
                                   Icon(
                                     Icons.star_half,
                                     color: Colors.yellow,
                                   ),
                                   Icon(
                                     Icons.star_border,
                                     color: Colors.yellow,
                                   ),
                                   SizedBox(
                                     width: MediaQuery.of(context).size.width*0.02,
                                   ),
                                   Text("(3.5)",style: GoogleFonts.abel(
                                       fontSize: 14,
                                       fontWeight: FontWeight.w100
                                   ),),
                                 ],
                               ),
                             ],
                           )
                         ],
                       ),
                     ),
                   );
                   },
             ),
              )

            ],
          ),
        ],
      ),
    );
  }
}
