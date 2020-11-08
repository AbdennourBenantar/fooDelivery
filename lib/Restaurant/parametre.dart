import 'package:barberdz/Restaurant/RestaurantPlats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barberdz/bloc/bloc_navigation/navigation_bloc.dart';

class Parametres extends StatefulWidget with NavigationStates{
  @override
  _ParametresState createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.6,color: Colors.orange.withOpacity(0.8),),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height*0.07,width: MediaQuery.of(context).size.width,),
            Titlee(text: 'Burger King',),
            SizedBox(height: MediaQuery.of(context).size.height*0.2,width: MediaQuery.of(context).size.width,),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:50,vertical: 10),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,width: MediaQuery.of(context).size.width,),

                      CircleAvatar(
                        child: Icon(
                            Icons.perm_identity,
                            color: Colors.white ,
                          size: 50,
                          ),
                        radius: 40,
                        backgroundColor: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10,bottom: 2),
                        child: Text("Abdenour Benantar",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w400),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom:18.0),
                        child:  Row(
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

                          ],
                        ),
                      ),

                      ListTile(
                        title:Text("0779089015",style:TextStyle(color: Colors.black.withAlpha(100),fontSize: 15),),
                        leading: Icon(
                          Icons.phone,
                          color: Colors.orange.withOpacity(0.8) ,
                        ),
                      ),
                      ListTile(
                        title:Text("xyz@gmail.com",style:TextStyle(color: Colors.black.withAlpha(100),fontSize: 15),),
                        leading: Icon(
                          Icons.mail_outline,
                          color: Colors.orange.withOpacity(0.8),
                        ),
                      ),
                    ],

                  ),
                ),
              ),
            ),
          ],
        )

      ],
    );
  }
}
