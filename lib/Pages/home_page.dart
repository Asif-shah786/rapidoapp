import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rapido_app/Pages/Drawer.dart';
import 'package:location/location.dart' as l;
import 'package:latlong2/latlong.dart';
import 'package:rapido_app/mapboxmap/directions_repository.dart';

import '../mapboxmap/directions_model.dart';


class MapPage extends StatefulWidget {
  const MapPage( {Key? key, }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin{
  Completer<MapController> _controller = Completer();

  String accessToken =  dotenv.env['MAPBOX_ACCESS_TOKEN']!;
  Position? position;
  final currentPosition = LatLng(33.9812114, 72.90919819999999 );

  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  var startaddress;
  var startadresssolved;
  var startplaceMark;
  var startplacename;
  var startsubLocality;
  var startlocality;
  var startadministrativeArea;
  var startpostalCode;
  var startcountry;
  var startplaceaddress;

  var endaddress;
  var endadresssolved;
  var endplaceMark;
  var endplacename;
  var endsubLocality;
  var endlocality;
  var endadministrativeArea;
  var endpostalCode;
  var endcountry;
  var endplaceaddress;

  bool located = false;
  @override
  Widget build(BuildContext context) {

    var markers = <Marker>[
        if (_origin != null) _origin!,
        if (_destination != null) _destination!
      ];

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 203, 1),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () {
                _animatedMapMove(LatLng(_origin?.point.latitude ?? currentPosition.latitude, _origin?.point.longitude ?? currentPosition.longitude) , 13.0);
              },
              style: TextButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () {
                _animatedMapMove(LatLng(_destination?.point.latitude ?? currentPosition.latitude,
                    _destination?.point.longitude ?? currentPosition.longitude) , 13.0);
              },
              style: TextButton.styleFrom(
                primary: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: Colors.red,
            height: MediaQuery.of(context).size.shortestSide,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                FlutterMap(
                  options: MapOptions(
                   minZoom: 5, maxZoom: 16, zoom: 13,
                  center: _SetCenter(),
                  onMapCreated: (MapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (tapPosition , pos) async {
                    located = true;
                    if (_origin == null || (_origin != null && _destination != null)) {
                      setState(() {});
                        _origin = Marker(
                          point: LatLng(pos.latitude, pos.longitude),
                          builder: (_) =>
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset('assets/symbols/2.0x/red_marker.png',color: Color(0xff021D13)),
                              ),);
                        _destination = null;
                        _info = null;

                      startaddress = await placemarkFromCoordinates(
                        _origin!.point.latitude,
                        _origin!.point.longitude,
                      );
                      startplaceMark = startaddress[0];
                      startplacename = startplaceMark.name;
                      startsubLocality = startplaceMark.subLocality;
                      startlocality = startplaceMark.locality;
                      startadministrativeArea = startplaceMark.administrativeArea;
                      startpostalCode = startplaceMark.postalCode;
                      startcountry = startplaceMark.country;
                      startplaceaddress =
                      "${startplacename} ${startsubLocality}, ${startlocality}, ${startadministrativeArea} ${startpostalCode}, ${startcountry}";
                    } else {
                      setState(() {
                        _destination = Marker(
                          point: LatLng(pos.latitude, pos.longitude),
                          builder: (_) =>
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset('assets/symbols/2.0x/red_marker.png',color:Colors.red),
                              ),);
                      });

                      final originPoint = _origin?.point;
                      final destinationPoint = _destination?.point;
                      print('${originPoint?.longitude},${originPoint?.latitude};${destinationPoint?.longitude},${destinationPoint?.latitude}');
                      final directions = await DirectionsRepository().getDirections(origin: originPoint!, destination: destinationPoint!);
                      setState(() => _info = directions );

                      endaddress = await placemarkFromCoordinates(
                        _destination!.point.latitude,
                        _destination!.point.longitude,
                      );
                      endplaceMark = endaddress[0];
                      endplacename = endplaceMark.name;
                      endsubLocality = endplaceMark.subLocality;
                      endlocality = endplaceMark.locality;
                      endadministrativeArea = endplaceMark.administrativeArea;
                      endpostalCode = endplaceMark.postalCode;
                      endcountry = endplaceMark.country;
                      endplaceaddress =
                      "${endplacename} ${endsubLocality}, ${endlocality}, ${endadministrativeArea} ${endpostalCode}, ${endcountry}";
                    }
                  },
                  ),
                  nonRotatedLayers: [
                    TileLayerOptions(
                      urlTemplate: "https://api.mapbox.com/styles/v1/rapidoapp786/cl3ft5oms000p14rtbadwxy9y/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                      additionalOptions: {
                        'accessToken': accessToken,
                        'id': 'mapbox.mapbox-streets-v8',
                      },
                      tileProvider: const NonCachingNetworkTileProvider(),
                    ),
                    MarkerLayerOptions(
                        markers: markers,
                    ),
                    //This Code is Not working as Intended
                    PolylineLayerOptions(
                      polylines: [
                        if(_info!=null)
                        Polyline(
                            points: _info?.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList() ?? [ LatLng(72.91999, 33.991335), LatLng(72.920236, 33.991537), LatLng(72.920691, 33.991544)],
                            strokeWidth: 5.0,
                            color: Colors.red),
                      ],
                    ),
                  ],
                ),
                if (_info != null)
                Positioned(
                    top: 20.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                      child: Text(
                        '${_info!.totalDistance}, ${_info!.totalDuration}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 13),
                  child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.white.withOpacity(0.75),
                    child: IconButton(
                      onPressed: (){
                          getLocation();
                      },
                      icon: const Icon(
                        Icons.my_location,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (located == true)
            Container(
                height: 80,
                width: MediaQuery.of(context).size.width - 20,
                child: Card(
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: const BorderRadius.all(const Radius.circular(20))),
                    color: Colors.white,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 13,
                        ),
                        const Icon(
                          Icons.circle,
                          color: Color.fromARGB(255, 7, 80, 9),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            "${_origin == null ? 'select origin' : startplaceaddress}",style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ))),
          if (located == true)
            Container(
                height: 90,
                width: MediaQuery.of(context).size.width - 20,
                child: Card(
                    shape: const RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: const BorderRadius.all(const Radius.circular(20))),
                    color: Colors.white,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 13,
                        ),
                        const Icon(
                          Icons.circle,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            "${_destination==null? 'Select destination' :endplaceaddress}",style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ))),
          if (located == true)
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 26, 26, 26)),
              onPressed: () {
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    const SizedBox(
                      height: 3,
                    ),
                    const Icon(Icons.directions_bike, color: Colors.yellow),
                    const Text(
                      "Ride",
                      style: TextStyle(color: Colors.yellow),
                    )
                  ])),
            ),
          if (located == false)
            const Padding(
              padding: EdgeInsets.only(
                bottom: 130.0,
              ),
              child: Text(
                "Choose Your Start Location from the Map to Get Started!",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 20),
              ),
            ),
        ],
      ),
    );
  }
//Setting Camera Position when Current Position changes
  LatLng _SetCenter() {
    LatLng? center = LatLng(currentPosition.latitude, currentPosition.longitude);
    if(_origin != null){
      center = _origin?.point;
      return center!;
    }
    else if(_destination!= null){
      center = _destination?.point;
      return center!;
    }
    else{
      return LatLng(center.latitude, center.longitude);
    }

  }
// Method that uses location plugin
  void getLocation() async {
    located = true;
    l.Location currentLocation = l.Location();
    var location = await currentLocation.getLocation();
    print('Current Location : ${location.longitude} ${location.latitude}');
    setState(() {
      _origin = Marker(
        point: LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0),
        builder: (_) =>
            SizedBox(
              width: 20,
              height: 20,
              child: Image.asset('assets/symbols/2.0x/red_marker.png',color: Colors.blue,),
            ),);
      _animatedMapMove(LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0), 13);
    });
  }

  void _animatedMapMove(LatLng destLocation, double destZoom ) async {
    final MapController _mController = await _controller.future;
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: _mController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.addListener(() {
      _mController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }

}