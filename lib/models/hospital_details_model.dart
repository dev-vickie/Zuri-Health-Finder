// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HospitalDetails {
  final String? internationalPhoneNumber;
  final String? shortFormattedAddress;
  final num? rating;
  final DisplayName? displayName;
  final CurrentOpeningHours? currentOpeningHours;
  final List<Reviews>? reviews;
  final List<Photos>? photos;

  HospitalDetails({
    this.internationalPhoneNumber,
    this.shortFormattedAddress,
    this.rating,
    this.displayName,
    this.currentOpeningHours,
    this.reviews,
    this.photos,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'internationalPhoneNumber': internationalPhoneNumber,
      'shortFormattedAddress': shortFormattedAddress,
      'rating': rating,
      'displayName': displayName?.toMap(),
      'currentOpeningHours': currentOpeningHours?.toMap(),
      'reviews': reviews?.map((x) => x.toMap()).toList(),
      'photos': photos?.map((x) => x.toMap()).toList(),
    };
  }

  factory HospitalDetails.fromMap(Map<String, dynamic> map) {
    return HospitalDetails(
      internationalPhoneNumber: map['internationalPhoneNumber'] != null
          ? map['internationalPhoneNumber'] as String
          : null,
      shortFormattedAddress: map['shortFormattedAddress'] != null
          ? map['shortFormattedAddress'] as String
          : null,
      rating: map['rating'] != null ? map['rating'] as num : null,
      displayName: map['displayName'] != null
          ? DisplayName.fromMap(map['displayName'] as Map<String, dynamic>)
          : null,
      currentOpeningHours: map['currentOpeningHours'] != null
          ? CurrentOpeningHours.fromMap(
              map['currentOpeningHours'] as Map<String, dynamic>)
          : null,
      reviews: map['reviews'] != null
          ? List<Reviews>.from(
              (map['reviews'] as List).map<Reviews?>(
                (x) => Reviews.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      photos: map['photos'] != null
          ? List<Photos>.from(
              (map['photos'] as List).map<Photos?>(
                (x) => Photos.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HospitalDetails.fromJson(String source) =>
      HospitalDetails.fromMap(json.decode(source) as Map<String, dynamic>);
}

class DisplayName {
  final String? text;

  DisplayName({this.text});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
    };
  }

  factory DisplayName.fromMap(Map<String, dynamic> map) {
    return DisplayName(
      text: map['text'] != null ? map['text'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DisplayName.fromJson(String source) =>
      DisplayName.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CurrentOpeningHours {
  final bool openNow;

  CurrentOpeningHours({required this.openNow});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'openNow': openNow,
    };
  }

  factory CurrentOpeningHours.fromMap(Map<String, dynamic> map) {
    return CurrentOpeningHours(
      openNow: map['openNow'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentOpeningHours.fromJson(String source) =>
      CurrentOpeningHours.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Reviews {
  final ReviewText? text;
  final num? rating;
  final String? relativePublishTimeDescription;
  final AuthorAttribution? authorAttribution;

  Reviews({
    this.text,
    this.rating,
    this.relativePublishTimeDescription,
    this.authorAttribution,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text?.toMap(),
      'rating': rating,
      'relativePublishTimeDescription': relativePublishTimeDescription,
      'authorAttribution': authorAttribution?.toMap(),
    };
  }

  factory Reviews.fromMap(Map<String, dynamic> map) {
    return Reviews(
      text: map['text'] != null
          ? ReviewText.fromMap(map['text'] as Map<String, dynamic>)
          : null,
      rating: map['rating'] != null ? map['rating'] as num : null,
      relativePublishTimeDescription:
          map['relativePublishTimeDescription'] != null
              ? map['relativePublishTimeDescription'] as String
              : null,
      authorAttribution: map['authorAttribution'] != null
          ? AuthorAttribution.fromMap(
              map['authorAttribution'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reviews.fromJson(String source) =>
      Reviews.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ReviewText {
  final String? text;

  ReviewText({this.text});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
    };
  }

  factory ReviewText.fromMap(Map<String, dynamic> map) {
    return ReviewText(
      text: map['text'] != null ? map['text'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewText.fromJson(String source) =>
      ReviewText.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AuthorAttribution {
  final String? displayName;
  final String? photoUri;

  AuthorAttribution({
    this.displayName,
    this.photoUri,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'photoUri': photoUri,
    };
  }

  factory AuthorAttribution.fromMap(Map<String, dynamic> map) {
    return AuthorAttribution(
      displayName:
          map['displayName'] != null ? map['displayName'] as String : null,
      photoUri: map['photoUri'] != null ? map['photoUri'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthorAttribution.fromJson(String source) =>
      AuthorAttribution.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Photos {
  final String? name;
  final num? widthPx;
  final num? heightPx;

  Photos({
    this.name,
    this.widthPx,
    this.heightPx,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'widthPx': widthPx,
      'heightPx': heightPx,
    };
  }

  factory Photos.fromMap(Map<String, dynamic> map) {
    return Photos(
      name: map['name'] != null ? map['name'] as String : null,
      widthPx: map['widthPx'] != null ? map['widthPx'] as num : null,
      heightPx: map['heightPx'] != null ? map['heightPx'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Photos.fromJson(String source) =>
      Photos.fromMap(json.decode(source) as Map<String, dynamic>);
}
