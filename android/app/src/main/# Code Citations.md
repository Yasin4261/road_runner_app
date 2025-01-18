# Code Citations

## License: unknown
https://github.com/HunterGooD/FlutterPhotoSender/tree/caeb06c8a17b1067e8fab3288407ec11892d4ec5/lib/presentation/geo.dart

```
bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission
```


## License: unknown
https://github.com/abhinavjha98/sms-app/tree/0ebb7119c45bdfc54c01a4efb42d2e40a707af12/lib/location.dart

```
;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied
```


## License: unknown
https://github.com/shawndown/shawn-work/tree/e3ee0dcec1129768718034670adfba7324f6b60d/src/unisa_map/lib/maps.dart

```
checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.
```


## License: unknown
https://github.com/ahmadhanis/FlutterA192/tree/4ce8c3cbcf14c0e7a0f59d0e44210c0679629e9c/mypasar/lib/newproductscreen.dart

```
await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we
```


## License: unknown
https://github.com/FakeRaccoon/wastebank/tree/ffe7f1861a8c01d4f29e81234090866f8e65c8b1/lib/Controllers/map-controller.dart

```
LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final position = await
```

