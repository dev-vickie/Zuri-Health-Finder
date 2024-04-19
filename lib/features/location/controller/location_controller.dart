import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zuri_finder/features/location/repository/location_repository.dart';
import 'package:zuri_finder/features/location/screens/home_page.dart';
import 'package:zuri_finder/features/location/screens/hospital_info_screen.dart';
import 'package:zuri_finder/models/hospital_details_model.dart';
import 'package:zuri_finder/models/hospital_model.dart';

final userLocationProvider = StateProvider<Position?>((ref) {
  return null;
});

final polylineProvider = StateProvider<Polyline?>((ref) {
  return null;
});
final hospitalDetailsProvider = StateProvider<HospitalDetails?>((ref) {
  return null;
});

final hopitalsProvider = StreamProvider<List<Hospital>>((ref) {
  return ref.watch(locationControllerProvider.notifier).getHospitals(
        userLocation: ref.read(userLocationProvider)!,
      );
});

final locationControllerProvider =
    StateNotifierProvider<LocationController, bool>((ref) {
  return LocationController(
    locationRepository: ref.watch(locaionRepositoryProvider),
    ref: ref,
  );
});

class LocationController extends StateNotifier<bool> {
  final LocationRepository _locationRepository;
  final Ref _ref;

  LocationController(
      {required LocationRepository locationRepository, required Ref ref})
      : _locationRepository = locationRepository,
        _ref = ref,
        super(false);

  Future<void> getUserLocation(BuildContext context) async {
    state = true;
    final result = await _locationRepository.getUserLocation();
    result.fold(
      (error) {
        state = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      },
      (position) {
        state = false;
        _ref.read(userLocationProvider.notifier).update((state) => position);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      },
    );
  }

  Stream<List<Hospital>> getHospitals({
    required Position userLocation,
  }) {
    return _locationRepository.getHospitals(userLocation);
  }

  Future<void> getPolyline({
    required MarkerId markerId,
    required List<Hospital> hospitals,
    required Position userLocation,
  }) async {
    state = true;
    final result = await _locationRepository.onMarkerTapped(
      userLocation: userLocation,
      markerId: markerId,
      hospitals: hospitals,
    );
    state = false;
    result.fold(
      (error) {
        debugPrint("Error showing polyline: $error");
      },
      (polyline) {
        _ref.read(polylineProvider.notifier).update((state) => polyline);
      },
    );
  }

  Future<void> getHospitalDetails({
    required String placeId,
    required BuildContext context,
    required Hospital hospital,
  }) async {
    state = true;
    final result =
        await _locationRepository.getHospitalDetails(placeId: placeId);
    state = false;
    result.fold(
      (error) {
        debugPrint("Error getting hospital details: $error");
      },
      (hospitalDetails) {
        _ref
            .read(hospitalDetailsProvider.notifier)
            .update((state) => hospitalDetails);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HospitalInfoScreen(
              hospital: hospital,
              hospitalDetails: hospitalDetails,
            ),
          ),
        );
      },
    );
  }
}
