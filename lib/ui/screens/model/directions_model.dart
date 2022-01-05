import 'package:cloud_firestore/cloud_firestore.dart';

class DirectionModel {
  DirectionModel({
    directionLocation,
    timestamp,
  })  : directionLocation = directionLocation ?? DirectionLocation(),
        timestamp = timestamp ?? Timestamp.now();

  DirectionLocation directionLocation;
  Timestamp timestamp;

  factory DirectionModel.fromJson(DocumentSnapshot snapshot) => DirectionModel(
        directionLocation:
            DirectionLocation.fromJson(snapshot.get("location") ?? {}),
        timestamp: snapshot.get("timestamp") ?? "",
      );

  Map<String, dynamic> toJson() => {
        "location": directionLocation.toJson(),
        "timestamp": timestamp,
      };
}

class DirectionLocation {
  DirectionLocation({
    this.latitude = -1,
    this.longitude = -1,
  });

  double latitude;
  double longitude;

  factory DirectionLocation.fromJson(Map<String, dynamic> json) =>
      DirectionLocation(
        latitude: json["latitude"] ?? -1,
        longitude: json["longitude"] ?? -1,
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
