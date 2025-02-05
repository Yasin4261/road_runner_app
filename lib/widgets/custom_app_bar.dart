import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_runner_app/constants/colors.dart';
import 'package:road_runner_app/constants/dimensions.dart';
import 'package:road_runner_app/providers/courier_status_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onPress; // onPress parametresi eklendi

  const CustomAppBar({super.key, this.onPress});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => Container(
          margin: const EdgeInsets.only(left: 8.0),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white, width: 1.0),
          ),
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            iconSize: AppDimensions.iconSize,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      centerTitle: true,
      title: Consumer<CourierStatusProvider>(
        builder: (context, provider, child) {
          return GestureDetector(
            onTap: onPress, // Kullanıcı tıkladığında onPress çağrılacak
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.white, width: 1.0),
              ),
              child: Text(provider.status), // Dinamik başlık
            ),
          );
        },
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8.0),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white, width: 1.0),
          ),
          child: IconButton(
            icon: const Icon(Icons.phone),
            iconSize: AppDimensions.iconSize,
            onPressed: () {
              print('Operatöre bağlan');
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
