import 'package:flutter/material.dart';

// Custom Bottom Sheet Widget
class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2, // Initial size of the bottom sheet
      minChildSize: 0.2, // Minimum size the bottom sheet can collapse to
      maxChildSize: 0.3, // Maximum size the bottom sheet can expand to
      expand: false, // Prevent full-screen expansion
      builder: (context, scrollController) {
        return _BottomSheetContent(scrollController: scrollController);
      },
    );
  }
}

// Bottom Sheet Content
class _BottomSheetContent extends StatelessWidget {
  final ScrollController scrollController;

  const _BottomSheetContent({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0, // Sol kenara padding
        right: 20.0, // Sağ kenara padding
        top: 15.0, // Üst kenara padding
        bottom: 0.0, // Alt kenara padding yok
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
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

// Drag Handle (for the top area)
class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Title of the Bottom Sheet
class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Sipariş Detayları",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

// List of Orders inside the Bottom Sheet
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

// Order Card Widget
class _OrderCard extends StatelessWidget {
  final int index;

  const _OrderCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding:
            const EdgeInsets.all(12), // Slightly larger padding for more space
        leading: const _OrderIcon(),
        title: Text(
          "Sipariş #${1000 + index}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text("Adres: İstanbul, Kadıköy"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        // Adding a new Row to display delay time below the subtitle
        isThreeLine: true, // Allows 3 lines of content
        dense: false, // Makes the widget more compact if set to true
        // Add delay information
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Sipariş Gecikmesi"),
              content: const Text("Bu sipariş 30 dakika gecikmiş olabilir."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Tamam"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Order Icon Widget (used in each list item)
class _OrderIcon extends StatelessWidget {
  const _OrderIcon();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blueAccent,
      child: const Icon(
        Icons.shopping_bag, // Icon used for the order
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
