import 'package:barberdz/Restaurant/RestaurantPlats.dart';
import 'package:barberdz/bloc/bloc_navigation/navigation_bloc.dart';
import 'package:barberdz/pizzas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RestaurantCommandes extends StatefulWidget with NavigationStates{
  @override
  _RestaurantCommandesState createState() => _RestaurantCommandesState();
}

class _RestaurantCommandesState extends State<RestaurantCommandes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.6,color: Colors.orange.withOpacity(0.8),),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height*0.07,width: MediaQuery.of(context).size.width,),
              Titlee(text: 'Commandes recues',),
              SizedBox(height: MediaQuery.of(context).size.height*0.01,width: MediaQuery.of(context).size.width,),

              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height*0.9,
                  child: ListView.builder(
                      itemBuilder: (context,index){
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.22,
                          child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          height: MediaQuery.of(context).size.height*0.15,
                                          width: MediaQuery.of(context).size.width*0.4,
                                          child: Image.asset(platcmd[index].imagePath,fit: BoxFit.contain,)),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.02,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(platcmd[index].title,style: GoogleFonts.abel(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          ),),
                                          Text("Quantité :"+((index%platFav.length)+1).toString(),style: GoogleFonts.abel(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w100
                                          ),),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height*0.02,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(Icons.close,),
                                                color: Colors.red,
                                                onPressed: (){
                                                  setState((){
                                                    platcmd.remove(platcmd[index]);
                                                  });
                                                },
                                                iconSize: 30,
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.check),
                                                color: Colors.green,
                                                onPressed: (){
                                                  print("df");
                                                },
                                                iconSize: 30,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),

                        );
                      },
                      itemCount: platcmd.length),
                ),
              )


            ],
          ),
        ],
      ),
    );
  }
}
