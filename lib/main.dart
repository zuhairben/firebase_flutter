import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Weekly Expense",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text(
                        "View Report",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "From 1 - 6 Apr, 2024",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 400,
                  child: Center(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 45,
                          right: 161,
                          child: CircleAvatar(
                            radius: 125,
                            backgroundColor: Colors.purple.shade100,
                            child: const Text(
                              "48%",
                              style: TextStyle(
                                fontSize: 48,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 250,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.green.shade100,
                            child: const Text(
                              "32%",
                              style: TextStyle(
                                fontSize: 36,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 190,
                          right: 50,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.red.shade100,
                            child: const Text(
                              "13%",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 170,
                          right: 0,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.orange.shade100,
                            child: const Text(
                              "7%",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        LegendItem(
                          color: Colors.purple,
                          title: "Grocery",
                          amount: "\$758.20",
                        ),
                        LegendItem(
                          color: Colors.green,
                          title: "Food & Drink",
                          amount: "\$758.20",
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        LegendItem(
                          color: Colors.red,
                          title: "Shopping",
                          amount: "\$758.20",
                        ),
                        LegendItem(
                          color: Colors.orange,
                          title: "Transportation",
                          amount: "\$758.20",
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String amount;

  const LegendItem({
    super.key,
    required this.color,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: color,
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          amount,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
