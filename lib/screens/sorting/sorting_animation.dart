import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample01/my-reference/Animation_visualizer/controllers/sorting_controller.dart';

import 'package:sample01/my-reference/Animation_visualizer/types/sort_algorithm.dart';
import 'package:sample01/screens/sorting/tabs/animation_tab.dart';
import 'package:sample01/screens/sorting/tabs/chatting.dart'; // Ensure this is imported for the typedef

class SortingAnimationScreen extends StatefulWidget {
  final String algorithmName;
  final SortAlgorithm sortAlgorithm; // Accept the specific algorithm function

  const SortingAnimationScreen({
    super.key,
    required this.algorithmName,
    required this.sortAlgorithm,
  });

  @override
  State<SortingAnimationScreen> createState() => _SortingAnimationScreenState();
}

class _SortingAnimationScreenState extends State<SortingAnimationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SortingController(
        sortAlgorithm: widget.sortAlgorithm, // Use the passed algorithm
        initialValues: const [20, 5, 35, 10, 40, 15, 30, 25], // Default initial values
        barColor: Colors.blueGrey, // Customize base bar color
        activeColor: Colors.cyanAccent, // Customize active color
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.algorithmName} Visualization'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Animation Controls', icon: Icon(Icons.animation)),
              Tab(text: 'Chatting', icon: Icon(Icons.chat)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            AnimationTab(),
            ChattingTab(),
          ],
        ),
      ),
    );
  }
}