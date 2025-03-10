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
          _buildDrawerItem(
            context,
            icon: Icons.home,
            text: 'Ana Sayfa',
            onTap: () {
              context.go('/home');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.person,
            text: 'Profil',
            onTap: () {
              context.go('/profile');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            text: 'Ayarlar',
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: 'Çıkış Yap',
            onTap: () {
              FirebaseAuth.instance.signOut();
              context.go('/');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return Container(
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
          child: Icon(icon, color: Colors.white, size: AppDimensions.iconSize),
        ),
        title: Text(text, style: const TextStyle(color: Colors.white)),
        onTap: onTap,
      ),
    );
  }
}
