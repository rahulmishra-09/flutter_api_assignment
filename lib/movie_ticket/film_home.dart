import 'dart:async';
import 'dart:convert';
import 'package:climafy/color.dart';
import 'package:climafy/movie_ticket/film_view.dart';
import 'package:climafy/movie_ticket/search_movie_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class FilmHome extends StatefulWidget {
  const FilmHome({super.key});

  @override
  State<FilmHome> createState() => _FilmHomeState();
}

class _FilmHomeState extends State<FilmHome> {
  final String apiKey = '522b971774749a06c2f200b4a4fe6872';
  List<dynamic> movies = [];
  bool isLoading = false;

  Future<void> fetchMovieData() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
      'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          movies = data['results'];
          print(movies);
        });
      } else {
        throw Exception('Failed to load movie');
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
  void initState() {
    fetchMovieData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: movieBackground,
      appBar: AppBar(
        backgroundColor: appBarBackground,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
        title: Text(
          'FilmFacto',
          style: GoogleFonts.merienda(
            fontWeight: FontWeight.w900,
            color: darkSilver,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchMovieScreen()),
              );
            },
            icon: Icon(Icons.search, color: darkSilver),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child:
            isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    color: metalicSilver,
                    strokeWidth: 3.0,
                  ),
                )
                : movies.isEmpty
                ? Center(
                  child: Text(
                    'No Movie Yet!',
                    style: GoogleFonts.merienda(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: darkSilver,
                    ),
                  ),
                )
                : Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 200,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      final imageUrl =
                          'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => FilmView(
                                    poster: imageUrl,
                                    mediaType: movie['media_type'],
                                    overview: movie['overview'],
                                    title: movie['title'],
                                    releaseDate: movie['release_date'],
                                    vote: movie['vote_average'],
                                    voteCount: movie['vote_count'],
                                    language: movie['original_language'],
                                    isAdult: movie['adult'],
                                  ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.fill,
                                height: 150,
                                width: double.maxFinite,
                              ),
                            ),
                            Text(
                              movie['title'] ?? 'No Title',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'On: ${movie['release_date']}',
                              style: GoogleFonts.aBeeZee(
                                color: metalicSilver,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
