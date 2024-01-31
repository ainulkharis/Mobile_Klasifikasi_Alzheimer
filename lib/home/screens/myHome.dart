import 'package:e_alzaimer/home/screens/Riwayat.dart';
import 'package:flutter/material.dart';
import 'package:e_alzaimer/home/screens/Chatbot.dart';
import 'package:e_alzaimer/home/screens/Komentar.dart';

class Article {
  final String title;
  final String imageUrl;

  Article({
    required this.title,
    required this.imageUrl,
  });
}

class myHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<myHome> {
  final List<Article> articles = [
    Article(
      title: 'Gejala Dimensia',
      imageUrl: 'assets/gejala_dimensia.jpg',
    ),
    Article(
      title: 'Tahapan Alzheimer',
      imageUrl: 'assets/tahapan_alzaimer.jpg',
    ),
    Article(
      title: 'Apa Itu Alzheimer',
      imageUrl: 'assets/gejala_dimensia.jpg',
    ),
  ];

  TextEditingController searchController = TextEditingController();
  List<Article> filteredArticles = [];

  @override
  void initState() {
    super.initState();
    filteredArticles = List.from(articles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.blue, // Change the background color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Temukan Artikel Anda',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      performSearch();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Change the button color
                    ),
                    child: Text('Cari', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),

            Container(
              height: 200,
              color: Colors.white, // Change the background color
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ChatbotCard(),
                  ),
                  Expanded(
                    child: KomentarCard(),
                  ),
                  Expanded(
                    child: RiwayatCard(),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white, // Change the background color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Artikel Tentang Alzheimer',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 250,
                    child: PageView.builder(
                      itemCount: filteredArticles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5.0,
                            child: Column(
                              children: [
                                Image.asset(
                                  filteredArticles[index].imageUrl,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    filteredArticles[index].title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void performSearch() {
    String query = searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredArticles = List.from(articles);
      } else {
        filteredArticles = articles
            .where((article) => article.title.toLowerCase().contains(query))
            .toList();
      }
    });
  }
}
