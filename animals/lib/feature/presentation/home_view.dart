import 'package:animals/feature/presentation/animals_view.dart';
import 'package:animals/feature/presentation/fruits_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Color themeColor = const Color(0xFF282b30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text(
          'Inglês básico para crianças',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: themeColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AnimalView()),
                    );
                  },
                  highlightColor: Colors.white,
                  child: Card(
                    color: const Color(0xFF424549),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Image.asset(
                            'assets/images/lion.png',
                            fit: BoxFit.fitHeight,
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Animais',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FruitView()),
                    );
                  },
                  highlightColor: Colors.white,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Image.asset(
                            'assets/images/fruits/apple.png',
                            fit: BoxFit.fitHeight,
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Frutas',
                          style: TextStyle(
                            color: Color(0xFF424549),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
