import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lapor/auth/login_screen.dart';
import 'package:lapor/widgets/loading_widgets.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  var _latitude;
  var _longitude;
  bool _isLoading = true;
  var _pinLocationIcon;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      } else {
        getCurrentLocation();
      }
    } else {
      getCurrentLocation();
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    print(lastPosition);

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    _determinePosition();
    getCurrentLocation();
  }

  void setCustomMapPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(100, 100)), 'assets/pin.png');
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Tentukan Titik Lokasi Anda',
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              backgroundColor: Color(0xfffbbb5b),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  markers: {
                    Marker(
                        onTap: () {
                          print('tapped');
                        },
                        markerId: MarkerId('_myLocation'),
                        infoWindow: InfoWindow(title: 'Posisi Anda'),
                        icon: _pinLocationIcon,
                        draggable: true,
                        position: LatLng(_latitude, _longitude),
                        onDragEnd: ((newPosition) {
                          print(newPosition.latitude);
                          print(newPosition.longitude);
                          setState(() {
                            _latitude = newPosition.latitude;
                            _longitude = newPosition.longitude;
                          });
                        }))
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_latitude, _longitude),
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      toast(
                          'Klik & Tahan Pin / Marker beberapa saat hingga marker terangkat, kemudian arahkan ke lokasi anda terkini');
                    },
                    icon: Icon(Icons.info),
                    color: Color(0xfffbbb5b),
                    iconSize: 60,
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context, '$_latitude|$_longitude');
              },
              label: Text('Pilih Lokasi'),
              icon: Icon(Icons.pin_drop),
              backgroundColor: Color(0xfffbbb5b),
            ),
          );
  }
}
