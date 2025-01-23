import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:road_runner_app/constants/colors.dart';
import 'package:road_runner_app/constants/dimensions.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Text(
              'Menü',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: Container(
                margin: const EdgeInsets.only(right: 8.0),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(Icons.home,
                    color: Colors.white, size: AppDimensions.iconSize),
              ),
              title: const Text('Ana Sayfa',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: Container(
                margin: const EdgeInsets.only(right: 8.0),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(Icons.settings,
                    color: Colors.white, size: AppDimensions.iconSize),
              ),
              title:
                  const Text('Ayarlar', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: Container(
                margin: const EdgeInsets.only(right: 8.0),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(Icons.logout,
                    color: Colors.white, size: AppDimensions.iconSize),
              ),
              title: const Text('Çıkış Yap',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                FirebaseAuth.instance.signOut();
                context.go('/');
                // Çıkış işlemleri burada yapılabilir
              },
            ),
          ),
        ],
      ),
    );
  }
}
