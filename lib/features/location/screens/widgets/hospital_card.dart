import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuri_finder/features/location/controller/location_controller.dart';
import 'package:zuri_finder/models/hospital_model.dart';
import 'package:zuri_finder/utils/constants.dart';

class HospitalCard extends ConsumerWidget {
  final Hospital hospital;
  const HospitalCard({super.key, required this.hospital});
  Widget hospitalPhotoViewer(List<Photo> photos) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        "${Constants.PLACE_PHOTO}/photo?photoreference=${photos[0].photoReference}&sensor=false&maxheight=${photos[0].height}&maxwidth=${photos[0].width}&key=${Constants.API_KEY}",
        fit: BoxFit.cover,
        height: 100,
        width: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(locationControllerProvider.notifier).getHospitalDetails(
              placeId: hospital.placeId,
              context: context,
              hospital: hospital,
            );
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              hospital.photos != null
                  ? hospitalPhotoViewer(hospital.photos!)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        Constants.HOSPITAL_ICON,
                        height: 100,
                        width: 100,
                      ),
                    ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Text(
                            hospital.vicinity,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                      ),
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.cyan),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.cyan,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            hospital.rating.toString(),
                            style: const TextStyle(
                              color: Colors.cyan,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
