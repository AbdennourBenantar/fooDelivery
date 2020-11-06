import 'package:barberdz/bloc/bloc_navigation/navigation_bloc.dart';
import 'package:flutter/material.dart';

class Historique extends StatefulWidget with NavigationStates{
  @override
  _HistoriqueState createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Historique",style: TextStyle(color: Colors.black),),
      ),
    );
  }
}