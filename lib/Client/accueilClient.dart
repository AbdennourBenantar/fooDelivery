
import 'dart:collection';

import 'package:barberdz/Client/accueil.dart';
import 'package:barberdz/bloc/bloc_navigation/navigation_bloc.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../config.dart';


class AccueilClient extends StatefulWidget with NavigationStates{
  @override
  _AccueilClientState createState() => _AccueilClientState();

}

int selectedOption=1;
class _AccueilClientState extends State<AccueilClient> {
  List<double> distances=[];
  List<String> restoindex=[];
  GoogleMapController mapController;
  String searchAdr;
  Position current;
  Set<Marker> _markers=HashSet<Marker> ();
  BitmapDescriptor _markerIcon,_shishaIcon,_magaIcon;
  bool showMap;
  bool rated;

  Future _calculateDistances() async{
    int i=0;
    int j=0;
    distances.clear();
    restoindex.clear();

    FirebaseFirestore.instance.collection("restos").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if(((Geolocator.distanceBetween(current.latitude, current.longitude, element.data()[Food.restoLatitude],element.data()[Food.restoLongitude])/1000)<5.0)&&(element.data()[Food.restoAutorise]=='2')&&(element.data()[Food.restoOuvert]=='1'))
        {
          distances.add(double.parse((Geolocator.distanceBetween(current.latitude, current.longitude, element.data()[Food.restoLatitude],element.data()[Food.restoLongitude])/1000).toStringAsFixed(1)));
          restoindex.add(element.id);
        }
      });
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {
      });
    });
    showMap=false;
    rated=false;
    _getCurrentLocation();
    _setMarkerIcon();

  }

  void _setMarkerIcon() async{
    _markerIcon=await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/marker.png');
    _shishaIcon=await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/shisha.png');
    _magaIcon=await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/shop.png');

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:showMap? Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(current.latitude, current.longitude),
                zoom: 15.0,
              ),
              onMapCreated: onMapCreated,
              markers: _markers,
            ),
            Positioned(
                bottom:0,
                left: 0,
                right: 0,
                child:
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.25,
                  child: Center(
                    child: PageView.builder(
                      itemCount: distances.length,
                      controller: PageController(viewportFraction: 0.85),
                      itemBuilder: (context,index){
                         double lat;
                         double long;
                         DocumentSnapshot snap;
                          return Padding(
                            padding:  EdgeInsets.all(15),
                            child: InkWell(
                              child: Material(
                                color: Colors.black,
                                animationDuration:  Duration(milliseconds: 200),
                                elevation:20,
                                borderRadius: BorderRadius.circular(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width:MediaQuery.of(context).size.width*0.3,
                                      height: MediaQuery.of(context).size.height,
                                      child: ClipRRect(
                                        child: Image.asset('assets/1.jpg',fit: BoxFit.cover,),
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),topLeft: Radius.circular(8)),
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width*0.04,),
                                    StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("restos").doc(restoindex[index]).snapshots(),
                                        builder: (context, snapshot) {
                                          if(snapshot.hasData)
                                          {
                                            lat=snapshot.data.data()[Food.restoLatitude];
                                            long=snapshot.data.data()[Food.restoLongitude];
                                            snap=snapshot.data;
                                          }
                                          return !snapshot.hasData?Text('Chargement'):
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Text(snapshot.data.data()[Food.restoName],
                                                style: GoogleFonts.abel(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                              Text("Distance : "+ (distances==null?'Calcul ...':distances[index].toString())+" Km",style: GoogleFonts.abel(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                              Text("Livraison à : "+ (distances==null?'Calcul ...':distances[index]<1?'2 €':(distances[index]+1).toString()+' €'),style: GoogleFonts.abel(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal
                                              ),),
                                              Stack(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        top: 8.0, left: 12.0),
                                                    child: RatingBar(
                                                      initialRating: double.parse(snapshot.data.data()[Food.restoRating].toString()),
                                                      direction: Axis
                                                          .horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      ratingWidget: RatingWidget(
                                                          full: Image.asset(
                                                            'assets/heart.png',
                                                            color: Colors
                                                                .orange,),
                                                          half: Image.asset(
                                                              'assets/heart_half.png',
                                                              color: Colors
                                                                  .orange),
                                                          empty: Image.asset(
                                                              'assets/heart_border.png',
                                                              color: Colors
                                                                  .orange)
                                                      ),
                                                      itemSize: 15,
                                                      itemPadding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 1.0),
                                                      onRatingUpdate: (rating) {
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.black
                                                        .withOpacity(
                                                        0.01),
                                                    height: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .height * 0.05,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.3,
                                                  ),
                                                ],
                                              ),
                                              Text("Note : "+double.parse(snapshot.data.data()[Food.restoRating].toString()).toStringAsFixed(1)+"/5",style: GoogleFonts.abel(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                            ],
                                          );
                                        }
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                /*final coordinates = new Coordinates(dataSnapShot.data.docs[index].data()[Shish.barLatitude], dataSnapShot.data.docs[index].data()[Shish.barLongitude]);
                                await Geocoder.local.findAddressesFromCoordinates(coordinates).then((value) =>
                                    Navigator.push(context,PageRouteBuilder(
                                        transitionDuration: const Duration(milliseconds: 350),
                                        pageBuilder: (context,_,__)=>BarDetails(bar:dataSnapShot.data.docs[index],adr: value.first.addressLine,distance:distances[index])
                                    )));*/
                                BlocProvider.of<ClientNavBloc>(context).add(ClientNavigationEvents.RestaurantClickedEvent);
                              },
                            ),
                          );
                      },
                    ),
                  ),
                )
            ),
          ]
      ):
      Center(child: Text('Veuillez attendre un instant !'),),
    );
  }
  void onMapCreated(controller){
    setState(() {
      mapController=controller;
    });
  }
  searchAndNavigate(){
    GeocodingPlatform.instance.locationFromAddress(searchAdr).then((value) => {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
          value[0].latitude,value[0].longitude
      ),zoom: 10)))
    });
  }

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition().then((Position position){
      setState(() {
        current=position;
        FirebaseFirestore.instance.collection("clients").doc(Food.sharedPreferences.getString(Food.clientUID)).update({
          Food.clientLatitude:current.latitude,
          Food.clientLongitude:current.longitude
        });
        FirebaseFirestore.instance.collection("restos").where(Food.restoAutorise,isEqualTo: "2").get().whenComplete(() {setState(() {

        });}).then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            _markers.add(Marker(
                markerId: MarkerId(element.get(Food.restoUID).toString()),
                position: LatLng(element.get(Food.restoLatitude),element.get(Food.restoLongitude  )),
                infoWindow: InfoWindow(title: element.data()[Food.restoName],snippet: "Restaurant"),
                icon: _shishaIcon));
          });
        });

        _markers.add(Marker(
            markerId: MarkerId("0"),
            position: LatLng(current.latitude,current.longitude),
            infoWindow: InfoWindow(title: "Vous etes ici",snippet: "Ceci est votre position actuelle"),
            icon: _markerIcon));
      });
    }).catchError((e){
      print(e);
    }).then((value) => _calculateDistances()).whenComplete(() => null).then((value) => showMap=true);
  }

}

