import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'locations.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    required this.lat,
    required this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}

@JsonSerializable()
class Building {
  Building({
    required this.code,
    required this.lat,
    required this.lng,
    required this.name,
  });

  factory Building.fromJson(Map<String, dynamic> json) =>
      _$BuildingFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingToJson(this);

  final String code;
  final double lat;
  final double lng;
  final String name;
}

@JsonSerializable()
class Locations {
  Locations({required this.buildings});

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Building> buildings;
}

Future<Locations> getUMDBuildings() async {
  const UMDBuildingLocationsURL = 'https://api.umd.kio/v1/map/buildings';

  // Retrieve the locations of Google offices
  try {
    final response = await http.get(Uri.parse(UMDBuildingLocationsURL));
    if (response.statusCode == 200) {
      print("success");
      var data = '{"buildings":' + response.body + '}';
      return Locations.fromJson(json.decode(data));
    }
  } catch (e) {
    print(e);
  }

  var preloadedData = await rootBundle.loadString('assets/locations.json');
  var data = '{"buildings":' + preloadedData + '}';
  // Fallback for when the above HTTP request fails.
  return Locations.fromJson(json.decode(data));
}
