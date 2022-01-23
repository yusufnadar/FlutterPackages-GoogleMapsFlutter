import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  BitmapDescriptor? deger;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goNewPosition();
        },
        child: const Icon(Icons.location_on),
      ),
      appBar: AppBar(
        title: const Text('Google Maps Flutter'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
          assetComplete();
        },
        initialCameraPosition: const CameraPosition(
            target: LatLng(39.7499916, 37.0150028), zoom: 10),
        mapType: MapType.normal,
        markers: markers(),
      ),
    );
  }

  goNewPosition() {
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(target: LatLng(37.8716185, 32.4785982), zoom: 13),
      ),
    );
  }

  Set<Marker> markers() {
    return {
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(39.7499916, 37.0150028),
        icon: deger ?? BitmapDescriptor.defaultMarker,
      ),
      Marker(
        markerId: const MarkerId('2'),
        position: const LatLng(37.8716185, 32.4785982),
        icon: deger ?? BitmapDescriptor.defaultMarker,
      ),
    };
  }

  void assetComplete() async {
    Future<Uint8List> getBytesFromAsset(String path, int width) async {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    }
    final Uint8List markerIcon = await getBytesFromAsset('assets/car.png', 50);
    var bitMap = BitmapDescriptor.fromBytes(markerIcon);
    setState(() {
      deger = bitMap;
    });
  }
}
