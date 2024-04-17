import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _globalKey = GlobalKey();
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather ha bhai"),
      ),
      // New: replace the FloatingActionButton
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // updateHeadline(widget.article);
        },
        label: const Text('Update Homescreen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'kerdo yar',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20.0),
          Text('kerdo yar'),
          const SizedBox(height: 20.0),
          Center(
            // New: Add this key
            key: _globalKey,
            child: Text('kerdo yar'),
          ),
          const SizedBox(height: 20.0),
          Text('kerdo yar'),
        ],
      ),
    );
  }
}
