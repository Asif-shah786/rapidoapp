// import 'dart:async';
// import 'dart:math';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_map/flutter_map.dart';
// // import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_mapbox_navigation/library.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:latlong2/latlong.dart' as latlong;
//
// import 'package:geolocator/geolocator.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:rapidoo/Pages/Drawer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:location/location.dart' as l;
//
// // import 'package:rapidoo/googlemap/directions_repository.dart';
// import 'package:google_geocoding/google_geocoding.dart';
// // import 'package:rapidoo/main.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:location/location.dart' as l;
//
// import '../main.dart';
// import '../mapbox/directions_model.dart';
// import '../mapbox/helpers/custum_marker.dart';
// import '../mapbox/helpers/shared_prefs.dart';
//
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   sharedPreferences = await SharedPreferences.getInstance();
// //   await dotenv.load(fileName: "assets/config/.env");
// //   runApp(Home());
// //   if (defaultTargetPlatform == TargetPlatform.android) {
// //   }
// // }
// class MapSmaple extends StatefulWidget {
//   const MapSmaple({Key? key}) : super(key: key);
//
//   @override
//   State<MapSmaple> createState() => _MapSmapleState();
// }
//
// class _MapSmapleState extends State<MapSmaple> {
//   Completer<MapboxMapController> _controller = Completer();
//   String accessToken =  dotenv.env['MAPBOX_ACCESS_TOKEN']!;
//   Position? position;
//
//   late final CameraPosition? kGooglePlex = CameraPosition(
//     target: LatLng(position?.latitude ?? 37.42796133580664,
//         position?.longitude ?? -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   static final CameraPosition _kLake = const CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   Marker? _origin;
//   Marker? _destination;
//   Directions? _info;
//   int _symbolCount = 0;
//
//   var startaddress;
//   var startadresssolved;
//   var startplaceMark;
//   var startplacename;
//   var startsubLocality;
//   var startlocality;
//   var startadministrativeArea;
//   var startpostalCode;
//   var startcountry;
//   var startplaceaddress;
//
//   var endaddress;
//   var endadresssolved;
//   var endplaceMark;
//   var endplacename;
//   var endsubLocality;
//   var endlocality;
//   var endadministrativeArea;
//   var endpostalCode;
//   var endcountry;
//   var endplaceaddress;
//
//   bool located = false;
//
//   @override
//   Widget build(BuildContext context) {
//     print('I am in Sample Page Screen Asif');
//     return Scaffold(
//       drawer: const DrawerWidget(),
//       // appBar: AppBar(
//       //   backgroundColor: const Color.fromARGB(255, 225, 203, 1),
//       //   actions: [
//       //     if (_origin != null)
//       //       TextButton(
//       //         onPressed: () async {
//       //           final MapboxMapController controller = await _controller.future;
//       //           final target = _origin?._coordinate;
//       //           controller.animateCamera(
//       //             CameraUpdate.newCameraPosition(
//       //               CameraPosition(
//       //                 target: target!,
//       //                 zoom: 14.5,
//       //                 tilt: 50.0,
//       //               ),
//       //             ),
//       //           );
//       //         },
//       //         style: TextButton.styleFrom(
//       //           primary: Colors.green,
//       //           textStyle: const TextStyle(fontWeight: FontWeight.w600),
//       //         ),
//       //         child: const Text('ORIGIN'),
//       //       ),
//       //     if (_destination != null)
//       //       TextButton(
//       //         onPressed: () async {
//       //           final MapboxMapController controller = await _controller.future;
//       //           final target = _origin?._coordinate;
//       //           controller.animateCamera(
//       //             CameraUpdate.newCameraPosition(
//       //               CameraPosition(
//       //                 target: target!,
//       //                 // target: LatLng(_destination!._coordinate.latitude, _destination!._coordinate.longitude),
//       //                 zoom: 14.5,
//       //                 tilt: 50.0,
//       //               ),
//       //             ),
//       //           );
//       //         },
//       //         style: TextButton.styleFrom(
//       //           primary: Colors.blue,
//       //           textStyle: const TextStyle(fontWeight: FontWeight.w600),
//       //         ),
//       //         child: const Text('DEST'),
//       //       )
//       //   ],
//       // ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             color: Colors.red,
//             height: MediaQuery.of(context).size.shortestSide,
//             width: MediaQuery.of(context).size.width,
//             child: Stack(
//               alignment: Alignment.topRight,
//               children: [
//                 // FlutterMap(
//                 //   options: MapOptions(minZoom: 5, maxZoom: 16, zoom: 13),
//                 //   nonRotatedLayers: [
//                 //     TileLayerOptions(
//                 //       urlTemplate:'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
//                 //       additionalOptions: {
//                 //         'accessToken': dotenv.env['MAPBOX_ACCESS_TOKEN']!,
//                 //       }
//                 //     ),
//                 //   ],
//                 // ),
//                 MapboxOverlay(),
//                 MapboxMap(
//                   onMapLongClick: _onMapLongClickCallback,
//
//                   initialCameraPosition: kGooglePlex!,
//                   accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
//                   myLocationEnabled: true,
//                   onMapCreated: (MapboxMapController controller) {
//                     _controller.complete(controller);
//                   },
//                 ),
//                 if (_info != null)
//                   Positioned(
//                     top: 20.0,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 6.0,
//                         horizontal: 12.0,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.yellowAccent,
//                         borderRadius: BorderRadius.circular(20.0),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black26,
//                             offset: Offset(0, 2),
//                             blurRadius: 6.0,
//                           )
//                         ],
//                       ),
//                       child: Text(
//                         '${_info!.totalDistance}, ${_info!.totalDuration}',
//                         style: const TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20.0, right: 15),
//                   child: Container(
//                     height: 40,
//                     width: 40,
//                     color: Colors.white.withOpacity(0.75),
//                     child: IconButton(
//                       onPressed: getLocation,
//                       icon: const Icon(
//                         Icons.my_location,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (located == true)
//             Container(
//                 height: 90,
//                 width: MediaQuery.of(context).size.width - 20,
//                 child: Card(
//                     shape: const RoundedRectangleBorder(
//                         side: BorderSide(
//                           color: Colors.black,
//                           width: 1,
//                           style: BorderStyle.solid,
//                         ),
//                         borderRadius:
//                             const BorderRadius.all(const Radius.circular(20))),
//                     color: Colors.white,
//                     child: Row(
//                       children: [
//                         const SizedBox(
//                           width: 15,
//                         ),
//                         const Icon(
//                           Icons.circle,
//                           color: Color.fromARGB(255, 7, 80, 9),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           "${startplaceaddress}",
//                           style: const TextStyle(
//                               fontSize: 10, fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ))),
//           if (located == true)
//             Container(
//                 height: 90,
//                 width: MediaQuery.of(context).size.width - 20,
//                 child: Card(
//                     shape: const RoundedRectangleBorder(
//                         side: const BorderSide(
//                           color: Colors.black,
//                           width: 1,
//                           style: BorderStyle.solid,
//                         ),
//                         borderRadius:
//                             const BorderRadius.all(const Radius.circular(20))),
//                     color: Colors.white,
//                     child: Row(
//                       children: [
//                         const SizedBox(
//                           width: 15,
//                         ),
//                         const Icon(
//                           Icons.circle,
//                           color: Colors.red,
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           "${endplaceaddress}",
//                           style: const TextStyle(
//                               fontSize: 10, fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ))),
//           if (located == true)
//             TextButton(
//               style: TextButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 26, 26, 26)),
//               onPressed: () {},
//               child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Column(children: [
//                     const SizedBox(
//                       height: 3,
//                     ),
//                     const Icon(Icons.directions_bike, color: Colors.yellow),
//                     const Text(
//                       "Ride",
//                       style: TextStyle(color: Colors.yellow),
//                     )
//                   ])),
//             ),
//           if (located == false)
//             const Padding(
//               padding: EdgeInsets.only(
//                 bottom: 130.0,
//               ),
//               child: Text(
//                 "Choose Your Start Location from the Map to Get Started!",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.grey, fontSize: 20),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   void _onMapLongClickCallback(Point<double> point, LatLng coordinates) {
//     print('LongPress Called');
//     _addMarker(point, coordinates);
//   }
//
//   void _addMarker(Point<double> point, LatLng coordinates) async {
//     final MapboxMapController controller = await _controller.future;
//     controller.addSymbol(
//       SymbolOptions(
//         geometry: LatLng(
//           coordinates.latitude,
//           coordinates.longitude,
//         ),
//         iconImage: 'assets/symbols/2.0x/custom-icon.png',
//       ),
//     );
//     setState(() {
//       _symbolCount += 1;
//     });
//     // setState(() {
//     //   _markers.add(Marker(_rnd.nextInt(100000).toString(), coordinates, point,
//     //       _addMarkerStates));
//     //   print('Markers Length : ${_markers.length}');
//     // });
//   }
//
//   Future<void> _goToOriginalP() async {
//     final MapboxMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex!));
//   }
//
//   // void getLocation() async {
//   //   final MapboxMapController controller = await _controller.future;
//   //
//   //   l.Location currentLocation = l.Location();
//   //   Set<Marker> _marker = {};
//   //   var location = await currentLocation.getLocation();
//   //   currentLocation.onLocationChanged.listen((l.LocationData loc) {
//   //     controller
//   //         ?.animateCamera(CameraUpdate.newCameraPosition( CameraPosition(
//   //       target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
//   //       zoom: 12.0,
//   //     )));
//   //     print(loc.latitude);
//   //     print(loc.longitude);
//   //     setState(() {
//   //       _marker.add(
//   //
//   //           Marker(
//   //         markerId: const MarkerId("Home"),
//   //         position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
//   //         visible: true,
//   //         icon: BitmapDescriptor.defaultMarker,
//   //             builder: (BuildContext context) {
//   //
//   //             },
//   //       )
//   //
//   //       );
//   //     });
//   //   });
//   //
//   //   void initState() {
//   //     super.initState();
//   //     setState(() {
//   //       getLocation();
//   //     });
//   //   }
//   // }
//   void getLocation() async {
//     final MapboxMapController controller = await _controller.future;
//     l.Location currentLocation = l.Location();
//     Set _marker = {};
//     var location = await currentLocation.getLocation();
//     currentLocation.onLocationChanged.listen((l.LocationData loc) {
//       controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
//         zoom: 12.0,
//       )));
//       print(loc.latitude);
//       print(loc.longitude);
//       setState(() {
//         _marker.add(
//           controller.addSymbol(
//             SymbolOptions(
//               geometry: LatLng(
//                 loc.latitude!,
//                 loc.longitude!,
//               ),
//               iconImage: 'assets/symbols/2.0x/custom-icon.png',
//             ),
//           ),
//         );
//       });
//
//       void initState() {
//         super.initState();
//         setState(() {
//           getLocation();
//         });
//       }
//     });
//   }
//
//   // LatLng(_origin!.point.latitude, _origin!.point.longitude),
//   // Marker(
//   //   width: 80.0,
//   //   height: 80.0,
//   //   point: latlong.LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
//   //   builder: (ctx) =>
//   //   Container(
//   //     child: IconButton(
//   //       icon: Icon(Icons.location_on),
//   //       color: Colors.blue,
//   //       iconSize: 45.0,
//   //       onPressed: () {
//   //         print('Home Marker tapped');
//   //       },
//   //     ),
//   //   ),
//   // ),
//   // Marker(
//   //   markerId: const MarkerId("Home"),
//   //   position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
//   //   visible: true,
//   //   icon: BitmapDescriptor.defaultMarker,
//   //   builder: (BuildContext context) {
//   //
//   //   },
//
//   //
//   // void _add(String iconImage) {
//   //   controller.addSymbol(
//   //     SymbolOptions(
//   //       geometry: LatLng(
//   //         center.latitude,
//   //         center.longitude,
//   //       ),
//   //       iconImage: iconImage,
//   //     ),
//   //   );
//   //   setState(() {
//   //     _symbolCount += 1;
//   //   });
//   // }
//
//   // void AddMaker(point, LatLng pos) async {
//   //   print('long Pressed AddMarker Called ');
//   //   located = true;
//   //   if (_origin == null || (_origin != null && _destination != null)) {
//   //     setState(() {});
//   //     _origin =
//   //         // Marker(
//   //         // markerId: const MarkerId("origin"),
//   //         // infoWindow: const InfoWindow(title: "Origin"),
//   //         // icon:
//   //         // BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//   //         // position: pos);
//   //     Marker(
//   //       width: 80.0,
//   //       height: 80.0,
//   //       point: latlong.LatLng(pos.latitude ?? 0.0, pos.longitude ?? 0.0),
//   //       builder: (ctx) =>
//   //           Container(
//   //             child: IconButton(
//   //               icon: Icon(Icons.location_on),
//   //               color: Colors.blue,
//   //               iconSize: 45.0,
//   //               onPressed: () {
//   //                 print('Origin Marker tapped');
//   //               },
//   //             ),
//   //           ),
//   //     );
//   //     _destination = null;
//   //     _info = null;
//   //
//   //     startaddress = await placemarkFromCoordinates(
//   //       _origin!.point.latitude,
//   //       _origin!.point.longitude,
//   //     );
//   //     startplaceMark = startaddress[0];
//   //     startplacename = startplaceMark.name;
//   //     startsubLocality = startplaceMark.subLocality;
//   //     startlocality = startplaceMark.locality;
//   //     startadministrativeArea = startplaceMark.administrativeArea;
//   //     startpostalCode = startplaceMark.postalCode;
//   //     startcountry = startplaceMark.country;
//   //     startplaceaddress =
//   //     "${startplacename} ${startsubLocality}, ${startlocality}, ${startadministrativeArea} ${startpostalCode}, ${startcountry}";
//   //   } else {
//   //
//   //     setState(() {
//   //       _destination =
//   //           Marker(
//   //             width: 80.0,
//   //             height: 80.0,
//   //             point: latlong.LatLng(pos.latitude ?? 0.0, pos.longitude ?? 0.0),
//   //             builder: (ctx) =>
//   //                 Container(
//   //                   child: IconButton(
//   //                     icon: Icon(Icons.location_on),
//   //                     color: Colors.blue,
//   //                     iconSize: 45.0,
//   //                     onPressed: () {
//   //                       print('Destination Marker tapped');
//   //                     },
//   //                   ),
//   //                 ),
//   //           );
//   //
//   //           // Marker(
//   //           // markerId: const MarkerId("destination"),
//   //           // infoWindow: const InfoWindow(title: "Destination"),
//   //           // icon: BitmapDescriptor.defaultMarkerWithHue(
//   //           //     BitmapDescriptor.hueBlue),
//   //           // position: pos);
//   //     });
//   //
//   //     endaddress = await placemarkFromCoordinates(
//   //       _destination!.point.latitude,
//   //       _destination!.point.longitude,
//   //     );
//   //     endplaceMark = endaddress[0];
//   //     endplacename = endplaceMark.name;
//   //     endsubLocality = endplaceMark.subLocality;
//   //     endlocality = endplaceMark.locality;
//   //     endadministrativeArea = endplaceMark.administrativeArea;
//   //     endpostalCode = endplaceMark.postalCode;
//   //     endcountry = endplaceMark.country;
//   //     endplaceaddress =
//   //     "${endplacename} ${endsubLocality}, ${endlocality}, ${endadministrativeArea} ${endpostalCode}, ${endcountry}";
//   //   }
//   //
//   //
//   // }
// }
//
// class Marker extends StatefulWidget {
//   final Point _initialPosition;
//   final LatLng _coordinate;
//   final void Function(_MarkerState) _addMarkerState;
//
//   Marker(
//       String key, this._coordinate, this._initialPosition, this._addMarkerState)
//       : super(key: Key(key));
//
//   @override
//   State<StatefulWidget> createState() {
//     final state = _MarkerState(_initialPosition);
//     _addMarkerState(state);
//     return state;
//   }
// }
//
// class _MarkerState extends State with TickerProviderStateMixin {
//   final _iconSize = 20.0;
//
//   Point _position;
//
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   _MarkerState(this._position);
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.elasticOut,
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var ratio = 1.0;
//
//     //web does not support Platform._operatingSystem
//     // if (!kIsWeb) {
//     //   // iOS returns logical pixel while Android returns screen pixel
//     //   ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
//     // }
//
//     return Positioned(
//         left: _position.x / ratio - _iconSize / 2,
//         top: _position.y / ratio - _iconSize / 2,
//         child: RotationTransition(
//             turns: _animation,
//             child: Image.asset('assets/symbols/2.0x/custom-icon.png',
//                 height: _iconSize)));
//   }
//
//   void updatePosition(Point<num> point) {
//     setState(() {
//       _position = point;
//     });
//   }
//
//   LatLng getCoordinate() {
//     return (widget as Marker)._coordinate;
//   }
// }
