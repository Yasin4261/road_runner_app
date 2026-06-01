/// Vardiya durumu - Backend ShiftStatus enum'una karşılık gelir
enum ShiftStatus {
  reserved,
  checkedIn,
  checkedOut,
  cancelled,
  noShow;

  String get apiValue {
    switch (this) {
      case ShiftStatus.reserved:
        return 'RESERVED';
      case ShiftStatus.checkedIn:
        return 'CHECKED_IN';
      case ShiftStatus.checkedOut:
        return 'CHECKED_OUT';
      case ShiftStatus.cancelled:
        return 'CANCELLED';
      case ShiftStatus.noShow:
        return 'NO_SHOW';
    }
  }

  String get displayLabel {
    switch (this) {
      case ShiftStatus.reserved:
        return 'Rezerve';
      case ShiftStatus.checkedIn:
        return 'Aktif';
      case ShiftStatus.checkedOut:
        return 'Tamamlandı';
      case ShiftStatus.cancelled:
        return 'İptal Edildi';
      case ShiftStatus.noShow:
        return 'Gelmedi';
    }
  }

  static ShiftStatus? fromString(String? value) {
    if (value == null) return null;
    switch (value.toUpperCase()) {
      case 'RESERVED':
        return ShiftStatus.reserved;
      case 'CHECKED_IN':
        return ShiftStatus.checkedIn;
      case 'CHECKED_OUT':
        return ShiftStatus.checkedOut;
      case 'CANCELLED':
        return ShiftStatus.cancelled;
      case 'NO_SHOW':
        return ShiftStatus.noShow;
    }
    return null;
  }
}

/// Vardiya rolü - Backend ShiftRole enum'una karşılık gelir
enum ShiftRole {
  courier,
  captain;

  String get apiValue => this == ShiftRole.courier ? 'COURIER' : 'CAPTAIN';

  String get displayLabel =>
      this == ShiftRole.courier ? 'Kurye' : 'Takım Kaptanı';

  static ShiftRole? fromString(String? value) {
    if (value == null) return null;
    switch (value.toUpperCase()) {
      case 'COURIER':
        return ShiftRole.courier;
      case 'CAPTAIN':
        return ShiftRole.captain;
    }
    return null;
  }
}

