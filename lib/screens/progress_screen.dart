import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> daysOfWeek = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  final List<String> mealTimes = [
    '00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00', '08:00',
    '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00',
    '18:00', '19:00', '20:00', '21:00', '22:00', '23:00',
  ];

  Map<String, String> scheduledMeals = {};

  Stream<List<Map<String, dynamic>>> getSavedFoodSelections() {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection("foodSelections")
        .where("userId", isEqualTo: currentUser.uid)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> saveScheduledMeal(String day, String time, String menuName) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    String docId = "${currentUser.uid}_${day}_$time";
    DateTime now = DateTime.now();
    DateTime dateForDay = now.add(Duration(days: daysOfWeek.indexOf(day) - now.weekday + 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateForDay);

    try {
      await _firestore.collection("scheduledMeals").doc(docId).set({
        "userId": currentUser.uid,
        "day": day,
        "time": time,
        "menuName": menuName,
        "date": formattedDate,
        "timestamp": FieldValue.serverTimestamp(),
      });
      setState(() {
        scheduledMeals["${day}_$time"] = menuName;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Öğün kaydetme hatası: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Öğün kaydedilirken bir hata oluştu: $e")),
      );
    }
  }

  Future<void> removeScheduledMeal(String day, String time) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    String docId = "${currentUser.uid}_${day}_$time";

    try {
      await _firestore.collection("scheduledMeals").doc(docId).delete();
      setState(() {
        scheduledMeals.remove("${day}_$time");
      });
    } catch (e) {
      if (kDebugMode) {
        print("Öğün silme hatası: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Öğün silinirken bir hata oluştu: $e")),
      );
    }
  }

  Future<void> loadScheduledMeals() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    DateTime now = DateTime.now();
    List<String> currentWeekFormattedDates = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i - now.weekday + 1));
      currentWeekFormattedDates.add(DateFormat('yyyy-MM-dd').format(date));
    }

    try {
      QuerySnapshot snapshot = await _firestore
          .collection("scheduledMeals")
          .where("userId", isEqualTo: currentUser.uid)
          .where("date", whereIn: currentWeekFormattedDates)
          .get();

      Map<String, String> loadedMeals = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String day = data["day"];
        String time = data["time"];
        String menuName = data["menuName"];
        loadedMeals["${day}_$time"] = menuName;
      }
      setState(() {
        scheduledMeals = loadedMeals;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Planlanmış öğünleri yükleme hatası: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadScheduledMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E7DD),
      appBar: AppBar(
        title: const Text(
          "İlerleme Takvimi",
          style: TextStyle(color: Color(0xFF800020)),
        ),
        backgroundColor: const Color(0xFFD6A7B1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF800020)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Bu Hafta: ${DateFormat('dd MMM').format(DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)))} - ${DateFormat('dd MMM').format(DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)))}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF800020),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: getSavedFoodSelections(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Yemek listeleri yüklenirken hata oluştu: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("Henüz kaydedilmiş yemek listeniz yok."));
                    }

                    final List<Map<String, dynamic>> availableFoodLists = snapshot.data!;

                    return DataTable(
                      border: TableBorder.all(color: const Color(0xFF800020).withOpacity(0.5)),
                      columnSpacing: 12.0,
                      dataRowMinHeight: 60.0,
                      dataRowMaxHeight: 80.0,
                      columns: [
                        const DataColumn(
                          label: Text(
                            'Saat / Gün',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B0010)),
                          ),
                        ),
                        for (String day in daysOfWeek)
                          DataColumn(
                            label: Text(
                              day,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B0010)),
                            ),
                          ),
                      ],
                      rows: mealTimes.map((time) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Container(
                                width: 80,
                                alignment: Alignment.center,
                                child: Text(
                                  time,
                                  style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF800020)),
                                ),
                              ),
                            ),
                            for (String day in daysOfWeek)
                              DataCell(
                                GestureDetector(
                                  onTap: () {
                                    _showFoodListSelectionDialog(context, day, time, availableFoodLists);
                                  },
                                  onLongPress: () {
                                    if (scheduledMeals.containsKey("${day}_$time")) {
                                      _showRemoveMealDialog(context, day, time);
                                    }
                                  },
                                  child: Container(
                                    width: 120,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: scheduledMeals.containsKey("${day}_$time")
                                          ? const Color(0xFFF5E7D0)
                                          : const Color(0xFFFBF4ED),
                                      border: Border.all(color: Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        scheduledMeals["${day}_$time"] ?? 'Menü Ekle',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: scheduledMeals.containsKey("${day}_$time")
                                              ? const Color(0xFF6B0010)
                                              : Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFoodListSelectionDialog(
      BuildContext context,
      String day,
      String time,
      List<Map<String, dynamic>> availableFoodLists,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$day - $time İçin Menü Seç"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableFoodLists.length,
              itemBuilder: (context, index) {
                final foodList = availableFoodLists[index];
                return ListTile(
                  title: Text(foodList["name"] ?? "Adsız Liste"),
                  subtitle: Text((foodList["items"] as List).join(", ")),
                  onTap: () {
                    saveScheduledMeal(day, time, foodList["name"]);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("İptal"),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveMealDialog(BuildContext context, String day, String time) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$day - $time İçin Menüyü Kaldır"),
          content: const Text("Bu öğünü listeden kaldırmak istediğinizden emin misiniz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () {
                removeScheduledMeal(day, time);
                Navigator.of(context).pop();
              },
              child: const Text("Kaldır"),
            ),
          ],
        );
      },
    );
  }
}