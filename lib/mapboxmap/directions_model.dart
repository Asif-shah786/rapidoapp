import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';

class Directions {
  final LatLngBounds bounds;
  final List<LatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  const Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    

    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    print('DATA : \n $data');
    // // Bounds
    // final northeast = map['waypoints'][0]['location'][0]
    // final northeast = data['bounds']['northeast'];
    // final southwest = data['bounds']['southwest'];
    //
    // final bounds = LatLngBounds(
    //   northeast,southwest
    // );
    print('Start:');
  print(map['waypoints'][0]['location'][0]);
  print('End');
  print( map['waypoints'][0]['location'][1]);
    final bounds = LatLngBounds(
      LatLng(map['waypoints'][0]['location'][0], map['waypoints'][0]['location'][1]),
      LatLng(map['waypoints'][1]['location'][0], map['waypoints'][1]['location'][1]),);

    // Distance & Duration
    String distance = data['duration'].toString();
    String duration = data['distance'].toString();
    // if ((data['legs'] as List).isNotEmpty) {
    //   final leg = data['legs'][0];
    //   distance = leg['distance']['text'];
    //   duration = leg['duration']['text'];
    // }
    print('list starts');
  print(data['geometry']['coordinates'][0]); print('list ends');
  final List pointsList = data['geometry']['coordinates'];
  print('point list : $pointsList');
  List<LatLng> polylinePoints = [];

  pointsList.forEach((element) {
    polylinePoints.add(LatLng(element[0], element[1]));
  });
  print(polylinePoints);
  print('polypoinbt 0');
  print(polylinePoints[0]);
    return Directions(
      bounds: bounds,
      polylinePoints:polylinePoints,
          // PolylinePoints().decodePolyline(data['geometry']['coordinates']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}