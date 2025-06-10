import 'dart:convert';

import 'package:climafy/color.dart';
import 'package:climafy/news/news_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchNews extends StatefulWidget {
  const SearchNews({super.key});

  @override
  State<SearchNews> createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  final searchController = TextEditingController();
  final String apiKey = '525b3272a5074342a509e62b3d96a7c8';
  List<dynamic> articles = [];

  Future<void> searchNews(String query) async {
    final stringUrl =
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=$apiKey';
    final url = Uri.parse(stringUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          articles = data['articles'];
        });
        print(data);
      } else {
        print('Failed to fetch url');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transparent = Colors.transparent;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navyBlue,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: darkSilver),
        ),
        title: Text(
          'Search News',
          style: GoogleFonts.merienda(
            fontWeight: FontWeight.w900,
            color: darkSilver,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    autofocus: true,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,

                    decoration: InputDecoration(
                      hintText: 'Search news...',
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: Icon(Icons.clear, color: black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: transparent),
                      ),
                      filled: true,
                      fillColor: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: FloatingActionButton(
                    onPressed: () => searchNews(searchController.text.trim()),
                    shape: CircleBorder(),
                    backgroundColor: appBarBackground,
                    child: Icon(Icons.arrow_forward_ios, color: darkSilver),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child:
                  articles.isEmpty
                      ? Center(child: Text('Search news...'))
                      : ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          final imageUrl = article['urlToImage'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => NewsResultScreen(article: article),
                                ),
                              );
                            },
                            child: ListTile(
                              leading:
                                  imageUrl != null
                                      ? ClipRRect(
                                        child: Image(
                                          image: NetworkImage(imageUrl),
                                          height: 60,
                                          width: 40,
                                        ),
                                      )
                                      : SizedBox(
                                        height: 60,
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                              title: Text(
                                article['title'] ?? 'No title',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                article['author'] ?? 'No author',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
