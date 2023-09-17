import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lab3_test/.env.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Models/directions_model.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
     LatLng? origin,
     LatLng? destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin?.latitude},${origin?.longitude}',
        'destination': '${destination?.latitude},${destination?.longitude}',
        'key': googleAPIKey,
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return Directions.fromMap(response.data);

   //  return null;
  }
}