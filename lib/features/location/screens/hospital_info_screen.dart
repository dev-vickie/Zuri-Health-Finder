import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuri_finder/features/location/screens/widgets/review_card.dart';
import 'package:zuri_finder/models/hospital_details_model.dart';
import 'package:zuri_finder/models/hospital_model.dart';
import 'package:zuri_finder/utils/constants.dart';

class HospitalInfoScreen extends ConsumerStatefulWidget {
  final HospitalDetails hospitalDetails;
  final Hospital hospital;
  const HospitalInfoScreen({
    super.key,
    required this.hospital,
    required this.hospitalDetails,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HospitalInfoScreenState();
}

class _HospitalInfoScreenState extends ConsumerState<HospitalInfoScreen> {
  String getPhotoReference(String name, String placeId) {
    RegExp regExp = RegExp('^places/$placeId/photos/');
    final photoReference = name.replaceFirst(regExp, '');
    return photoReference;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(widget.hospital.name),
          centerTitle: true,
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  child: widget.hospitalDetails.photos != null
                      ? Image.network(
                          "${Constants.PLACE_PHOTO}/photo?photoreference=${getPhotoReference(widget.hospital.photos![0].photoReference, widget.hospital.placeId)}&sensor=false&maxheight=${widget.hospital.photos![0].height}&maxwidth=${widget.hospital.photos![0].width}&key=${Constants.API_KEY}",
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          Constants.HOSPITAL_ICON,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.cyan,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.hospitalDetails.shortFormattedAddress ??
                                'N/A',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(
                    text: 'Details',
                  ),
                  Tab(
                    text: 'Reviews',
                  ),
                  Tab(
                    text: 'Photos',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: TabBarView(
                  children: [
                    Card(
                      child: ListView(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.phone,
                              color: Colors.cyan,
                            ),
                            title: const Text('Phone Number'),
                            subtitle: Text(
                              widget.hospitalDetails.internationalPhoneNumber ??
                                  'N/A',
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.star_border_outlined,
                              color: Colors.cyan,
                            ),
                            title: const Text('Rating'),
                            subtitle: Text(
                              widget.hospitalDetails.rating.toString(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.access_time_rounded,
                              color: widget.hospitalDetails.currentOpeningHours
                                          ?.openNow ==
                                      true
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: const Text('Status'),
                            subtitle: Text(
                              widget.hospitalDetails.currentOpeningHours
                                          ?.openNow ==
                                      true
                                  ? 'Open'
                                  : 'Closed',
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.hospitalDetails.reviews == null
                        ? const Center(
                            child: Text('No Reviews Available'),
                          )
                        : widget.hospitalDetails.reviews!.isEmpty
                            ? const Center(
                                child: Text('No Reviews Available'),
                              )
                            : ListView.builder(
                                itemCount:
                                    widget.hospitalDetails.reviews?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return ReviewCard(
                                    reviews:
                                        widget.hospitalDetails.reviews![index],
                                  );
                                },
                              ),
                    widget.hospitalDetails.photos == null
                        ? const Center(
                            child: Text('No Photos Available'),
                          )
                        : widget.hospitalDetails.photos!.isEmpty
                            ? const Center(
                                child: Text('No Photos Available'),
                              )
                            : ListView.builder(
                                itemCount:
                                    widget.hospitalDetails.photos!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: Colors.grey[300],
                                    margin: const EdgeInsets.all(5),
                                    height: 200,
                                    child: Image.network(
                                      "${Constants.PLACE_PHOTO}/photo?photoreference=${getPhotoReference(widget.hospitalDetails.photos![index].name!, widget.hospital.placeId)}&sensor=false&maxheight=${widget.hospitalDetails.photos![index].heightPx}&maxwidth=${widget.hospitalDetails.photos![index].widthPx}&key=${Constants.API_KEY}",
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
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
