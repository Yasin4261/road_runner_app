import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_runner_app/providers/courier_status_provider.dart';
import 'package:road_runner_app/constants/app_theme.dart'; // Buton stilini içe aktarın
import 'package:road_runner_app/viewmodels/shift_viewmodel.dart';

class CourierInfoWidget extends StatefulWidget {
  final String courierName;
  final String courierStatus;
  final String areaName;
  final String areaDetails;

  const CourierInfoWidget({
    Key? key,
    required this.courierName,
    required this.courierStatus,
    required this.areaName,
    required this.areaDetails,
  }) : super(key: key);

  @override
  _CourierInfoWidgetState createState() => _CourierInfoWidgetState();
}

class _CourierInfoWidgetState extends State<CourierInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<CourierStatusProvider, ShiftViewModel>(
      builder: (context, provider, shiftViewModel, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kurye Bilgileri',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.blue),
                            SizedBox(width: 10),
                            Expanded(child: Text('Ad: ${widget.courierName}')),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue),
                            SizedBox(width: 10),
                            Expanded(child: Text('Durum: ${provider.status}')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saha Bilgileri',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(width: 10),
                            Expanded(child: Text('Ad: ${widget.areaName}')),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.details, color: Colors.green),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text('Detaylar: ${widget.areaDetails}')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: provider.status,
                  onChanged: (String? newValue) async {
                    if (newValue != null) {
                      provider.updateStatus(newValue);
                      if (newValue == 'Aktif') {
                        await shiftViewModel.startShift(
                            "67ca03a6e7bd16c695581178"); // Here for courierId
                      }
                      if (newValue == 'Deaktif') {
                        await shiftViewModel.endShift(
                            "67ca03a6e7bd16c695581178"); // Here for courierId
                        print('Vardiya sonlandırıldı butonuna basıldı...');
                      }
                    }
                  },
                  items: <String>[
                    'Deaktif',
                    'Aktif',
                    'Molada',
                    'Kazada',
                    'Uzaktayım',
                    'Mola Bitti'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
