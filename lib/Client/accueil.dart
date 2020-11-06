import 'package:barberdz/Restaurant/RestaurantPlats.dart';
import 'package:barberdz/Restaurant/option.dart';
import 'package:barberdz/bloc/bloc_navigation/navigation_bloc.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../pizzas.dart';
import '../restaurants.dart';
import 'package:flutter_counter/flutter_counter.dart';

class Accueil extends StatefulWidget with NavigationStates{
  @override
  _AccueilState createState() => _AccueilState();
}
class _AccueilState extends State<Accueil> {
  int selectedOption=1;
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(
            width: width*0.6,height: height*0.4,color: Colors.orange.withOpacity(0.8),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _AppBar(),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int index=0;index<clientOptions.length;index++)
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _OptionWidget(option: clientOptions[selectedOption-1],isSelected:clientOptions[index].id==selectedOption,pathNum: index,),
                      ),
                      onTap: (){
                        setState(() {
                          selectedOption=clientOptions[index].id;
                        });
                      },
                    ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  selectedOption==1?'Recently ordered dishes':selectedOption==2?'Pizzas':selectedOption==3?'Sandwiches':'Plats',
                  style: GoogleFonts.abel(color: Colors.black,
                      fontSize: 30,fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),
              _FoodList(selectedCategory: selectedOption,items:selectedOption==1?pizzas:selectedOption==2?pizzas:selectedOption==3?sands:assiette
                  ,height: height,width: width,)
            ],
          )
        ],
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
          InkWell(
            child: ClayContainer(
              height: 50,
              width: 50,
              depth: 20,
              parentColor: Colors.orange,
              borderRadius: 25,
              curveType: CurveType.concave,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70,width:2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.black87,
                  size: 25,
                ),
              ),
            ),
            onTap: ()=>{
            BlocProvider.of<ClientNavBloc>(context).add(ClientNavigationEvents.MesCommandesClickedEvent)
          },
          ),
        ],
      ),
    );
  }
}
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
      path=clientOptions[0].imagePath;
    }else {
      if(pathNum==1){
        path=clientOptions[1].imagePath;
      }else{
        if(pathNum==2){
        path=clientOptions[2].imagePath;
        }else{
          path=clientOptions[3].imagePath;
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(18),
        child: Container(
            padding: const EdgeInsets.all(8),
            width: isSelected?MediaQuery.of(context).size.width*0.16:MediaQuery.of(context).size.width*0.13,
            height: isSelected?MediaQuery.of(context).size.height*0.08:MediaQuery.of(context).size.height*0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isSelected ?Colors.black:Colors.white,
            ),
            child: Image.asset(path,color: isSelected?Colors.white:Colors.black,)
        ),
      ),
    );
  }
}
class _FoodList extends StatefulWidget {
  final int selectedCategory;
  final double height,width;
  final List<Plat> items;


  const _FoodList({Key key, this.selectedCategory,this.items,this.height,this.width}) : super(key: key);
  @override
  __FoodListState createState() => __FoodListState();
}

class __FoodListState extends State<_FoodList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: widget.height * 0.9,
        width: widget.width * 0.97,
        child: ListView.builder(
            itemBuilder: (context, index) {
              return Item(plat: widget.items[index],dv: 1,);
            },
            itemCount: widget.items.length),
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
  var x;
  var rng = new Random();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    x=1;
    _defaultvalue=widget.dv;
    added=false;
  }
  @override
  Widget build(BuildContext context) {
    var v;
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
                        child: Text((this.x*widget.plat.price.floor()).toString()+" DA",
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
                            v=value;
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
                      if(added){
                      //platCarted.removeWhere((item)=>item.x==10);
                      }else{
                       //platCarted.add(carted);
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
