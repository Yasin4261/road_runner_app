import 'package:flutter/material.dart';

class RiderWidget extends StatelessWidget {
  const RiderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90, // Çemberin genişliği
      height: 90, // Çemberin yüksekliği
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Çember şeklinde yapıyoruz
        border: Border.all(
          color: Colors.black, // Dış çember rengi
          width: 2, // Çemberin kalınlığı
        ),
        color: Colors.white, // İç arka plan rengi
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Hafif gölge efekti
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(4), // Çember ile ikon arasında daha az boşluk
        child: Center(
          child: FittedBox(
            child: Icon(
              Icons.directions_bike_rounded,
              color: Colors.black87,
              size: 48, // İkonu biraz büyüttük
            ),
          ),
        ),
      ),
    );
  }
}
