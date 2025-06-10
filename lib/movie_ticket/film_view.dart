import 'package:climafy/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilmView extends StatelessWidget {
  const FilmView({
    super.key,
    required this.poster,
    required this.overview,
    required this.mediaType,
    required this.releaseDate,
    required this.title,
    required this.vote,
    required this.voteCount,
    required this.language,
    required this.isAdult,
  });

  final String poster;
  final String title;
  final String releaseDate;
  final String overview;
  final String mediaType;
  final double vote;
  final int voteCount;
  final String language;
  final bool isAdult;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: grey,

      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 32,
                color: Colors.transparent,
                child: Container(
                  height: height * 0.65,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(poster),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              language == 'en'
                                  ? 'English'
                                  : language == 'hin'
                                  ? 'Hindi'
                                  : 'Not Specified',
                              style: GoogleFonts.average(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Tooltip(
                              message: 'Total Vote: $voteCount',
                              exitDuration: Duration(milliseconds: 100),
                              child: Text(
                                '${vote.toStringAsFixed(1)}/10⭐',
                                style: GoogleFonts.average(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: GoogleFonts.merienda(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: darkMetalic,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Type: $mediaType',
                              style: GoogleFonts.aBeeZee(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              'On: $releaseDate',
                              style: GoogleFonts.aBeeZee(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            overview,
                            style: GoogleFonts.merienda(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  color: Colors.transparent,
                  shadowColor: Colors.black,
                  clipBehavior: Clip.antiAliasWithSaveLayer,

                  elevation: 16,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: metalicSilver,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
