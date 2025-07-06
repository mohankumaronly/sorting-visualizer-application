import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample01/my-reference/Animation_visualizer/controllers/sorting_controller.dart';
import 'package:sample01/my-reference/Animation_visualizer/widgets/animated_bar_display.dart';

class AnimationTab extends StatefulWidget {
  const AnimationTab({super.key});

  @override
  State<AnimationTab> createState() => _AnimationTabState();
}

class _AnimationTabState extends State<AnimationTab> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text field with current bars from controller if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<SortingController>(context, listen: false);
      if (controller.bars.isNotEmpty) {
        _inputController.text = controller.bars.map((e) => e.value.toString()).join(',');
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the controller for UI updates
    final sortingController = context.watch<SortingController>();
    final bool isSorting = sortingController.isSorting;
    final bool isPaused = sortingController.isPaused;
    final double animationSpeed = sortingController.animationSpeed;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 700;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: isWideScreen
              ? Row(
                  children: [
                    // --- Controls Column (LEFT) ---
                    Expanded(
                      flex: 2,
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Animation Controls",
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _inputController,
                                decoration: const InputDecoration(
                                  labelText: "Enter numbers (e.g. 5,3,1,4)",
                                  prefixIcon: Icon(Icons.numbers_outlined),
                                  // Counter for 10-digit input style (visual only for now)
                                  counterText: '', // Hide default counter
                                ),
                                keyboardType: TextInputType.number,
                                readOnly: isSorting,
                                maxLength: 29, // Max 10 digits + 9 commas (e.g., "1,2,3,4,5,6,7,8,9,10")
                                onSubmitted: (_) {
                                  sortingController.initializeBarsFromValues(
                                    _inputController.text.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isSorting ? null : () {
                                        // Generate random data for 10 bars (as per "10-digit" hint)
                                        sortingController.generateRandomBars(count: 10, maxValue: 50);
                                        // Update text field to reflect generated data
                                        _inputController.text = sortingController.bars.map((e) => e.value.toString()).join(',');
                                      },
                                      icon: const Icon(Icons.casino_outlined),
                                      label: const Text("Generate"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isSorting ? null : () {
                                        sortingController.initializeBarsFromValues(
                                          _inputController.text.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList(),
                                        );
                                      },
                                      icon: const Icon(Icons.data_array),
                                      label: const Text("Set Data"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isSorting || sortingController.bars.isEmpty ? null : sortingController.startSorting,
                                      icon: const Icon(Icons.play_arrow),
                                      label: const Text("Start"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isSorting ? sortingController.togglePause : null,
                                      icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                                      label: Text(isPaused ? "Resume" : "Pause"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isPaused ? Colors.green : Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isSorting ? null : sortingController.clearBars,
                                      icon: const Icon(Icons.clear_all),
                                      label: const Text("Clear"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Speed: x${animationSpeed.toInt()}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Slider(
                                min: 1,
                                max: 10,
                                divisions: 9,
                                value: animationSpeed,
                                label: "x${animationSpeed.toInt()}",
                                onChanged: sortingController.setAnimationSpeed,
                              ),
                              const Spacer(), // Pushes content to top
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24), // Spacer between controls and visualizer

                    // --- Visualizer (RIGHT) ---
                    Expanded(
                      flex: 5,
                      child: AnimatedBarDisplay(
                        bars: sortingController.bars,
                        animationDuration: const Duration(milliseconds: 250),
                        orientation: Axis.vertical,
                        defaultBarWidth: sortingController.defaultBarWidth,
                      ),
                    ),
                  ],
                )
              : Column( // Narrow screen layout: controls on top, visualizer below
                  children: [
                    // --- Controls Card (TOP) ---
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Animation Controls",
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _inputController,
                              decoration: const InputDecoration(
                                labelText: "Enter numbers (e.g. 5,3,1,4)",
                                prefixIcon: Icon(Icons.numbers_outlined),
                                counterText: '',
                              ),
                              keyboardType: TextInputType.number,
                              readOnly: isSorting,
                              maxLength: 29,
                              onSubmitted: (_) {
                                sortingController.initializeBarsFromValues(
                                  _inputController.text.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList(),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isSorting ? null : () {
                                      sortingController.generateRandomBars(count: 10, maxValue: 50);
                                      _inputController.text = sortingController.bars.map((e) => e.value.toString()).join(',');
                                    },
                                    icon: const Icon(Icons.casino_outlined),
                                    label: const Text("Generate"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isSorting ? null : () {
                                      sortingController.initializeBarsFromValues(
                                        _inputController.text.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList(),
                                      );
                                    },
                                    icon: const Icon(Icons.data_array),
                                    label: const Text("Set Data"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isSorting || sortingController.bars.isEmpty ? null : sortingController.startSorting,
                                    icon: const Icon(Icons.play_arrow),
                                    label: const Text("Start"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isSorting ? sortingController.togglePause : null,
                                    icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                                    label: Text(isPaused ? "Resume" : "Pause"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isPaused ? Colors.green : Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isSorting ? null : sortingController.clearBars,
                                    icon: const Icon(Icons.clear_all),
                                    label: const Text("Clear"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Speed: x${animationSpeed.toInt()}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Slider(
                              min: 1,
                              max: 10,
                              divisions: 9,
                              value: animationSpeed,
                              label: "x${animationSpeed.toInt()}",
                              onChanged: sortingController.setAnimationSpeed,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24), // Spacer between controls and visualizer

                    // --- Visualizer (BOTTOM) ---
                    Expanded(
                      child: AnimatedBarDisplay(
                        bars: sortingController.bars,
                        animationDuration: const Duration(milliseconds: 250),
                        orientation: Axis.vertical,
                        defaultBarWidth: sortingController.defaultBarWidth,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}