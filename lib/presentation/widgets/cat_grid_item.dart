import 'package:flutter/material.dart';
import 'package:wietapp/data/models/cat.dart';

class CatGridItem extends StatelessWidget {
  final Cat cat;

  const CatGridItem({Key? key, required this.cat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCatDialog(context),
      child: Card(
        child: Image.network(
          cat.url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error));
          },
        ),
      ),
    );
  }

  void _showCatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cat ID'),
        content: Text(cat.id),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}