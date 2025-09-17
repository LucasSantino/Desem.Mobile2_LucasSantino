import 'package:flutter/material.dart';
import 'package:appdeliverytb/ui/_core/app_colors.dart';

class CategoryWidget extends StatelessWidget {
  final String category;
  final VoidCallback? onTap; // novo

  const CategoryWidget({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // chama a função ao clicar
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.lightBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            Image.asset(
              'assets/categories/${category.toLowerCase()}.png',
              height: 48,
            ),
            const SizedBox(height: 8),
            Text(
              category,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
