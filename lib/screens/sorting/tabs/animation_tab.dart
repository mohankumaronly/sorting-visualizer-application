// lib/my-reference/Animation_visualizer/screens/sorting/tabs/animation_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample01/my-reference/Animation_visualizer/controllers/sorting_controller.dart';
import 'package:sample01/my-reference/Animation_visualizer/widgets/animated_bar_display.dart';
import 'dart:developer' as dev; // Import for debugPrint
import 'dart:math'; // For Random, if used in generateRandomBars

class AnimationTab extends StatefulWidget {
  const AnimationTab({super.key});

  @override
  State<AnimationTab> createState() => _AnimationTabState();
}

class _AnimationTabState extends State<AnimationTab> {
  final TextEditingController _inputController = TextEditingController();

  double _currentBarWidth = 20.0;
  double _currentBarGap = 5.0;
  int _prevBarCount = 0; // To track changes in number of bars

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sortingController = Provider.of<SortingController>(context, listen: false);
      if (sortingController.bars.isNotEmpty) {
        _inputController.text = sortingController.bars.map((e) => e.value.toString()).join(',');
      }
      // Initial calculation with an estimated width
      final estimatedWidth = _getEstimatedVisualizerAvailableWidth(MediaQuery.of(context).size.width, _isCurrentScreenWide());
      _updateBarDimensions(sortingController.bars.length, estimatedWidth);
      _prevBarCount = sortingController.bars.length;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    // The SortingController's dispose method handles its internal timer cleanup.
    super.dispose();
  }

  bool _isCurrentScreenWide() {
    return MediaQuery.of(context).size.width > 700;
  }

  double _getEstimatedVisualizerAvailableWidth(double totalContainerWidth, bool isWideScreen) {
    const double outerHorizontalPadding = 16.0 * 2; // Padding on the parent Padding widget (left + right)
    const double wideLayoutSpacerWidth = 24.0; // SizedBox width between controls and visualizer

    const int controlsFlex = 2;
    const int visualizerFlex = 5;
    const int totalFlex = controlsFlex + visualizerFlex;

    // Total width available for the content *inside* the main Padding
    double contentAreaWidth = totalContainerWidth - outerHorizontalPadding;

    if (isWideScreen) {
      double widthForFlexAllocation = contentAreaWidth - wideLayoutSpacerWidth;
      if (widthForFlexAllocation < 0) widthForFlexAllocation = 0;

      double visualizerWidth = widthForFlexAllocation * (visualizerFlex / totalFlex);
      dev.log('Wide Screen Estimated Visualizer Width: ${visualizerWidth.toStringAsFixed(2)} (total: ${totalContainerWidth.toStringAsFixed(2)}, content: ${contentAreaWidth.toStringAsFixed(2)})');
      return visualizerWidth.clamp(0.0, double.infinity);
    } else {
      dev.log('Narrow Screen Estimated Visualizer Width: ${contentAreaWidth.toStringAsFixed(2)} (total: ${totalContainerWidth.toStringAsFixed(2)})');
      return contentAreaWidth.clamp(0.0, double.infinity);
    }
  }

  void _updateBarDimensions(int numberOfBars, double availableWidth) {
    if (numberOfBars == 0 || availableWidth <= 0) {
      if (_currentBarWidth != 0 || _currentBarGap != 0) {
        setState(() {
          _currentBarWidth = 0;
          _currentBarGap = 0;
        });
      }
      return;
    }

    const double maxPreferredBarWidth = 30.0;
    const double minBarWidth = 4.0;
    const double preferredGapRatio = 0.10;

    double totalPreferredWidthWithGaps = (maxPreferredBarWidth * numberOfBars) +
                                         (maxPreferredBarWidth * preferredGapRatio * (numberOfBars - 1));

    double newBarWidth;
    double newBarGap;

    if (totalPreferredWidthWithGaps <= availableWidth) {
      newBarWidth = maxPreferredBarWidth;
    } else {
      double effectiveBarAndGapCount = numberOfBars + (preferredGapRatio * (numberOfBars - 1));
      if (effectiveBarAndGapCount <= 0) effectiveBarAndGapCount = 1.0;
      newBarWidth = availableWidth / effectiveBarAndGapCount;
    }

    newBarWidth = newBarWidth.clamp(minBarWidth, maxPreferredBarWidth);
    newBarGap = newBarWidth * preferredGapRatio;

    dev.log('Calculated Bar Dimensions: Width=${newBarWidth.toStringAsFixed(2)}, Gap=${newBarGap.toStringAsFixed(2)} for $numberOfBars bars in ${availableWidth.toStringAsFixed(2)}px');

    if ((_currentBarWidth - newBarWidth).abs() > 0.5 || (_currentBarGap - newBarGap).abs() > 0.5) {
      setState(() {
        _currentBarWidth = newBarWidth;
        _currentBarGap = newBarGap;
      });
    }
  }

  void _processInputAndSetBars(SortingController controller, String inputText, double availableWidthForVisualizer) {
    List<int> values = inputText.split(',')
        .map((e) => int.tryParse(e.trim()) ?? -1)
        .where((value) => value >= 0)
        .toList();

    controller.initializeBarsFromValues(values); // Use controller's method
    _updateBarDimensions(controller.bars.length, availableWidthForVisualizer);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the SortingController for state changes
    final sortingController = context.watch<SortingController>();
    final bool isSorting = sortingController.isSorting;
    final bool isPaused = sortingController.isPaused;
    final double animationSpeed = sortingController.animationSpeed; // Get speed from controller

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 700;

        double visualizerMaxAvailableWidth = _getEstimatedVisualizerAvailableWidth(
          constraints.maxWidth,
          isWideScreen,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (sortingController.bars.length != _prevBarCount ||
              (_currentBarWidth <= 0 && sortingController.bars.isNotEmpty) ||
              (_currentBarWidth > 0 && (visualizerMaxAvailableWidth - _getEstimatedBarWidthForCount(sortingController.bars.length, visualizerMaxAvailableWidth) * sortingController.bars.length - _getEstimatedBarGapForCount(sortingController.bars.length, visualizerMaxAvailableWidth) * (sortingController.bars.length -1) ).abs() > 1.0 )
              )
          {
            _updateBarDimensions(sortingController.bars.length, visualizerMaxAvailableWidth);
          }
          _prevBarCount = sortingController.bars.length;
        });

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: isWideScreen
              ? Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            // mainAxisSize: MainAxisSize.min, // THIS LINE IS REMOVED
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
                                readOnly: isSorting, // Disable input during sort
                                maxLength: 100,
                                onSubmitted: (_) {
                                  _processInputAndSetBars(sortingController, _inputController.text, visualizerMaxAvailableWidth);
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isSorting ? null : () {
                                        _processInputAndSetBars(sortingController, _inputController.text, visualizerMaxAvailableWidth);
                                      },
                                      icon: const Icon(Icons.data_array),
                                      label: const Text("Set Data"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isSorting ? null : () {
                                        sortingController.generateRandomBars(count: 20); // Use controller's method
                                        _inputController.text = sortingController.bars.map((e) => e.value.toString()).join(',');
                                        _updateBarDimensions(sortingController.bars.length, visualizerMaxAvailableWidth);
                                      },
                                      icon: const Icon(Icons.shuffle),
                                      label: const Text("Random"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: (isSorting && !isPaused) || sortingController.bars.isEmpty ? null : sortingController.startSorting,
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
                                      onPressed: sortingController.bars.isEmpty && !isSorting ? null : sortingController.stopSorting, // Stop button
                                      icon: const Icon(Icons.stop),
                                      label: const Text("Stop"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isSorting ? null : sortingController.clearBars, // Clear button
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
                                // FIX: Always allow changing speed
                                onChanged: sortingController.setAnimationSpeed,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),

                    Expanded(
                      flex: 5,
                      child: AnimatedBarDisplay(
                        bars: sortingController.bars,
                        // Pass dynamic animation speed to AnimatedBarDisplay
                        animationDuration: Duration(milliseconds: (1000 / animationSpeed).round()),
                        orientation: Axis.vertical,
                        barWidth: _currentBarWidth,
                        barGap: _currentBarGap,
                      ),
                    ),
                  ],
                )
              : Column( // Narrow screen layout
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisSize: MainAxisSize.min, // THIS LINE IS REMOVED
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
                              maxLength: 100,
                              onSubmitted: (_) {
                                _processInputAndSetBars(sortingController, _inputController.text, visualizerMaxAvailableWidth);
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isSorting ? null : () {
                                      _processInputAndSetBars(sortingController, _inputController.text, visualizerMaxAvailableWidth);
                                    },
                                    icon: const Icon(Icons.data_array),
                                    label: const Text("Set Data"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isSorting ? null : () {
                                      sortingController.generateRandomBars(count: 20);
                                      _inputController.text = sortingController.bars.map((e) => e.value.toString()).join(',');
                                      _updateBarDimensions(sortingController.bars.length, visualizerMaxAvailableWidth);
                                    },
                                    icon: const Icon(Icons.shuffle),
                                    label: const Text("Random"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: (isSorting && !isPaused) || sortingController.bars.isEmpty ? null : sortingController.startSorting,
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
                                    onPressed: sortingController.bars.isEmpty && !isSorting ? null : sortingController.stopSorting,
                                    icon: const Icon(Icons.stop),
                                    label: const Text("Stop"),
                                  ),
                                ),
                                const SizedBox(width: 10),
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
                              onChanged: sortingController.setAnimationSpeed, // FIX: Always allow changing speed
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Expanded(
                      child: AnimatedBarDisplay(
                        bars: sortingController.bars,
                        animationDuration: Duration(milliseconds: (1000 / animationSpeed).round()),
                        orientation: Axis.vertical,
                        barWidth: _currentBarWidth,
                        barGap: _currentBarGap,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  double _getEstimatedBarWidthForCount(int numberOfBars, double availableWidth) {
    if (numberOfBars == 0 || availableWidth <= 0) return 0.0;
    const double maxPreferredBarWidth = 30.0;
    const double minBarWidth = 4.0;
    const double preferredGapRatio = 0.10;

    double totalPreferredWidthWithGaps = (maxPreferredBarWidth * numberOfBars) +
                                         (maxPreferredBarWidth * preferredGapRatio * (numberOfBars - 1));

    double estimatedWidth;
    if (totalPreferredWidthWithGaps <= availableWidth) {
      estimatedWidth = maxPreferredBarWidth;
    } else {
      double effectiveBarAndGapCount = numberOfBars + (preferredGapRatio * (numberOfBars - 1));
      if (effectiveBarAndGapCount <= 0) effectiveBarAndGapCount = 1.0;
      estimatedWidth = availableWidth / effectiveBarAndGapCount;
    }
    return estimatedWidth.clamp(minBarWidth, maxPreferredBarWidth);
  }

  double _getEstimatedBarGapForCount(int numberOfBars, double availableWidth) {
    if (numberOfBars == 0 || availableWidth <= 0) return 0.0;
    return _getEstimatedBarWidthForCount(numberOfBars, availableWidth) * 0.10;
  }
}
