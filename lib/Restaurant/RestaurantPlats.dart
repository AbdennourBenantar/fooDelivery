import 'dart:math';

import 'package:barberdz/Restaurant/option.dart';
import 'package:barberdz/pizzas.dart';
import 'package:barberdz/Restaurant/plat_card_shape.dart';
import 'package:barberdz/Restaurant/plat_details.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../bloc/bloc_navigation/navigation_bloc.dart';


class RestaurantPlats extends StatefulWidget with NavigationStates {
  @override
  _RestaurantPlatsState createState() => _RestaurantPlatsState();
}

class _RestaurantPlatsState extends State<RestaurantPlats> {
  int selectedOption=1;
  @override
  Widget build(BuildContext context) {

    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    var index=0;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(
            width: width*0.52,
            height: height*0.8,
            color: Colors.orange.withOpacity(0.8),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 130,),
              Titlee(text: 'Nos Plats',),
              SizedBox(
                height: 30,
              ),
              _FoodOptionAndItems(selectedOptionId:selectedOption,screenHeight: height,screenWidth: width,items: selectedOption==1?
                pizzas:selectedOption==2?sands:assiette
                ,),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int index=0;index<options.length;index++)
                      InkWell(
                        child: _OptionWidget(option: options[selectedOption-1],isSelected:options[index].id==selectedOption,pathNum: index,),
                        onTap: (){
                          setState(() {
                            selectedOption=options[index].id;
                          });
                        },
                      ),
                  ],
                ),
              )

            ],
          ),
        ],
      ),
    );
  }
}

class _FoodOptionAndItems extends StatefulWidget {
  final int selectedOptionId;
  final double screenWidth,screenHeight;
  final List<Plat> items;

  const _FoodOptionAndItems({Key key, this.selectedOptionId, this.screenWidth, this.screenHeight, this.items}) : super(key: key);
  @override
  __FoodOptionAndItemsState createState() => __FoodOptionAndItemsState();
}

class __FoodOptionAndItemsState extends State<_FoodOptionAndItems> {