/*class BarDetails extends StatefulWidget {
  final QueryDocumentSnapshot bar;
  final String adr;
  final double distance;


  const BarDetails({Key key, this.bar, this.adr,this.distance}) : super(key: key);
  @override
  _BarDetailsState createState() => _BarDetailsState();
}

class _BarDetailsState extends State<BarDetails> {
  bool rated;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rated=false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Background(
            width: MediaQuery.of(context).size.width*0.8,
            height: MediaQuery.of(context).size.height*0.9,
            color: Colors.blue.shade100,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.4,
                      child: Image.asset(
                        bars[0].imgPath,
                        fit: BoxFit.cover,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0,top: 6),
                    child: Align(
                      child: IconButton(
                        icon:Icon(Icons.close),
                        iconSize: 36,
                        color: Colors.white,
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                  child: Material(
                    animationDuration: Duration(milliseconds: 500),
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                            child: Column(
                              children: [
                                Text(
                                    widget.bar.data()[Shish.barName],style: GoogleFonts.abel(fontSize: 24, fontWeight: FontWeight.bold,)
                                ),
                                Text(
                                  widget.adr,style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.bold,color: Colors.black45),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:30.0),
                            child: Container(
                              width: 0.6,
                              height: MediaQuery.of(context).size.height*0.07,
                              color: Colors.black45.withOpacity(0.2),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance.collection("bars").doc(widget.bar.id).snapshots(),
                                  builder: (context, snapshot) {
                                    return !snapshot.hasData?
                                    Center(child: Text("Chargement ...."),)
                                        :Column(
                                      children: [
                                        Text(
                                          "Distance : "+ widget.distance.toStringAsFixed(1)+" Km",style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold,),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text("Livraison à : "+ (widget.distance<=1?'2 €':(widget.distance+1).toString()+' €'),style: GoogleFonts.abel(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal
                                        ),),
                                        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                        RatingBar(
                                          initialRating: double.parse(snapshot.data.data()[Shish.barRating].toString()),
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ratingWidget: RatingWidget(
                                              full: Image.asset('assets/heart.png',color: Colors.redAccent,),
                                              half: Image.asset('assets/heart_half.png',color: Colors.redAccent),
                                              empty: Image.asset('assets/heart_border.png',color: Colors.redAccent)
                                          ),
                                          itemSize: 15,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                          onRatingUpdate: (rating){
                                            setState(() async {
                                              if(!rated){
                                                FirebaseFirestore.instance.collection("bars").doc(widget.bar.id).update({
                                                  Shish.barRatingCount:snapshot.data.data()[Shish.barRatingCount]+1,
                                                  Shish.barRating:(snapshot.data.data()[Shish.barRating])+((rating-snapshot.data.data()[Shish.barRating])/(snapshot.data.data()[Shish.barRatingCount]+1))
                                                }).then((value) => rated=true);
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                        Text("Note "+double.parse(snapshot.data.data()[Shish.barRating].toString()).toStringAsFixed(1)+"/5",style: GoogleFonts.abel(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      ],
                                    );
                                  }
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Nos Chichas',
                  style: GoogleFonts.abel(color: Colors.black,
                      fontSize: 22,fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height*0.3,
                  child:
                  StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection("bars/"+widget.bar.data()[Shish.barUID]+"/barChichas").snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData?Center(child: Text("Chargement ..."),): PageView.builder(
                          itemCount: snapshot.data.docs.length,
                          controller: PageController(viewportFraction: 0.8),
                          itemBuilder: (context,index){
                            return Opacity(
                              opacity: snapshot.data.docs[index].data()["etat"]=="1"?1.0:0.5,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10,),
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: "background-${snapshot.data.docs[index].id}",
                                      child: Material(
                                        elevation: 10,
                                        shape:  PlatCardShape(MediaQuery.of(context).size.width*0.55,MediaQuery.of(context).size.height*0.32),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(70,132,0,0),
                                      child: Align(
                                        child: Image.network(snapshot.data.docs[index].data()["img"],height: 140,width: 140,),
                                        alignment: Alignment(0, 0),),
                                    ),
                                    Positioned(
                                      top:80,
                                      left: 15,
                                      right: 32,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Chicha "+snapshot.data.docs[index].data()["type"],style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800
                                              ),),
                                            ],
                                          ),
                                          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                                          Text("Prix : "+snapshot.data.docs[index].data()["prix"]+ ",00 €",style:  TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300
                                          ),),
                                          SizedBox(height: MediaQuery.of(context).size.height*0.01,),

                                          Padding(
                                            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.32),
                                            child: FlatButton(
                                              color: Colors.green.withOpacity(0.8),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.shopping_basket),
                                                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                                  Text('Choisir',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                                                ],
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              onPressed: (){
                                                if(snapshot.data.docs[index].data()["etat"]=='0')
                                                {
                                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Chicha non disponible pour le moment, veuillez essayer avec d'autres chichas")));
                                                }
                                                else{
                                                  Navigator.push(context, new MaterialPageRoute(builder: (context)=>ChichaLayout(bar: widget.bar,chicha: snapshot.data.docs[index],distanceLivraison:widget.distance)));
                                                }
                                              },
                                            ),
                                          )


                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}*/
class PlatCardShape extends ShapeBorder{
  final double width;
  final double height;

  const PlatCardShape(this.width, this.height);
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getInnerPath
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return getClip(Size(width,height));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    return null;
  }
  Path getClip(Size size) {
    Path clippedPath=new Path();
    double curveDistance=40;

    clippedPath.moveTo(0, size.height*0.4);
    clippedPath.lineTo(0, size.height-curveDistance);
    clippedPath.quadraticBezierTo(1, size.height-1, 0+curveDistance, size.height);
    clippedPath.lineTo(size.width-curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width+1, size.height-1, size.width, size.height-curveDistance);
    clippedPath.lineTo(size.width, 0+curveDistance);
    clippedPath.quadraticBezierTo(size.width-1, 0, size.width-curveDistance-5, 0+curveDistance/3);
    clippedPath.lineTo(curveDistance, size.height*0.27);
    clippedPath.quadraticBezierTo(1, (size.height*0.30)+10, 0, size.height*0.4);
    return clippedPath;
  }

}