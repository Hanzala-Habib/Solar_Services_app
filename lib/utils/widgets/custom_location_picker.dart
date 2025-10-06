import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapLocationPicker extends StatefulWidget {
  final Function(String) onLocationPicked;

  const MapLocationPicker({super.key, required this.onLocationPicked});

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  GoogleMapController? _controller;
  LatLng? _pickedLocation;
  LatLng _initialPosition = const LatLng(31.5204, 74.3587); // Lahore as fallback

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _initialPosition = LatLng(pos.latitude, pos.longitude);
      });
      _controller?.animateCamera(
        CameraUpdate.newLatLng(_initialPosition),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        backgroundColor: Colors.deepPurple,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 15,
        ),
        onMapCreated: (controller) => _controller = controller,
        onTap: (pos) {
          setState(() {
            _pickedLocation = pos;
          });
        },
        markers: _pickedLocation == null
            ? {}
            : {
          Marker(
            markerId: const MarkerId("picked"),
            position: _pickedLocation!,
          ),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_pickedLocation != null) {
            String loc =
                "${_pickedLocation!.latitude}, ${_pickedLocation!.longitude}";
            widget.onLocationPicked(loc);
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a location on map")),
            );
          }
        },
        icon: const Icon(Icons.check),
        label: const Text("Confirm"),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
