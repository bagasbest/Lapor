import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lapor/widgets/loading_widgets.dart';

class MapsPengaduan extends StatefulWidget {
  final latitude;
  final longitude;

  MapsPengaduan({
    this.latitude,
    this.longitude,
  });

  @override
  _MapsPengaduanState createState() => _MapsPengaduanState();
}

class _MapsPengaduanState extends State<MapsPengaduan> {
  Completer<GoogleMapController> _controller = Completer();
  var _latitude;
  var _longitude;
  bool _isLoading = true;
  var _pinLocationIcon;

  @override
  void initState() {
    super.initState();
    _latitude = widget.latitude;
    _longitude = widget.longitude;
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(100, 100)), 'assets/pin.png');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Titik lokasi pelapor',
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
                      markerId: MarkerId('_userLocation'),
                      infoWindow: InfoWindow(title: 'Posisi Pelapor'),
                      icon: _pinLocationIcon,
                      position: LatLng(double.parse(_latitude), double.parse(_longitude)),
                    ),
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(_latitude), double.parse(_longitude)),
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ],
            ),
          );
  }
}
