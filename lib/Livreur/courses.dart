import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config.dart';
import 'bloc/livreurNav.dart';


class Courses extends StatefulWidget with NavStates{
  @override
  _CoursesState createState() => _CoursesState();
}


class _CoursesState extends State<Courses> {
  GoogleMapController mapController;
  String searchAdr;
  Position current;
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor _markerIcon, _restoIcon,_clientIcon;
  bool showMap;
  List<String> adresses=new List(1000);
  List<String> adresseMagBar=new List(1000);
  List<double> distances=new List(1000);
  String telephone;
  double clientLat;
  double clientLong;
  bool go=false;


  Future<void> getAdresses() async {
    int i=0;int j=0;
    FirebaseFirestore.instance.collection("courses").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) async {
        final coordinates = new Coordinates(double.parse(element.data()["srcLat"]), double.parse(element.data()["srcLong"]));
        await Geocoder.local.findAddressesFromCoordinates(coordinates).then((value) {
          adresseMagBar[j] = value.first.addressLine;
          j++;
        }
        );
        FirebaseFirestore.instance.collection("courses/"+element.id+"/courses").get().then((qs) {
          qs.docs.forEach((client) {
            FirebaseFirestore.instance.collection("clients").doc(client.data()[Food.clientUID]).get().then((clientdata) async {
              setState(() {
                clientLat=clientdata.data()[Food.clientLatitude];
                clientLong= clientdata.data()[Food.clientLongitude];
              });
              final coordinates = new Coordinates(clientdata.data()[Food.clientLatitude], clientdata.data()[Food.clientLongitude]);
              await Geocoder.local.findAddressesFromCoordinates(coordinates).then((value) {
                adresses[i] = value.first.addressLine;
                i++;
              }
              );
            });
          });

        });

      });
    }).whenComplete(() => null).then((value) {
      setState(() {
        go=true;
      });
    });
  }
  Future _calculateDistances() async{
    int i=0;
    FirebaseFirestore.instance.collection("courses").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        FirebaseFirestore.instance.collection("courses/"+element.id+"/courses").get().then((qs) {
          qs.docs.forEach((client) {
            FirebaseFirestore.instance.collection("clients").doc(client.data()[Food.clientUID]).get().then((clientdata) async {
              distances[i]=double.parse((Geolocator.distanceBetween(double.parse(element.data()["srcLat"]), double.parse(element.data()["srcLong"]), clientdata.data()[Food.clientLatitude] ,clientdata.data()[Food.clientLongitude])/1000).toStringAsFixed(1));
              i++;
            });
          });
        });

      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showMap = false;
    _getCurrentLocation();
    _setMarkerIcon();
  }

  void _setMarkerIcon() async {
    _restoIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/resto.png');
    _markerIcon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/scooter.png',);
    _clientIcon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/marker.png',);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showMap ? Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(current.latitude+0.0005, current.longitude),
                zoom: 15.0,
              ),
              onMapCreated: onMapCreated,
              markers: _markers,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:
                Material(
                  color: Colors.black,
                  elevation: 220,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50),
                      topLeft: Radius.circular(50)),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            color: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            onPressed: (){
                              setState(() {
                                showMap=true;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.history,color: Colors.white,
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                Center(child: Text('Rafraichir',style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),)),                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        height: 24,
                        thickness: 3,
                        color: Colors.orange,
                        indent: 0,
                        endIndent: 0,
                      ),
                      SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.4,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection("courses").snapshots(),
                              builder: (context, snapshot) {
                                return !snapshot.hasData?
                                Center(child: Text(""),)
                                    :ListView(
                                  key: Key(snapshot.data.docs.length.toString()),
                                  children: [
                                    for(int index=0;index<snapshot.data.docs.length;index++)
                                      Material(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Icon(Icons.location_on),
                                                SizedBox(width: 20,),
                                                go?Text(adresseMagBar[index]==null?'-':adresseMagBar[index],style: GoogleFonts.abel(fontSize:16),):Text("-")
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal:38.0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.location_on,size: 18,),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(child: Text("De chez",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(child: Text(snapshot.data.docs[index].data()["srcName"],style: GoogleFonts.abel(fontSize:14,),)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal:38.0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.phone,size: 18,),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(child: Text("Téléphone bar",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(child: Text(snapshot.data.docs[index].data()["srcPhone"],style: GoogleFonts.abel(fontSize:14,),)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal:28.0),
                                              child: SizedBox(
                                                height: MediaQuery.of(context).size.height*0.2,
                                                child: StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore.instance.collection("courses").doc(snapshot.data.docs[index].id).collection("courses").snapshots(),
                                                    builder: (context, dsnapshot) {
                                                      return !dsnapshot.hasData?Center(child: Text(""),)
                                                          :ListView(
                                                        children:[
                                                          for(int i=0;i<dsnapshot.data.docs.length;i++)
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: ExpansionTile(
                                                                title: SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Icon(Icons.location_on),
                                                                      SizedBox(width: 20,),
                                                                      Text(adresses[index+i]==null?'-':adresses[index+i],style: GoogleFonts.abel(fontSize:16),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                children: [
                                                                  StreamBuilder<DocumentSnapshot>(
                                                                      stream: FirebaseFirestore.instance.collection("clients").doc(dsnapshot.data.docs[i].id).snapshots(),
                                                                      builder: (context, ddsnapshot) {
                                                                        !ddsnapshot.hasData?telephone="":telephone=ddsnapshot.data.data()[Food.clientPhone];
                                                                        return !ddsnapshot.hasData?Center(child: Text(""),)
                                                                            : Table(
                                                                          children: [
                                                                            TableRow(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Icon(Icons.add_road,size: 18,),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(child: Text("Distance ",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(child: Text(distances[index+i].toString()+" km",style: GoogleFonts.abel(fontSize:14,),)),
                                                                                  ),
                                                                                ]
                                                                            ),
                                                                            TableRow(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Icon(Icons.location_on,size: 18),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(child: Text("Adresse client",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(child: SingleChildScrollView(child: Text(adresses[index+i],style: GoogleFonts.abel(fontSize:14,),),scrollDirection: Axis.horizontal,)),
                                                                                  ),
                                                                                ]
                                                                            ),
                                                                            TableRow(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Icon(Icons.phone,size: 18,),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(child: Text("Téléphone client",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(child: Text(ddsnapshot.data.data()[Food.clientPhone],style: GoogleFonts.abel(fontSize:14,),)),
                                                                                  )

                                                                                ]
                                                                            ),

                                                                          ],
                                                                        );

                                                                      }
                                                                  ),
                                                                  Center(child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      FlatButton(
                                                                        color: Colors.green.shade400,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(5)
                                                                        ),
                                                                        onPressed: (){
                                                                         /* Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>CourseDetails(course: snapshot.data.docs[index],clientUID:dsnapshot.data.docs[i].id,adresse: adresseMagBar[index],distance: distances[index+i],telephoneClient: telephone, clientLat: clientLat,clientLong: clientLong ))).then((value) {
                                                                            getAdresses();
                                                                            _calculateDistances();
                                                                          });*/
                                                                        },
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Text('Continuer',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.white),),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),)
                                                                ],
                                                              ),
                                                            )
                                                        ],
                                                      );
                                                    }
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )

                                  ],
                                );
                              }
                          )
                      ),
                    ],
                  ),
                )
            ),
          ]
      ) :
      Center(child: Text('Veuillez attendre un instant !'),),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  searchAndNavigate() {
    GeocodingPlatform.instance.locationFromAddress(searchAdr).then((value) =>
    {
      mapController.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
              value[0].latitude, value[0].longitude
          ), zoom: 10)))
    });
  }

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition().then((Position position) {
      setState(() {
        current = position;
        FirebaseFirestore.instance.collection("courses").get().then((value) {
          value.docs.forEach((magasin) {
            FirebaseFirestore.instance.collection("courses").doc(magasin.id).collection("courses").get().then((qs)  {
              qs.docs.forEach((client) {
                FirebaseFirestore.instance.collection('clients').doc(client.id).get().then((clientdata) {
                  _markers.add(Marker(
                      markerId: MarkerId(Random().nextInt(1000).toString()),
                      position: LatLng(clientdata.data()[Food.clientLatitude], clientdata.data()[Food.clientLongitude]),
                      infoWindow: InfoWindow(
                          title: clientdata.data()[Food.clientName], snippet: "Adresse du client"),
                      icon: _clientIcon));
                });
              });
            });
            _markers.add(Marker(
                markerId: MarkerId(magasin.id),
                position: LatLng(double.parse(magasin.data()["srcLat"]),double.parse(magasin.data()["srcLong"])),
                infoWindow: InfoWindow(
                    title: magasin.data()[Food.restoName], snippet: "Bar / Magasin"),
                icon: _restoIcon));
          });

        });

        _markers.add(Marker(
            markerId: MarkerId("0"),
            position: LatLng(current.latitude, current.longitude),
            infoWindow: InfoWindow(
                title: "Vous etes ici", snippet: "Votre position"),
            icon: _markerIcon));
      });
    }).catchError((e) {
      print(e);
    }).then((value) => getAdresses()).catchError((e){print(e);}).then((value) {
      _calculateDistances();
    }).then((value) {
      setState(() {
        showMap=true;
      });
    });
  }
}
