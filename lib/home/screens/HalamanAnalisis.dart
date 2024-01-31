import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HalamanSetelahAnalisisSentimen extends StatelessWidget {
  final String analisisSentimenResult;

  HalamanSetelahAnalisisSentimen({required this.analisisSentimenResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Analisis Sentimen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hasil Analisis Sentimen:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              analisisSentimenResult,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigasi kembali ke halaman sebelumnya
                Navigator.pop(context);
              },
              child: Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalisisCard extends StatefulWidget {
  @override
  _AnalisisSentimenCardState createState() => _AnalisisSentimenCardState();
}

class _AnalisisSentimenCardState extends State<AnalisisCard> {
  String analisisSentimenResult = 'Hasil analisis sentimen';

  // Metode untuk melakukan analisis sentimen dan menavigasi ke halaman tertentu setelahnya
  Future<void> _performSentimentAnalysisAndNavigate(String comment) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/analisis_sentimen'), // Ganti sesuai dengan endpoint analisis sentimen
        body: {'comment': comment},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String analisisSentimenResult = data['sentiment'];

        // Navigasi ke halaman setelah analisis sentimen dengan hasilnya
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalamanSetelahAnalisisSentimen(
              analisisSentimenResult: analisisSentimenResult,
            ),
          ),
        );
      } else {
        // Handle jika terjadi kesalahan saat mengambil respons dari server
        print('Gagal melakukan analisis sentimen');
      }
    } catch (e) {
      // Handle kesalahan lainnya
      print('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Tambahkan logika untuk mendapatkan komentar dari pengguna, misalnya dari TextField
        String userComment = "Komentar yang diinput oleh pengguna";

        // Panggil metode untuk melakukan analisis sentimen
        await _performSentimentAnalysisAndNavigate(userComment);
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
            Icons.comment,
            size: 50,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
