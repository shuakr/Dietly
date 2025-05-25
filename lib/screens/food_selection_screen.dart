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

  void saveSelectedItems() {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Name Your Selection"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter name here"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty && selectedItems.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection("foodSelections")
                      .add({
                    "name": name,
                    "items": selectedItems,
                    "timestamp": FieldValue.serverTimestamp(),
                  });

                  setState(() {
                    selectedItems.clear();
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Stream<QuerySnapshot> getSelectionsStream() {
    return FirebaseFirestore.instance
        .collection("foodSelections")
        .orderBy("timestamp", descending: true)
        .snapshots();
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
        body: TabBarView(
          children: [
            // Food Selection Tab
            Stack(
              children: [
                ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = selectedItems.contains(item["name"]!);
                    return ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF5E7D0)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image.asset(
                          "assets/foods/${item["icon"]}",
                          width: 40,
                          height: 40,
                        ),
                      ),
                      title: Text(item["name"]!),
                      trailing: Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                      onTap: () => toggleSelection(item["name"]!),
                    );
                  },
                ),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    onPressed: saveSelectedItems,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.save, color: Color(0xFFF5E7D0)),
                  ),
                ),
              ],
            ),

            // Saved Selections Tab
            StreamBuilder<QuerySnapshot>(
              stream: getSelectionsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No saved selections yet."));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(data["name"] ?? "Unnamed"),
                        subtitle: Text((data["items"] as List).join(", ")),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
