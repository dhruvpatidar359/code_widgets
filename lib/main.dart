// import 'dart:convert';

import 'dart:convert';
import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
// import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "simpleTask") {
      // WidgetsToImageController to access widget

      HomeWidget.saveWidgetData("quote", "HI ALL");
      HomeWidget.saveWidgetData("author", "MY NAEM ");
      HomeWidget.saveWidgetData('filename', "BYE");

      HomeWidget.updateWidget(
        androidName: "QuoteWidget",
      );
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager()
      .registerOneOffTask("task-identifier", "simpleTask", inputData: Map());

  Workmanager().registerPeriodicTask(
    "periodic-task-identifier",
    "simplePeriodicTask",

    // When no frequency is provided the default 15 minutes is set.
    // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
    frequency: Duration(minutes: 15),
  );

  runApp(const HomePage());
}

const String url = "https://api.quotable.io/random";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String author = "";
  String quote = "";

  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final Directory p = await getApplicationDocumentsDirectory();
            String path = p.path;
            final XFile? image =
                await ImagePicker().pickImage(source: ImageSource.gallery);
// copy the file to a new path
            await image?.saveTo('$path/image1.png');

            setState(() {
              imagePath = "$path/image1.png";
            });
            print(imagePath);
            _fetchQuote();
          },
          child: const Icon(Icons.refresh),
        ),
        appBar: AppBar(title: const Text("Quotes")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  quote,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("- $author"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchQuote() async {
    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);
    setState(() {
      quote = data["content"];
      author = data["author"];
    });
    updateAndroidWidget(quote, author);
  }

  void updateAndroidWidget(String quote, String author) {
    HomeWidget.saveWidgetData("quote", quote);
    HomeWidget.saveWidgetData("author", author);
    HomeWidget.saveWidgetData('filename', imagePath);

    HomeWidget.updateWidget(
      androidName: "QuoteWidget",
    );
  }
}
