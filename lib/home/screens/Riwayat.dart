import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiwayatCard extends StatefulWidget {
  @override
  _RiwayatCardState createState() => _RiwayatCardState();
}

class _RiwayatCardState extends State<RiwayatCard> {
  List<Map<String, dynamic>> riwayatData = [];

  @override
  void initState() {
    super.initState();
    // Fetch classification history when the widget is initialized
    fetchRiwayatData();
  }

  Future<void> fetchRiwayatData() async {
    final response = await http.get(Uri.parse('https://4b5a-114-142-169-30.ngrok-free.app/get_riwayat_klasifikasi'));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final List<dynamic> data = json.decode(response.body)['riwayat_klasifikasi'];
      setState(() {
        riwayatData = data.cast<Map<String, dynamic>>();
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RiwayatDetail(riwayatData)),
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
                Colors.red,
                Colors.purple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            Icons.history,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class RiwayatDetail extends StatelessWidget {
  final List<Map<String, dynamic>> riwayatData;

  RiwayatDetail(this.riwayatData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman Detail Riwayat"),
      ),
      body: ListView.builder(
        itemCount: riwayatData.length,
        itemBuilder: (context, index) {
          final data = riwayatData[index];
          return Card(
  elevation: 5.0,
  margin: EdgeInsets.all(8.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
  child: ListTile(
    contentPadding: EdgeInsets.all(16.0),
    title: Text(
      'Nama: ${data['nama']}',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Text(
          'Tanggal: ${data['tanggal']}',
          style: TextStyle(fontSize: 14.0),
        ),
        Text(
          'Umur: ${data['umur']}',
          style: TextStyle(fontSize: 14.0),
        ),
        Text(
          'Jenis Kelamin: ${data['jenis_kelamin']}',
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(height: 8.0),
        Divider(color: Colors.grey),
        SizedBox(height: 8.0),
        Text(
          'Klasifikasi Class: ${data['klasifikasi_class']}',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          'Probabiliti: ${data['probabiliti']}',
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.green,
          ),
        ),
      ],
    ),
  ),
);

        },
      ),
    );
  }
}
