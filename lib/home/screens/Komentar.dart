import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KomentarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RumahSakitDetail()),
        );
      },
      child: Card(
        elevation: 5.0,
        child: Container(
          width: 100,
          height: 100,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 4, 134, 248),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
           FontAwesomeIcons.comment,
            size: 50,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class RumahSakitDetail extends StatefulWidget {
  @override
  _RumahSakitDetailState createState() => _RumahSakitDetailState();
}

class _RumahSakitDetailState extends State<RumahSakitDetail> {
  TextEditingController komentarController = TextEditingController();

  // Method untuk menampilkan SnackBar
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Durasi tampilan SnackBar
      ),
    );
  }

  // Method untuk mengirim komentar ke server
  Future<void> kirimKomentar(String komentar) async {
    try {
      final response = await http.post(
        Uri.parse('https://4b5a-114-142-169-30.ngrok-free.app/kirim-komentar'),
        body: {'comment': komentar, 'sentiment':  'netral'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String message = data['message'];

        // Tampilkan SnackBar ketika komentar berhasil dikirim
        showSnackBar(context, message);
      } else {
        print('Gagal mengirim komentar');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman Komentar"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Berikan Komentar Anda",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: komentarController,
              decoration: InputDecoration(
                labelText: "Komentar",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Ambil komentar dari controller dan kirim ke server
                String komentar = komentarController.text;
                await kirimKomentar(komentar);
              },
              child: Text("Kirim Komentar"),
            ),
          ],
        ),
      ),
    );
  }
}
