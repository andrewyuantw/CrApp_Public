import 'package:crapp/screens/reviews_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../locations.dart' as locations;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  // Set center as UMD's McKeldin Mall
  final LatLng _center = const LatLng(38.9860, -76.9424);

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: const Color.fromARGB(255, 255, 126, 101),
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final UMDBuildings = await locations.getUMDBuildings();
    setState(() {
      _markers.clear();
      for (final building in UMDBuildings.buildings) {
        final marker = Marker(
          markerId: MarkerId(building.name),
          position: LatLng(building.lat, building.lng),
          infoWindow: InfoWindow(
              title: building.name,
              snippet: building.code,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(building.name),
                  ))),
        );
        _markers[building.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: Stack(children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 17.0,
          ),
          markers: _markers.values.toSet(),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton.extended(
              onPressed: () => print('button pressed'),
              label: const Text('Crap!'),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.orangeAccent,
              icon: const FaIcon(
                FontAwesomeIcons.toilet,
                size: 36.0,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
