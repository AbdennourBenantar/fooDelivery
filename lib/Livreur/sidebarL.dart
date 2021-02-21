import 'dart:async';
import 'dart:ui';

import 'package:barberdz/MenuItem.dart';
import 'package:barberdz/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc/bloc_navigation/navigation_bloc.dart';
import '../config.dart';
import 'bloc/livreurNav.dart';

class SideBarL extends StatefulWidget {
  @override
  _SideBarLState createState() => _SideBarLState();
}

class _SideBarLState extends State<SideBarL> with SingleTickerProviderStateMixin<SideBarL> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration=const Duration(milliseconds: 500 );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController=AnimationController(vsync: this,duration: _animationDuration);
    isSidebarOpenedStreamController=PublishSubject<bool>();
    isSidebarOpenedStream=isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink=isSidebarOpenedStreamController.sink;
  }
  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context,isSidebarOpenedAsync){
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSidebarOpenedAsync.data? 0 : -screenWidth,
          right: isSidebarOpenedAsync.data? 0 : screenWidth-40,
          child: Row(
            children: <Widget>[
              Expanded(
                child: BackdropFilter(
                  filter: isSidebarOpenedAsync.data?ImageFilter.blur(sigmaY: 10,sigmaX: 10):ImageFilter.blur(sigmaY: 0,sigmaX: 0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.black,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 100,),
                        ListTile(
                          title: Text("El Dev",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w800),),
                          subtitle: Text("El Dev@elDev.com",style:TextStyle(color: Colors.white.withAlpha(100),fontSize: 15),),
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.perm_identity,
                              color: Colors.white ,
                            ),
                            radius: 40,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        Divider(
                          height: 64,
                          thickness: 0.5,
                          color:Colors.white.withOpacity(0.3) ,
                          indent: 32,
                          endIndent: 32,
                        ),
                        MenuItem(
                          icon: Icons.home,
                          title: "Accueil",
                          onTap: (){
                            onIconPressed();
                            BlocProvider.of<CoursierNavBloc>(context).add(CoursierNavEvents.AccueilClickedEvent);
                          },
                        ),
                        MenuItem(
                          icon: Icons.motorcycle,
                          title: "Courses",
                          onTap: (){
                            onIconPressed();
                            BlocProvider.of<CoursierNavBloc>(context).add(CoursierNavEvents.CommandesClickedEvent);
                          },
                        ),

                        Divider(
                          height: 64,
                          thickness: 0.5,
                          color:Colors.white.withOpacity(0.3) ,
                          indent: 32,
                          endIndent: 32,
                        ),
                        MenuItem(
                          icon: Icons.settings,
                          title: "Profil",
                          onTap: (){
                            onIconPressed();
                            BlocProvider.of<ClientNavBloc>(context).add(ClientNavigationEvents.ParametresClickedEvent);
                          },
                        ),
                        MenuItem(
                          icon: Icons.support,
                          title: "Support",
                          onTap: (){
                            onIconPressed();
                            Utils.openEmail(
                                toEmail: 'foodelivery2021@gmail.com',
                                subject:'Votre sujet',
                                body: 'Plus de détails ici + photo S.V.P'
                            );
                          },
                        ),
                        MenuItem(
                            icon: Icons.exit_to_app,
                            title: "Se déconnecter",
                            onTap:() async {
                              await Food.auth.signOut().then((value) {
                                Navigator.pop(context);
                              });
                            }
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: (){},
                                child: Text('CONDITIONS GENERALES DE VENTES',style: GoogleFonts.abel(color: Colors.white.withOpacity(0.5),fontSize: 12),),
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0,-0.9),
                child: GestureDetector(
                  onTap: (){
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 120,
                      color: Colors.black,
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void onIconPressed() {
    final animationStatus=_animationController.status;
    final isAnimationComplete=animationStatus==AnimationStatus.completed;
    if(isAnimationComplete){
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    }else{
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }
}
class CustomMenuClipper extends CustomClipper<Path>
{
  @override
  Path getClip(Size size) {
    Paint paint=Paint();
    paint.color=Colors.white;

    final width=size.width;
    final height=size.height;

    Path path=Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width-1, height/2-20, width, height/2);
    path.quadraticBezierTo(width+1, height/2+20, 10, height-16);
    path.quadraticBezierTo(0, height-8, 0, height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}