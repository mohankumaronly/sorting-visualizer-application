import 'package:flutter/material.dart';

class AlgorithmCard extends StatelessWidget {
  final String algorithmName;
  final String description;
  final String difficulty;
  final VoidCallback onAnimatePressed;

  const AlgorithmCard({
    super.key,
    required this.algorithmName,
    required this.description,
    required this.difficulty,
    required this.onAnimatePressed,
  });

  @override
  Widget build(BuildContext context) {
    Color difficultyColor;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        difficultyColor = Colors.green;
        break;
      case 'medium':
        difficultyColor = Colors.orange;
        break;
      case 'hard':
        difficultyColor = Colors.red;
        break;
      default:
        difficultyColor = Colors.grey;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  algorithmName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Chip(
                  label: Text(
                    difficulty,
                    style: TextStyle(color: difficultyColor.computeLuminance() > 0.5 ? Colors.black : Colors.white),
                  ),
                  backgroundColor: difficultyColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: onAnimatePressed,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Animate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}