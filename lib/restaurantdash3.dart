import 'package:barberdz/bloc/bloc_navigation/navigation_bloc.dart';
import 'package:flutter/material.dart';

class RestaurantDash3 extends StatelessWidget with NavigationStates{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(color: Colors.white,
              child: Text("HOME3",style: TextStyle(color: Colors.black)),),
          ),
        ],
      ),
    );
  }
}
