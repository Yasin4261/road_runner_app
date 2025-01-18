import 'package:flutter/material.dart';
import 'package:road_runner_app/constants/colors.dart';
import 'package:road_runner_app/constants/dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPress;

  const CustomAppBar({super.key, required this.title, this.onPress});

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
      title: GestureDetector(
        onTap: onPress,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white, width: 1.0),
          ),
          child: Text(title),
        ),
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
              // Operatöre bağlanma işlemleri burada yapılabilir
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
