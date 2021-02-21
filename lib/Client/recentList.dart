import 'dart:math';

import 'package:barberdz/Client/accueil_bloc_nav/accueil_bloc_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dishes.dart';

class RecentList extends StatefulWidget with NavStates {
  @override
  _RecentListState createState() => _RecentListState();
}

class _RecentListState extends State<RecentList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Historique de commandes',
              style: GoogleFonts.abel(color: Colors.black,
                  fontSize: 30,fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.01,),
          _FoodList(items:platcmd )
        ],
      ),
    );
  }
}
class _FoodList extends StatefulWidget {
  final List<Plat> items;


  const _FoodList({Key key,this.items,}) : super(key: key);
  @override
  __FoodListState createState() => __FoodListState();
}

class __FoodListState extends State<_FoodList> {


  @override
  Widget build(BuildContext context) {
    return
      Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.97,
        child: platcmd.length>0?ListView.builder(
            itemBuilder: (context, index) {
              return Item(plat: widget.items[index],dv: 1,);
            },
            itemCount: widget.items.length):
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/bg.png',fit: BoxFit.fill,),
                Text('You have not ordered food yet ',style: GoogleFonts.abel(fontSize: 20,color: Colors.black87),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Item extends StatefulWidget {
  final Plat plat;
  final int dv;
  const Item({Key key, this.plat, this.dv}) : super(key: key);
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool added=false;
  var _defaultvalue;
  int x;
  var rng = new Random();
  @override
  void initState() {
    super.initState();
    x=1;
    _defaultvalue=widget.dv;
    added=false;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.25,
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
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.15,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.4,
                  child: Image.asset(widget.plat.imagePath,
                    fit: BoxFit.contain,)),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.02,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.plat.title, style: GoogleFonts.abel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),),
                  Text("From : " + widget.plat.from,
                    style: GoogleFonts.abel(
                        fontSize: 14,
                        fontWeight: FontWeight.w100
                    ),),
                  Text(
                    "Distance : " + (1 + rng.nextInt(22)).toString()+" km",
                    style: GoogleFonts.abel(
                        fontSize: 14,
                        fontWeight: FontWeight.w100
                    ),),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.22,
                        child: Text((this.x*widget.plat.price.floor()).toString()+" €",
                          style: GoogleFonts.abel(
                              fontSize: 14,
                              fontWeight: FontWeight.w100
                          ),),
                      ),
                      Counter(
                        initialValue: _defaultvalue,
                        buttonSize: 28,
                        textStyle: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w100
                        ),

                        minValue: 1,
                        step: 1,
                        decimalPlaces: 0,
                        maxValue: 50,
                        color: Colors.orange.withOpacity(0.8),
                        onChanged: (value) {
                          setState(() {
                            _defaultvalue=value;
                            x=value;
                          });
                        },
                      )
                    ],
                  ),
                  FlatButton(
                    color: added?Colors.red:Colors.orange.withOpacity(0.8),
                    child: Row(
                      children: <Widget>[
                        Icon(added?Icons.delete:Icons.add_shopping_cart),
                        SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                        Text(added?'Remove from cart':'Add to cart',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    onPressed: (){
                      Carted carted=new Carted(x, widget.plat.imagePath, widget.plat.title, widget.plat.description, widget.plat.description, widget.plat.from, widget.plat.price);
                      if(added){
                        platCarted.remove(carted);
                      }else{
                        if(!platCarted.contains(carted))
                          platCarted.add(carted);
                      }
                      setState(() {
                        added=!added;
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

  }
}
