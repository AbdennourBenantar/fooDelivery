import 'package:barberdz/Client/accueil_bloc_nav/accueil_bloc_nav.dart';
import 'package:barberdz/Restaurant/RestaurantPlats.dart';
import 'package:barberdz/bloc/bloc_navigation/navigation_bloc.dart';
import 'package:barberdz/dishes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Cart extends StatefulWidget with NavigationStates{
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    double countTotal(){
      double sum=0;
      if(platCarted.length>0){
      for(int i=0;i<platCarted.length;i++)
        {
          sum=sum+(platCarted[i].price)*(platCarted[i].x);
        }
      }else{
        sum=0;
      }
      return sum;
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.6,color: Colors.orange.withOpacity(0.8),),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height*0.07,width: MediaQuery.of(context).size.width,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Titlee(text: 'Mon panier',),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.04,width: MediaQuery.of(context).size.width,),

              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height*0.9,
                  child: ListView.builder(
                      itemBuilder: (context,index){
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.22,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 12),
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
                                      child: Image.asset(platCarted[index].imagePath,fit: BoxFit.contain,)),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.02,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(platCarted[index].title,style: GoogleFonts.abel(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),),
                                      Text("Quantité : x"+platCarted[index].x.toString(),style: GoogleFonts.abel(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w100
                                      ),),
                                      Text("Prix: "+platCarted[index].price.toString()+" €",style: GoogleFonts.abel(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w100
                                      ),),
                                      Text("Prix Total : "+(platCarted[index].x*platCarted[index].price).toString()+" €",style: GoogleFonts.abel(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w100
                                      ),),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height*0.02,
                                      ),
                                      FlatButton(
                                        color: Colors.red,
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.delete),
                                            SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                            Text('Enlever du panier ',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                                          ],
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            platCarted.remove(platCarted[index]);
                                          });
                                        },
                                      )
                                      
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),

                        );
                      },
                      itemCount: platCarted.length),
                ),
              )


            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.8),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
        ),
        height: MediaQuery.of(context).size.height*0.12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.arrow_upward,color: Colors.black,size: 20,),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text('Swipe up pour effectuer votre commande',style: GoogleFonts.abel(color:Colors.black,fontSize: 14, fontWeight: FontWeight.w100),),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(Icons.shopping_basket,color: Colors.white,size: 30,),
                  Text('Totale à payer est : '+countTotal().toString()+" €",style: GoogleFonts.abel(color:Colors.white,fontSize: 18, fontWeight: FontWeight.w500),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
