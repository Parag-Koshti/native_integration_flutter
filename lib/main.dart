import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var channel = MethodChannel("Hello");
  String _result = '';
  showToast() {
    channel.invokeListMethod(
        "showToast", {'message': "This is native function called"});
  }

  showData() {
    channel.invokeMethod("showData",
        {'name': nameController.text, 'phone': phoneController.text});
  }

  Future<void> sendtoNative() async {
    try {
      String result = await channel.invokeMethod("proccessData",
          {'name': nameController.text, 'phone': phoneController.text});
      print("result:$result");
      setState(() {
        _result = result;
        print("result:$_result");
      });
    } on PlatformException catch (e) {
      setState(() {
        _result = "Failed to get result: ${e.message}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Native Integration",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "Enter Your Name",
                  label: Text("name"),
                  prefixIcon: Icon(Icons.person)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "Enter Your Number",
                  label: Text("phone"),
                  prefixIcon: Icon(Icons.call)),
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black)),
              onPressed: () {
                showToast();
                sendtoNative();
                showData();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
