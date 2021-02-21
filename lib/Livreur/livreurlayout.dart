import 'package:barberdz/Client/sidebarC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'bloc/livreurNav.dart';
import 'sidebarL.dart';

class CoursierLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CoursierNavBloc>(
        create: (context)=>CoursierNavBloc(),
        child: Stack(
          children: [
            BlocBuilder<CoursierNavBloc,NavStates>(
                builder: (context,navigationState){
                  return navigationState as Widget;
                }
            ),
            SideBarL(),
          ],
        ),
      ),
    );
  }
}
