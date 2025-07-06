// lib/algorithms/bubble_sort_algorithm.dart
import 'package:flutter/material.dart';
import 'package:sample01/my-reference/Animation_visualizer/models/bar_data.dart';

/// Defines the signature for any sorting algorithm that can be visualized.
typedef SortAlgorithm = Future<void> Function(
  List<BarData> bars,
  void Function(VoidCallback fn) update,
  Future<void> Function() wait,
);

/// Implements the Bubble Sort algorithm for visualization.
///
/// This function adheres to the [SortAlgorithm] typedef.
Future<void> bubbleSort(
  List<BarData> bars,
  void Function(VoidCallback fn) update,
  Future<void> Function() wait,
) async {
  int n = bars.length;
  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
      // Highlight bars being compared
      bars[j].color = Colors.orange;
      bars[j + 1].color = Colors.orange;
      update(() {}); // Trigger UI update for color change
      await wait(); // Pause for visualization

      if (bars[j].value > bars[j + 1].value) {
        // Highlight bars being swapped
        bars[j].color = Colors.red;
        bars[j + 1].color = Colors.red;
        update(() {});
        await wait();

        // Swap values
        int tempValue = bars[j].value;
        bars[j].value = bars[j + 1].value;
        bars[j + 1].value = tempValue;

        update(() {}); // Trigger UI update for value swap
        await wait(); // Pause after swap
      }

      // Reset colors to original after comparison/swap (or controller's default)
      // The controller will provide the default bar color.
      // Note: The controller provides the default color, so these might be overridden by it.
      // For a visualizer, it's often better if the controller manages final colors.
      // For now, we'll use Colors.blue as a neutral reset.
      bars[j].color = Colors.blue;
      bars[j + 1].color = Colors.blue;
      update(() {});
      await wait();
    }
    // Mark the last element of the sorted part as green
    bars[n - 1 - i].color = Colors.green;
    update(() {});
    await wait(); // Wait after marking a sorted element
  }
  // Mark the first element as green (it will be sorted after loop completes)
  if (n > 0) {
    bars[0].color = Colors.green;
    update(() {});
  }
}