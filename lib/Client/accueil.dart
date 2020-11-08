import 'package:barberdz/Client/accueil_bloc_nav/accueil_bloc_nav.dart';
import 'package:barberdz/Restaurant/RestaurantPlats.dart';
import 'package:barberdz/Restaurant/option.dart';
import 'package:barberdz/bloc/bloc_navigation/navigation_bloc.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Accueil extends StatefulWidget with NavigationStates{
  @override
  _AccueilState createState() => _AccueilState();
}

int selectedOption=1;
class _AccueilState extends State<Accueil> {
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
                      switch(index){
                        case 0:BlocProvider.of<AccueilNavBloc>(context).add(AccueilNavEvents.RecentClickedEvent);break;
                        case 1:BlocProvider.of<AccueilNavBloc>(context).add(AccueilNavEvents.PizzaClickedEvent);break;
                        case 2:BlocProvider.of<AccueilNavBloc>(context).add(AccueilNavEvents.SandsClickedEvent);break;
                        case 3:BlocProvider.of<AccueilNavBloc>(context).add(AccueilNavEvents.AssiClickedEvent);break;
                      }
                    },
                  ),
              ],
                ),
              BlocBuilder<AccueilNavBloc,NavStates>(
                builder: (context,navigationState){
                  return navigationState as Widget;
                },
              ),

              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
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
