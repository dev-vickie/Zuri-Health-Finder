import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:zuri_finder/models/hospital_details_model.dart';
import 'package:zuri_finder/models/hospital_model.dart';
import 'package:http/http.dart' as http;
import 'package:zuri_finder/utils/constants.dart';

typedef FutureEither<T> = Future<Either<String, T>>;

final locaionRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository();
});

class LocationRepository {
  //Check for location permission and get user location
  FutureEither<Position> getUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return left('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return left(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return left(
            'Please enable location services to allow us to determine your location.',
          );
        }
      }
      final Position position = await Geolocator.getCurrentPosition();

      return right(position);
    } catch (e) {
      return left('An error occurred: $e');
    }
  }

  //Get hospitals near user's location
  Stream<List<Hospital>> getHospitals(Position userLocation) async* {
    try {
      final String url =
          "${Constants.PLACES_API_PATH}/json?keyword=hospital&location=${userLocation.latitude},${userLocation.longitude}&radius=2000&type=hospital&key=${Constants.API_KEY}";
      final res = await http.get(Uri.parse(url));
      debugPrint(res.body);
      if (res.statusCode == 200) {
        final List<Hospital> hospitals =
            (jsonDecode(res.body)['results'] as List)
                .map((e) => Hospital.fromMap(e as Map<String, dynamic>))
                .toList();
        debugPrint(hospitals.toString());
        yield hospitals;
      } else {
        throw Exception('An error occurred: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  //Plot a polyline when user clicks hospital marker on the map
  FutureEither<Polyline> onMarkerTapped({
    required MarkerId markerId,
    required List<Hospital> hospitals,
    required Position userLocation,
  }) async {
    try {
      final hospital =
          hospitals.firstWhere((hospital) => hospital.name == markerId.value);
      final polylinePoints = PolylinePoints();
      final result = await polylinePoints.getRouteBetweenCoordinates(
        Constants.API_KEY,
        PointLatLng(userLocation.latitude, userLocation.longitude),
        PointLatLng(
            hospital.geometry.location.lat, hospital.geometry.location.lng),
      );
      if (result.points.isNotEmpty) {
        final polyline = Polyline(
          polylineId: const PolylineId('polyline'),
          color: Colors.red,
          points: result.points
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList(),
          width: 3,
        );

        return right(polyline);
      } else {
        debugPrint("Empty polyline");
      }
      return left('An error occurred');
    } catch (error) {
      return left('An error occurred: $error');
    }
  }

  //Get the details of one hospital using it's place_id
  FutureEither<HospitalDetails> getHospitalDetails(
      {required String placeId}) async {
    try {
      String url =
          "${Constants.PLACE_DETAILS}/$placeId?fields=*&key=${Constants.API_KEY}";
      final res = await http.get(Uri.parse(url));
      debugPrint(res.body);
      if (res.statusCode == 200) {
        final HospitalDetails hospitalDetails =
            HospitalDetails.fromMap(jsonDecode(res.body));

        return right(hospitalDetails);
      } else {
        return left('An error occurred: ${res.statusCode}');
      }
    } catch (e) {
      return left('An error occurred: $e');
    }
  }
}
