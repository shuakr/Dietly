// lib/screens/home_screen.dart


import 'package:dietly/widgets/food_list_card.dart';
import 'package:dietly/widgets/progress_card.dart';
import 'package:dietly/widgets/recipes_list_card.dart';
import 'package:flutter/material.dart';
import '../widgets/salomon_bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E7DD),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF6B0010).withOpacity(0.75),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.home,
              color: Colors.white,
              size: 50,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top:24.0, bottom:12),
                  child: Center(
                    child: Center(
                      child: Image.asset(
                          "assets/dietlylogo.png",
                          height:280,
                      ),
                    ),
                  ),
              ),
              const FoodListCard(),
              const RecipeListCard(),
              const ProgressCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(initialIndex: 0), //Salomon bottom bar
    );
  }
}
