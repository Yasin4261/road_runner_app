import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:road_runner_app/constants/colors.dart';
import 'package:road_runner_app/constants/dimensions.dart';
import 'package:road_runner_app/widgets/custom_drawer.dart';
import 'package:road_runner_app/widgets/custom_app_bar.dart';
import 'package:road_runner_app/widgets/map_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _currentPosition;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _checkLocationService();
  }

  Future<void> _checkLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum servisinin etkin olup olmadığını kontrol edin
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Konum servisi etkin değilse, kullanıcıya bildirilebilir
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Konum servisi etkin değil.');
        return;
      }
    }

    // İzin durumunu kontrol edin
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // İzin reddedildiyse, kullanıcıya bildirilebilir
        print('Konum izni reddedildi.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Kullanıcı izinleri kalıcı olarak reddettiyse
      print('Konum izni kalıcı olarak reddedildi.');
      return;
    }

    // Konum servisleri ve izinler tamam
    print('Konum servisi etkin ve izinler tamam.');
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // FlutterMap widget'ı render edildikten sonra mapController'ı kullanın
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_currentPosition != null) {
          _mapController.move(_currentPosition!, 15.0);
        }
      });
    } catch (e) {
      print('Konum alınamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: 'Slotlarım',
        onPress: () {
          print("Slotlarım tapped");
        },
      ),
      drawer: CustomDrawer(),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : MapWidget(
              initialPosition: _currentPosition!,
              mapController: _mapController,
              markers: [
                Marker(
                  point: _currentPosition!,
                  child: const Icon(
                    Icons.directions_bike_rounded,
                    color: Colors.red,
                    size: AppDimensions.iconSize,
                  ),
                ),
              ],
            ),
    );
  }
}
