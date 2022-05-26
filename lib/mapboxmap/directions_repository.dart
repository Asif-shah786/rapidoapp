import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
//import 'package:rapidoo/googlemap/.env.dart';

import 'directions_model.dart';
String accessToken =  dotenv.env['MAPBOX_ACCESS_TOKEN']!;

class DirectionsRepository {
  static const String _baseUrl =
      'https://api.mapbox.com/directions/v5/mapbox/cycling/';
  // https://maps.googleapis.com/maps/api/directions/json?
  //
  // https://api.mapbox.com/directions/v5/mapbox/cycling/-84.518641,39.134270;-84.512023,39.102779?geometries=geojson
  // &access_token =pk.eyJ1IjoicmFwaWRvYXBwNzg2IiwiYSI6ImNsM2NlMXpxNzBrZWozaXA0Z3R3Y2hkdGwifQ.-nbN0ulPsCN0tdpNo6BKDg
  //  final Dio _dio;
  //
  //
  // https://maps.googleapis.com/maps/api/directions/json ?origin =Disneyland &destination =Universal+Studios+Hollywood &key =YOUR_API_KEY

  final Dio _dio;
  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    //-84.518641,39.134270
    //-84.512023,39.102779
    // final response = await _dio.get('https://api.mapbox.com/directions/v5/mapbox/driving/${origin.latitude},${origin.longitude};${destination.latitude},${destination.longitude}?'
    //     'geometries=geojson&access_token=$accessToken');
    //
    final response = await _dio.get('https://api.mapbox.com/directions/v5/mapbox/driving/72.91989842583007%2C33.991412193943844%3B72.90542164970704%2C33.981163951586254?alternatives=true&geometries=geojson&language=en&overview=simplified&steps=true&access_token=pk.eyJ1IjoicmFwaWRvYXBwNzg2IiwiYSI6ImNsM2NlMXpxNzBrZWozaXA0Z3R3Y2hkdGwifQ.-nbN0ulPsCN0tdpNo6BKDg');
    print('DIO RESPONSE ');
    print(response);

    // final response = await _dio.get(
    //   _baseUrl+'${origin.latitude},${origin.longitude};${destination.latitude},${destination.longitude}',
    //   queryParameters: {
    //     // 'origin': '${origin.latitude},${origin.longitude}',
    //     // 'destination': '${destination.latitude},${destination.longitude}',
    //     'accessToken': accessToken,
    //   },
    // );

    // Check if response is successful
    print(response.statusCode);
    if (response.statusCode == 200) {
      // print(response);
      return Directions.fromMap(response.data);
    }
    return null!;
  }
}