  @override
  Widget build(BuildContext context) {
    switch(widget.selectedOptionId){
      case 1:{
        return SizedBox(
          height: widget.screenHeight*0.42,
          child: PageView.builder(
              itemCount: pizzas.length,
              controller: PageController(viewportFraction: 0.72),
              itemBuilder: (context,index){
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: (){Navigator.push(context,PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 350),
                        pageBuilder: (context,_,__)=>PlatDetails(plat:widget.items[index])
                    ));},
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: "background-${widget.items[index].title}",
                          child: Material(
                            elevation: 10,
                            shape:  PlatCardShape(widget.screenWidth*0.65,widget.screenHeight*0.38),
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32,32,32,60),
                          child: Align(
                            child: Image.asset(widget.items[index].imagePath,height: 140,width: 140,),
                            alignment: Alignment(0, 0),),
                        ),
                        Positioned(
                          bottom: 40,
                          left: 32,
                          right: 32,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.items[index].title,style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800
                              ),),
                              Text(widget.items[index].description,style:  TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300
                              ),),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32,32,32,60),
                          child: Align(
                            child: IconButton(
                              icon:Icon(Icons.close),
                              iconSize: 25,
                              color: Colors.black.withOpacity(0.8),
                              onPressed: (){
                                Alert(
                                    context: context,
                                    title: 'Confirmation de la suppression',
                                    content: Column(
                                      children: <Widget>[
                                        Text('Voulez-vous vraiment supprimer ce plat ? vos clients ne peuvent plus le commander ',
                                          style: GoogleFonts.changa(fontSize: 12,color: Colors.black),textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    buttons:[
                                      DialogButton(
                                        onPressed: (){
                                          setState(() {
                                            widget.items.remove(widget.items[index]);
                                            Navigator.pop(context);
                                          });

                                        },
                                        child: Center(
                                          child: Text("Confirmer",
                                            style: GoogleFonts.changa(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),
                                          ),
                                        ),
                                        color: Colors.black,
                                      )
                                    ]
                                ).show();
                              },
                            ),
                            alignment: Alignment(1.3, -1.2),),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        );
      }
      case 2:{
        return SizedBox(
          height: widget.screenHeight*0.42,
          child: PageView.builder(
              itemCount: sands.length,
              controller: PageController(viewportFraction: 0.72),
              itemBuilder: (context,index){
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: (){Navigator.push(context,PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 350),
                        pageBuilder: (context,_,__)=>PlatDetails(plat:widget.items[index])
                    ));},
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: "background-${widget.items[index].title}",
                          child: Material(
                            elevation: 10,
                            shape:  PlatCardShape(widget.screenWidth*0.65,widget.screenHeight*0.38),
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32,32,32,60),
                          child: Align(
                            child: Image.asset(widget.items[index].imagePath,height: 140,width: 140,),
                            alignment: Alignment(0, 0),),
                        ),
                        Positioned(
                          bottom: 40,
                          left: 32,
                          right: 32,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.items[index].title,style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800
                              ),),
                              Text(widget.items[index].description,style:  TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300
                              ),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32,32,32,60),
                          child: Align(
                            child: IconButton(
                              icon:Icon(Icons.close),
                              iconSize: 25,
                              color: Colors.black.withOpacity(0.8),
                              onPressed: (){
                                Alert(
                                    context: context,
                                    title: 'Confirmation de la suppression',
                                    content: Column(
                                      children: <Widget>[
                                        Text('Voulez-vous vraiment supprimer ce plat ? vos clients ne peuvent plus le commander ',
                                          style: GoogleFonts.changa(fontSize: 12,color: Colors.black),textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    buttons:[
                                      DialogButton(
                                        onPressed: (){
                                          setState(() {
                                            widget.items.remove(widget.items[index]);
                                            Navigator.pop(context);
                                          });

                                        },
                                        child: Center(
                                          child: Text("Confirmer",
                                            style: GoogleFonts.changa(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),
                                          ),
                                        ),
                                        color: Colors.black,
                                      )
                                    ]
                                ).show();
                              },
                            ),
                            alignment: Alignment(1.3, -1.2),),
                        ),

                      ],
                    ),
                  ),
                );
              }),
        );
      }
      case 3:{
        return SizedBox(
          height: widget.screenHeight*0.42,
          child: PageView.builder(
              itemCount: assiette.length,
              controller: PageController(viewportFraction: 0.72),
              itemBuilder: (context,index){
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: (){Navigator.push(context,PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 350),
                        pageBuilder: (context,_,__)=>PlatDetails(plat:widget.items[index])
                    ));},
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: "background-${widget.items[index].title}",
                          child: Material(
                            elevation: 10,
                            shape:  PlatCardShape(widget.screenWidth*0.65,widget.screenHeight*0.38),
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32,32,32,60),
                          child: Align(
                            child: Image.asset(widget.items[index].imagePath,height: 140,width: 140,),
                            alignment: Alignment(0, 0),),
                        ),
                        Positioned(
                          bottom: 40,
                          left: 32,
                          right: 32,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.items[index].title,style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800
                              ),),
                              Text(widget.items[index].description,style:  TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300
                              ),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32,32,32,60),
                          child: Align(
                            child: IconButton(
                              icon:Icon(Icons.close),
                              iconSize: 25,
                              color: Colors.black.withOpacity(0.8),
                              onPressed: (){
                                Alert(
                                    context: context,
                                    title: 'Confirmation de la suppression',
                                    content: Column(
                                      children: <Widget>[
                                        Text('Voulez-vous vraiment supprimer ce plat ? vos clients ne peuvent plus le commander ',
                                          style: GoogleFonts.changa(fontSize: 12,color: Colors.black),textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    buttons:[
                                      DialogButton(
                                        onPressed: (){
                                          setState(() {
                                            widget.items.remove(widget.items[index]);
                                            Navigator.pop(context);
                                          });

                                        },
                                        child: Center(
                                          child: Text("Confirmer",
                                            style: GoogleFonts.changa(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),
                                          ),
                                        ),
                                        color: Colors.black,
                                      )
                                    ]
                                ).show();
                              },
                            ),
                            alignment: Alignment(1.3, -1.2),),
                        ),

                      ],
                    ),
                  ),
                );
              }),
        );
      }

    }
}}

class _OptionWidget extends StatelessWidget{

  final Option option;
  final bool isSelected;
  final int pathNum;
  const _OptionWidget({Key key,@required this.option,this.isSelected=false,this.pathNum}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var path;
    if(pathNum==0)
      {
        path=options[0].imagePath;
      }else {
      if(pathNum==1){
        path=options[1].imagePath;
      }else{
        path=options[2].imagePath;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: isSelected?MediaQuery.of(context).size.width*0.16:MediaQuery.of(context).size.width*0.15,
          height: isSelected?MediaQuery.of(context).size.height*0.08:MediaQuery.of(context).size.height*0.07,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ?Colors.black:Colors.white,
          ),
          child: Image.asset(path,color: isSelected?Colors.white:Colors.black,)
        ),
      ),
    );
  }
}

class Titlee extends StatelessWidget {
  final String text;

  const Titlee({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final words=text.split(' ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: words[0],
              style: TextStyle(
                height: 0.9,
                fontWeight: FontWeight.w900,
                fontSize: 36,
                letterSpacing: 2,
                color: Colors.black
              )
            ),
            TextSpan(
              text: '\n'
            ),
            TextSpan(
                text: words[1],
                style: TextStyle(
                  height: 0.9,
                    fontWeight: FontWeight.w900,
                    fontSize: 36,
                    letterSpacing: 6,
                    fontFamily: 'Londrina_Outline',
                    color: Colors.black
                )
            )
          ]
        ),
      ),
    );
  }
}


class Background extends StatelessWidget {
  final double width,height;
  final Color color;

  const Background({Key key, this.width, this.height,this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Positioned(
     right: 0,
     width: width,
     top: 0,
     height: height,
     child: ClipRRect(
       child: Container(color: color,),
       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: width==MediaQuery.of(context).size.width?Radius.circular(40):Radius.circular(0)),
     ),
   );
  }
}
