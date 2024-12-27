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
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recommended for your devices",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Product Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bookmark Icon
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.bookmark_outline,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Product Image
                      Center(
                        child: Image.asset(
                          'assets/images/airpodsmaxsilver.jpg', // Replace with any image URL
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Free Engraving Text
                      Center(
                        child: Text(
                          "Free Engraving",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Product Title
                      Center(
                        child: Text(
                          "AirPods Max — Silver",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "A\$899.00",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "+1 more",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Color Options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var color in [Colors.black, Colors.red, Colors.green, Colors.blue])
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: color,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
