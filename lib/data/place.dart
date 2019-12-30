import 'dart:core';
import 'package:meta/meta.dart';
import 'package:latlong/latlong.dart';

class PlaceData {

  PlaceData({
    @required this.placeName,
    @required this.location,
  });

  PlaceData.fromMap(Map<String, dynamic> map)
      : placeName = map['place_name'],
        location = LatLng(map['location']['coordinates'][1], map['location']['coordinates'][0]);

  final String placeName;
  final LatLng location;

  @override
  String toString() {
    return placeName + ' at ' + location.toString();
  }

}