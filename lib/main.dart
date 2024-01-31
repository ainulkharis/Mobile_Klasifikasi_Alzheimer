import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home/screens/myHome.dart';
import 'klasifikasi/screens/myKlasifikasi.dart';
import 'profile/screens/myProfile.dart';
import 'auth/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // Change this to LoginScreen,
      routes: {
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  File? uploadedImage;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        uploadedImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      uploadedImage = null;
    });
  }

  Future<void> _replaceImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        uploadedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          title: Text(
            'E-Alzhaimer',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          myHome(),
          myKlasifikasi(),
          myProfile(),
        ],
      ),
      bottomNavigationBar: GFTabBar(
        indicatorColor: Color.fromARGB(255, 255, 254, 254),
        length: 3,
        controller: tabController,
        tabs: [
          Tab(
            icon: Icon(Icons.home),
            child: Text("Home"),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.brain),
            child: Text("Klasifikasi"),
          ),
          Tab(
            icon: Icon(Icons.person),
            child: Text("Profil"),
          ),
        ],
      ),
    );
  }
}
