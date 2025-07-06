import 'package:flutter/material.dart';

class DifficultyTabs extends StatefulWidget {
  final ValueChanged<String> onDifficultySelected;
  final String initialDifficulty; // To highlight the selected tab

  const DifficultyTabs({
    super.key,
    required this.onDifficultySelected,
    this.initialDifficulty = 'All',
  });

  @override
  State<DifficultyTabs> createState() => _DifficultyTabsState();
}

class _DifficultyTabsState extends State<DifficultyTabs> {
  late int _selectedIndex;
  final List<String> _difficulties = ['All', 'Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    // Initialize selected index based on initialDifficulty
    _selectedIndex = _difficulties.indexOf(widget.initialDifficulty);
    if (_selectedIndex == -1) {
      _selectedIndex = 0; // Default to 'All' if not found
    }
  }

  @override
  void didUpdateWidget(covariant DifficultyTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected index if initialDifficulty changes externally
    if (widget.initialDifficulty != oldWidget.initialDifficulty) {
      _selectedIndex = _difficulties.indexOf(widget.initialDifficulty);
      if (_selectedIndex == -1) {
        _selectedIndex = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, // Fixed height for the tabs
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _difficulties.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          final difficulty = _difficulties[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(difficulty),
              selected: isSelected,
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).cardTheme.color,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onDifficultySelected(difficulty); // Call the callback
                }
              },
            ),
          );
        },
      ),
    );
  }
}