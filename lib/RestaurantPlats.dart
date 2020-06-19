import 'dart:math';

import 'package:barberdz/option.dart';
import 'package:barberdz/pizzas.dart';
import 'package:barberdz/plat_card_shape.dart';
import 'package:barberdz/plat_details.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bloc/bloc_navigation/navigation_bloc.dart';


class RestaurantPlats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _Background(
            width: width*0.4,
            height: height*0.8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50,),
              _AppBar(),
              SizedBox(height: 30,),
              _Title(text: 'Nos Plats',),
              SizedBox(
                height: 30,
              ),
              _FoodOptionAndItems(selectedOptionId:1,screenHeight: height,screenWidth: width,items: pizzas,)
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
    bool isSelected;
    Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int index=0;index<options.length;index++)
                InkWell(
                  child: _OptionWidget(option: options[index],isSelected:options[index].id==widget.selectedOptionId),
                  onTap: (){
                  },
                ),
            ],
          ),
        ),
        SizedBox(height:40),
      ],
    );
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

                      ],
                    ),
                  ),
                );
              }),
        );
      }
      case 2: return Text('2');
      case 3: return Text('3');
  }
}}

class _OptionWidget extends StatelessWidget{

  final Option option;
  final bool isSelected;
  const _OptionWidget({Key key,@required this.option,this.isSelected=false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ?Colors.black:Colors.white,
          ),
          child: Image.asset(option.imagePath,color: isSelected?Colors.white:Colors.black,),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title({Key key, this.text}) : super(key: key);
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

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ClayContainer(
            height: 50,
            width: 50,
            depth: 20,
            parentColor: Colors.black,
            borderRadius: 25,
            curveType: CurveType.concave,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x22647082),width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.shopping_cart,
                color: const Color(0xff647082),
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final double width,height;

  const _Background({Key key, this.width, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Positioned(
     right: 0,
     width: width,
     top: 0,
     height: height,
     child: ClipRRect(
       child: Container(color: Colors.black.withOpacity(0.92),),
       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
     ),
   );
  }
}
