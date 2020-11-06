import 'package:barberdz/pizzas.dart';
import 'package:flutter/material.dart';

class PlatDetails extends StatefulWidget {
  final Plat plat;

  const PlatDetails({Key key, this.plat}) : super(key: key);
  @override
  _PlatDetailsState createState() => _PlatDetailsState();
}

class _PlatDetailsState extends State<PlatDetails> {
  @override
  Widget build(BuildContext context) {
    final screenHeight=MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: "background-${widget.plat.title}",
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Align(
                  child: IconButton(
                    icon:Icon(Icons.close),
                    iconSize: 30,
                    color: Colors.white.withOpacity(0.8),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  alignment: Alignment.topRight,
                ),
              ),
              Image.asset(
                widget.plat.imagePath,
                height: screenHeight*0.5,
                width: screenWidth*0.5,
              ),
              Text(
                widget.plat.title,style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                widget.plat.description,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
