import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuri_finder/features/location/controller/location_controller.dart';
import 'package:zuri_finder/features/location/screens/widgets/hospital_card.dart';
import 'package:zuri_finder/models/hospital_model.dart';

class HospitalList extends ConsumerStatefulWidget {
  const HospitalList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HospitalListState();
}

class _HospitalListState extends ConsumerState<HospitalList> {
  final searchController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  List<Hospital> filteredHospitals = [];
  bool isSearching = false;

  void filterHospitals(String keyword, List<Hospital> hospitals) {
    setState(() {
      if (keyword.isNotEmpty) {
        filteredHospitals = hospitals
            .where((hospital) =>
                hospital.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      } else {
        filteredHospitals = hospitals;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //request focus for search textfield
    _textFieldFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(locationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Hospitals'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          isLoading ? const LinearProgressIndicator() : const SizedBox(),
          Expanded(
            child: ref.watch(hopitalsProvider).when(
                  data: (hospitals) {
                    if (hospitals.isEmpty) {
                      return const Center(
                        child: Text(
                            "There are no hospitals available within your location"),
                      );
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                elevation: 3.0,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    debugPrint('tapped');
                                    _textFieldFocusNode.requestFocus();
                                  },
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Container(
                                  height: 45,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 3.0,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          focusNode: _textFieldFocusNode,
                                          controller: searchController,
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                            searchController.clear();
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '  Search',
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                searchController.clear();
                                                setState(() {
                                                  isSearching = false;
                                                  //pop the keyboard
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                });
                                              },
                                              icon: const Icon(Icons.clear),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              isSearching = value.isNotEmpty;
                                            });
                                            filterHospitals(value, hospitals);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        isSearching
                            ? filteredHospitals.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: filteredHospitals.length,
                                      itemBuilder: (context, index) {
                                        return HospitalCard(
                                          hospital: filteredHospitals[index],
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                        "This hospital is not found near you"))
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: hospitals.length,
                                  itemBuilder: (context, index) {
                                    final hospital = hospitals[index];
                                    return HospitalCard(hospital: hospital);
                                  },
                                ),
                              ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
