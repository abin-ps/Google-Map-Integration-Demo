import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  static const LatLng _pDevaragudda = LatLng(14.669746789074516, 75.57459681455468);
  static const LatLng _pRaneBennur = LatLng(14.669746789074516, 75.57459681455468);

  LatLng? _currentP;

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? Center(
              child: Text('Loading..'),
            )
          : GoogleMap(
            //getting google map controller
            onMapCreated: ((GoogleMapController controller)=> _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(target: _pDevaragudda, zoom: 13),
              markers: {
                 Marker(
                  markerId: MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentP!,
                ),
                Marker(
                  markerId: MarkerId("_sourceLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pDevaragudda,
                ),
                Marker(
                  markerId: MarkerId("_destinationLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pRaneBennur,
                ),
              },
            ),
    );
  }

  Future<void> _getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    //check for is service available, if available request permission to access the service. else do nothing
    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      //if requested service granted returns true else false.
      _serviceEnabled = await _locationController.requestService();
    } else {
      //if service not available for us. terminate the flow. by returning.
      return;
    }
    //do we have location permission
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        //if permission not granted. then terminate the flow, by returning.
        return;
      }
    }

    //on location change
    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          // print(_currentP);
          //move camera to new position
          cameraToPosition(_currentP!);
        });
      }
    });
  }

  //update camera position accoring to current location of the user. camera view moving accordingly.
  Future<void> cameraToPosition(LatLng pos)async{
    final GoogleMapController controller = await _mapController.future;
    final CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
    controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }
}
