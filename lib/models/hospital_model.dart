// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Hospital {
  final String name;
  final String vicinity;
  final String placeId;
  final Geometry geometry;
  final List<Photo>? photos;
  final num rating;

  Hospital({
    required this.name,
    required this.vicinity,
    required this.placeId,
    required this.geometry,
    this.photos,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'vicinity': vicinity,
      'place_id': placeId,
      'geometry': geometry.toMap(),
      'photos': photos?.map((x) => x.toMap()).toList(),
      'rating': rating,
    };
  }

  factory Hospital.fromMap(Map<String, dynamic> map) {
    return Hospital(
      name: map['name'] as String,
      vicinity: map['vicinity'] as String,
      placeId: map['place_id'] as String,
      geometry: Geometry.fromMap(map['geometry'] as Map<String, dynamic>),
      photos: map['photos'] != null
          ? List<Photo>.from(
              (map['photos'] as List).map<Photo?>(
                (x) => Photo.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      rating: map['rating'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory Hospital.fromJson(String source) =>
      Hospital.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Geometry {
  final Location location;

  Geometry({required this.location});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location.toMap(),
    };
  }

  factory Geometry.fromMap(Map<String, dynamic> map) {
    return Geometry(
      location: Location.fromMap(map['location'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Geometry.fromJson(String source) =>
      Geometry.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lng': lng,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      lat: map['lat'] as double,
      lng: map['lng'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Photo {
  final int height;
  final int width;
  final String photoReference;

  Photo({
    required this.height,
    required this.width,
    required this.photoReference,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'height': height,
      'width': width,
      'photo_reference': photoReference,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      height: map['height'] as int,
      width: map['width'] as int,
      photoReference: map['photo_reference'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Photo.fromJson(String source) =>
      Photo.fromMap(json.decode(source) as Map<String, dynamic>);
}
