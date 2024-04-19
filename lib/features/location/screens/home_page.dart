import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zuri_finder/features/location/controller/location_controller.dart';
import 'package:zuri_finder/features/location/screens/hospital_list.dart';
import 'package:zuri_finder/features/location/screens/widgets/hospital_card.dart';
import 'package:zuri_finder/utils/constants.dart';

import '../../../models/hospital_model.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  Future<BitmapDescriptor> _getMarkerIcon() async {
    final ByteData byteData =
        await rootBundle.load(Constants.HOSPITAL_MAP_ICON);
    final Uint8List bytes = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  void _onMarkerTapped(MarkerId markerId, List<Hospital> hospitals) async {
    ref.read(locationControllerProvider.notifier).getPolyline(
          markerId: markerId,
          hospitals: hospitals,
          userLocation: ref.read(userLocationProvider)!,
        );
  }

  void _onMapCreated(GoogleMapController controller, List<Hospital> hospitals) {
    final userLocation = ref.watch(userLocationProvider)!;
    _markers.add(Marker(
      markerId: const MarkerId('user'),
      position: LatLng(userLocation.latitude, userLocation.longitude),
      infoWindow: const InfoWindow(title: 'Your Location'),
      icon: BitmapDescriptor.defaultMarker,
    ));
    _controller.complete(controller);

    _getMarkerIcon().then((icon) {
      setState(() {
        for (var hospital in hospitals) {
          _markers.add(
            Marker(
              markerId: MarkerId(hospital.name),
              position: LatLng(hospital.geometry.location.lat,
                  hospital.geometry.location.lng),
              infoWindow: InfoWindow(
                title: hospital.name,
                snippet: hospital.vicinity,
              ),
              onTap: () => _onMarkerTapped(MarkerId(hospital.name), hospitals),
              icon: icon,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(userLocationProvider)!;
    final polyline = ref.watch(polylineProvider);
    final bool isLoading = ref.watch(locationControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitals Near You'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: ref.watch(hopitalsProvider).when(
            data: (hospitals) {
              return Stack(
                children: <Widget>[
                  GoogleMap(
                    polylines: polyline != null ? {polyline} : <Polyline>{},
                    onMapCreated: (controller) =>
                        _onMapCreated(controller, hospitals),
                    initialCameraPosition: CameraPosition(
                      target:
                          LatLng(userLocation.latitude, userLocation.longitude),
                      zoom: 15,
                    ),
                    markers: _markers,
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    minChildSize: 0.1,
                    maxChildSize: 0.7,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              height: 5,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: hospitals.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final hospital = hospitals[index];
                                  return HospitalCard(hospital: hospital);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  isLoading
                      ? const LinearProgressIndicator()
                      : const Offstage(),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HospitalList(),
                                ),
                              );
                            },
                            readOnly: true,
                            decoration: const InputDecoration(
                              hintText: 'Search for a hospital',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const Icon(Icons.search),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
    );
  }
}
