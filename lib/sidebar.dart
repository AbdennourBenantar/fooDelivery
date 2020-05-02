import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar> {
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
        right: isSidebarOpenedAsync.data? 0 : screenWidth-50,
        child: Row(
        children: <Widget>[
              Expanded(
                child: Container(
                  color: Color(0xff262aaa),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 100,),
                      ListTile(
                        title: Text("Abdenour",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w800),),
                        subtitle: Text("ha_benatar@esi.dz",style:TextStyle(color: Colors.white.withAlpha(50),fontSize: 20),),
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.perm_identity,
                            color: Colors.white ,
                          ),
                          radius: 40,
                        ),
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color:Colors.white.withOpacity(0.3) ,
                        indent: 32,
                        endIndent: 32,
                      ),
                    ],
                  ),
                ),
              ),
          Align(
            alignment: Alignment(0,-0.9),
            child: GestureDetector(
              onTap: (){
                onIconPressed();
                },
              child: Container(
                width: 35,
                height: 110,
                color: Color(0xff262aaa),
                alignment: Alignment.centerLeft,
                child: AnimatedIcon(
                  progress: _animationController.view,
                  icon: AnimatedIcons.menu_close,
                  color: Color(0xff1bb5fd),
                  size: 25,
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
