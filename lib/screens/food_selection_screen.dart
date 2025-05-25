import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodSelectionScreen extends StatefulWidget {
  const FoodSelectionScreen({Key? key}) : super(key: key);

  @override
  State<FoodSelectionScreen> createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  final List<String> selectedItems = [];

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
    Siz
