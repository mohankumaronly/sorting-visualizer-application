import 'package:flutter/material.dart';
import 'package:sample01/my-reference/Animation_visualizer/algorithms/bubble_sort_algorithm.dart';
import 'package:sample01/screens/sorting/sorting_animation.dart';
import 'package:sample01/widgets/algorithm_card.dart';
import 'package:sample01/widgets/difficulty_tabs.dart';
import 'package:sample01/widgets/search_bar.dart'; // Import the specific algorithm
// Import other algorithms when they are implemented
// import 'package:sample01/my-reference/Animation_visualizer/algorithms/quick_sort_algorithm.dart';
// import 'package:sample01/my-reference/Animation_visualizer/algorithms/merge_sort_algorithm.dart';
// import 'package:sample01/my-reference/Animation_visualizer/algorithms/heap_sort_algorithm.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedDifficulty = 'All'; // Default filter

  // Define your list of all available algorithms
  // This can be moved to a separate data file if it grows large
  final List<Map<String, dynamic>> _allAlgorithms = [
    {
      'name': 'Bubble Sort',
      'description': 'A simple comparison-based sorting algorithm. It repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order.',
      'difficulty': 'Easy',
      'algorithm': bubbleSort, // Reference to the actual algorithm function
    },
    {
      'name': 'Quick Sort',
      'description': 'An efficient, in-place sorting algorithm. Developed by Tony Hoare.',
      'difficulty': 'Medium',
      'algorithm': null, // Placeholder for unimplemented algorithms
      'isComingSoon': true,
    },
    {
      'name': 'Merge Sort',
      'description': 'A divide and conquer algorithm. It divides input array into two halves, calls itself for the two halves, and then merges the two sorted halves.',
      'difficulty': 'Medium',
      'algorithm': null,
      'isComingSoon': true,
    },
    {
      'name': 'Heap Sort',
      'description': 'A comparison-based sorting technique based on binary heap data structure.',
      'difficulty': 'Hard',
      'algorithm': null,
      'isComingSoon': true,
    },
    // Add other algorithm entries here
  ];

  List<Map<String, dynamic>> get _filteredAlgorithms {
    List<Map<String, dynamic>> filteredList = _allAlgorithms;

    // Apply difficulty filter
    if (_selectedDifficulty != 'All') {
      filteredList = filteredList
          .where((algo) => algo['difficulty'] == _selectedDifficulty)
          .toList();
    }

    // Apply search query filter
    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList
          .where((algo) =>
              algo['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filteredList;
  }

  void _onSearchQueryChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onDifficultySelected(String difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredAlgorithms = _filteredAlgorithms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualize AI'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Visualize AI!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 24),

            // Search Bar
            CustomSearchBar(
              onChanged: _onSearchQueryChanged, // Pass the callback
            ),
            const SizedBox(height: 24),

            // Difficulty Tabs
            DifficultyTabs(
              onDifficultySelected: _onDifficultySelected, // Pass the callback
              initialDifficulty: _selectedDifficulty, // Keep selected tab highlighted
            ),
            const SizedBox(height: 24),

            Text(
              'Algorithms', // Changed from 'Sorting Algorithms' to 'Algorithms' for broader scope
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 16),

            // Algorithm Cards Grid
            if (filteredAlgorithms.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 60, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text(
                        'No results found for your search or filter.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: filteredAlgorithms.map((algoData) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0), // Add spacing between cards
                    child: AlgorithmCard(
                      algorithmName: algoData['name'],
                      description: algoData['description'],
                      difficulty: algoData['difficulty'],
                      onAnimatePressed: algoData['isComingSoon'] == true
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${algoData['name']} not yet implemented.')),
                              );
                            }
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SortingAnimationScreen(
                                    algorithmName: algoData['name'],
                                    sortAlgorithm: algoData['algorithm'],
                                  ),
                                ),
                              );
                            },
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}