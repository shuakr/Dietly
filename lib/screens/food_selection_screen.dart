import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodSelectionScreen extends StatefulWidget {
  const FoodSelectionScreen({Key? key}) : super(key: key);

  @override
  State<FoodSelectionScreen> createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  final List<Map<String, String>> items = [
    {"name": "army-stew", "icon": "army-stew.png"},
    {"name": "ayran", "icon": "ayran.png"},
    {"name": "black-tea", "icon": "black-tea.png"},
    {"name": "bread", "icon": "bread.png"},
    {"name": "butter", "icon": "butter.png"},
    {"name": "cereals", "icon": "cereals.png"},
    {"name": "cheese", "icon": "cheese.png"},
    {"name": "chicken", "icon": "chicken.png"},
    {"name": "coffee-cup", "icon": "coffee-cup.png"},
    {"name": "fried-egg", "icon": "fried-egg (1).png"},
    {"name": "honey", "icon": "honey.png"},
    {"name": "kebab", "icon": "kebab.png"},
    {"name": "olives", "icon": "olives.png"},
    {"name": "salad", "icon": "salad.png"},
    {"name": "sandwich", "icon": "sandwich.png"},
    {"name": "soup", "icon": "soup.png"},
    {"name": "steak", "icon": "steak.png"},
  ];

  final List<String> selectedItems = [];

  void toggleSelection(String item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Food Selection",
            style: TextStyle(color: Color(0xFFF5E7D0)),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFF5E7D0)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFFF5E7D0),
            labelColor: Color(0xFFF5E7D0),
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Food Screen"),
              Tab(text: "Saved Selections"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SizedBox(),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
