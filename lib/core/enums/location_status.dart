/// Location permission status
enum LocationStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

/// Extension for user-friendly messages
extension LocationStatusExtension on LocationStatus {
  String get title {
    switch (this) {
      case LocationStatus.granted:
        return 'Konum İzni Verildi';
      case LocationStatus.denied:
        return 'Konum İzni Gerekli';
      case LocationStatus.deniedForever:
        return 'Konum İzni Engellendi';
      case LocationStatus.serviceDisabled:
        return 'Konum Servisi Kapalı';
    }
  }

  String get message {
    switch (this) {
      case LocationStatus.granted:
        return 'Konum erişimi sağlandı.';
      case LocationStatus.denied:
        return 'Haritada konumunuzu görebilmek için konum iznine ihtiyacımız var.';
      case LocationStatus.deniedForever:
        return 'Konum izni kalıcı olarak reddedildi. Lütfen uygulama ayarlarından izin verin.';
      case LocationStatus.serviceDisabled:
        return 'Konum servisi kapalı. Lütfen cihaz ayarlarından GPS\'i açın.';
    }
  }

  String get buttonText {
    switch (this) {
      case LocationStatus.granted:
        return 'Tamam';
      case LocationStatus.denied:
        return 'İzin Ver';
      case LocationStatus.deniedForever:
        return 'Ayarlara Git';
      case LocationStatus.serviceDisabled:
        return 'Ayarlara Git';
    }
  }

  bool get needsAppSettings => this == LocationStatus.deniedForever;
  bool get needsLocationSettings => this == LocationStatus.serviceDisabled;
  bool get canRequestPermission => this == LocationStatus.denied;
}

