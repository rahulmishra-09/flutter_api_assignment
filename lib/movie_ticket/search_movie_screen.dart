import 'dart:convert';

import 'package:climafy/color.dart';
import 'package:climafy/movie_ticket/film_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchMovieScreen extends StatefulWidget {
  const SearchMovieScreen({super.key});

  @override
  State<SearchMovieScreen> createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  final searchController = TextEditingController();
  final String apiKey = '522b971774749a06c2f200b4a4fe6872';
  bool isLoading = false;
  bool hasSearched = false;
  List<dynamic> searchResult = [];

  Future<void> searchMovie(String query) async {
    setState(() {
      isLoading = true;
      hasSearched = true;
    });
    final url = Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          searchResult = data['results'];
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transparent = Colors.transparent;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: appBarBackground,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: metalicSilver),
        ),
        title: Text(
          'Search Movie',
          style: GoogleFonts.merienda(
            color: metalicSilver,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: searchController,
              autofocus: true,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,

              decoration: InputDecoration(
                hintText: 'Search movie...',
                suffixIcon: IconButton(
                  onPressed: () {
                    searchMovie(searchController.text.trim());
                  },
                  icon: Icon(Icons.search, color: black),
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
            const SizedBox(height: 30),
            isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    color: darkSilver,
                  ),
                )
                : hasSearched && searchResult.isEmpty
                ? Center(
                  child: Text(
                    'No result found',
                    style: GoogleFonts.merienda(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: darkSilver,
                    ),
                  ),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: searchResult.length,
                    itemBuilder: (context, index) {
                      final movie = searchResult[index];
                      final imageUrl =
                          'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => FilmView(
                                    poster: imageUrl,
                                    overview: movie['overview'],
                                    mediaType: movie['media_type'] ?? '',
                                    releaseDate: movie['release_date'],
                                    title: movie['title'],
                                    vote: movie['vote_average'],
                                    voteCount: movie['vote_count'],
                                    language: movie['original_language'],
                                    isAdult: movie['adult'],
                                  ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: ClipRRect(
                            child:
                                movie['poster_path'] != null
                                    ? Image(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                      color: Colors.grey[900],
                                      height: 60,
                                      width: 40,
                                    )
                                    : Container(
                                      height: 60,
                                      width: 40,
                                      color: Colors.grey[600],
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.red,
                                      ),
                                    ),
                          ),
                          title: Text(
                            movie['title'] ?? 'No Title',
                            style: GoogleFonts.pacifico(
                              color: darkMetalic,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            'On: ${movie['release_date']}',
                            style: GoogleFonts.alata(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: metalicSilver,
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
