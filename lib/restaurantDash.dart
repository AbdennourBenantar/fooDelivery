import 'package:flutter/material.dart';

import 'bloc/bloc_navigation/navigation_bloc.dart';

class RestaurantDash extends StatefulWidget with NavigationStates {
  @override
  _RestaurantDashState createState() => _RestaurantDashState();
}

class _RestaurantDashState extends State<RestaurantDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(color: Colors.white,
            child: Text("HOME1",style: TextStyle(color: Colors.black),),),
          ),
        ],
      ),
    );
  }
}
