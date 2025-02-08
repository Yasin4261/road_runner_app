import 'package:flutter/material.dart';
import 'package:road_runner_app/constants/app_theme.dart';
import 'package:road_runner_app/constants/colors.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.3, // Maksimum genişliği artırdım
      expand: false,
      builder: (context, scrollController) {
        return _BottomSheetContent(scrollController: scrollController);
      },
    );
  }
}

// Bottom Sheet İçeriği
class _BottomSheetContent extends StatelessWidget {
  final ScrollController scrollController;

  const _BottomSheetContent({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.background, // Arka plan rengini temadan al
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DragHandle(),
          const SizedBox(height: 10),
          const _Title(),
          const SizedBox(height: 15),
          _OrderList(scrollController: scrollController),
        ],
      ),
    );
  }
}

// Çekme Çubuğu
class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[600], // Daha koyu bir renk kullan
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Başlık
class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Sipariş Detayları",
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
    );
  }
}

// Sipariş Listesi
class _OrderList extends StatelessWidget {
  final ScrollController scrollController;

  const _OrderList({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OrderCard(index: index),
          );
        },
      ),
    );
  }
}

// Sipariş Kartı
class _OrderCard extends StatelessWidget {
  final int index;

  const _OrderCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardTheme.color, // Temadan al
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const _OrderIcon(),
        title: Text(
          "Sipariş #${1000 + index}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary, // Metin rengini temadan al
          ),
        ),
        subtitle: Text(
          "Adres: İstanbul, Kadıköy",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        isThreeLine: true,
        dense: false,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              backgroundColor: AppColors.background, // Temaya uygun hale getir
              title: Text(
                "Sipariş Gecikmesi",
                style: TextStyle(color: AppColors.textPrimary),
              ),
              content: Text(
                "Bu sipariş 30 dakika gecikmiş olabilir.",
                style: TextStyle(color: AppColors.textSecondary),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text("Tamam", style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Sipariş İkonu
class _OrderIcon extends StatelessWidget {
  const _OrderIcon();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: AppColors.primary,
      child: const Icon(
        Icons.shopping_bag,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
