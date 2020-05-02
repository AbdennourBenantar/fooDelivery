import 'package:barberdz/restaurantDash.dart';
import 'package:flutter/material.dart';

import 'sidebar.dart';

class SidebarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          RestaurantDash(),
          SideBar(),
        ],
      ),
    );
  }
}
