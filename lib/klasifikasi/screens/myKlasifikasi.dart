import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flask Integration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: myKlasifikasi(),
    );
  }
}

class myKlasifikasi extends StatefulWidget {
  @override
  _MyKlasifikasiState createState() => _MyKlasifikasiState();
}

class _MyKlasifikasiState extends State<myKlasifikasi> with SingleTickerProviderStateMixin {
  File? _image;
  String _classificationResult = '';
  double _probability = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

 Future<void> _getImage() async {
  final imagePicker = ImagePicker();

  try {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile == null) {
        // Pengguna membatalkan pemilihan gambar
        return;
      }

      _image = File(pickedFile.path);
      _classificationResult = '';
      _probability = 0.0;
    });
  } catch (e) {
    // Tangani pengecualian "already_active"
    print('Pemilih gambar sudah aktif');
  }
}


  Future<void> _classifyImage() async {
    if (_image == null) {
      return;
    }

    final uri = Uri.parse('https://4b5a-114-142-169-30.ngrok-free.app/api');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final result = json.decode(responseBody);

      setState(() {
        _classificationResult = result['klasifikasi_class'] ?? 'Result not available';
        _probability = result['probabiliti'] ?? 0.0;
        _controller.forward(from: 0.0);
      });
    } catch (error) {
      print('Error: $error');
      setState(() {
        _classificationResult = 'Error during classification';
        _probability = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Flask Integration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              width: 200.0,
              height: 200.0,
              child: _image != null
                  ? ScaleTransition(
                      scale: _animation,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.file(
                          _image!,
                          height: 150.0,
                          width: 150.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.image,
                      size: 100.0,
                      color: Colors.grey,
                    ),
            ),
            ElevatedButton(
  onPressed: _getImage,
  style: ElevatedButton.styleFrom(
    primary: Colors.blue,
  ),
  child: Text(
    'Choose Image',
    style: TextStyle(
      color: Color.fromARGB(255, 255, 255, 255), // Ganti warna teks sesuai kebutuhan
    ),
  ),
),

            SizedBox(height: 20.0),
           ElevatedButton(
  onPressed: _classifyImage,
  style: ElevatedButton.styleFrom(
    primary: Colors.green,
  ),
  child: Text(
    'Classify Image',
    style: TextStyle(
      color: Colors.white, // Ganti warna teks sesuai kebutuhan
    ),
  ),
),

            SizedBox(height: 20.0),
            Text(
              'Classification Result:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              _classificationResult,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Probability: ${_probability.toStringAsFixed(2)}%',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
