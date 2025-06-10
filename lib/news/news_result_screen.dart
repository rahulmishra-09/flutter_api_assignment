import 'package:climafy/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsResultScreen extends StatefulWidget {
  const NewsResultScreen({super.key, required this.article});
  final Map<String, dynamic> article;

  @override
  State<NewsResultScreen> createState() => _NewsResultScreenState();
}

class _NewsResultScreenState extends State<NewsResultScreen> {
  void onTapLink() async {
    final urlString = widget.article['url'];
    final url = Uri.parse(urlString);

    if (urlString == null ||
        urlString.isEmpty ||
        !urlString.startsWith('http')) {
      print('Invalid URL: $urlString');
      return;
    }
    try {
      final canLaunch = await canLaunchUrl(url);
      print(canLaunch);

      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.inAppBrowserView);
      }
    } catch (e) {
      print('Failed to launch url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final imageUrl = widget.article['urlToImage'];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageUrl != null
                    ? Container(
                      height: height * 0.45,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                    : SizedBox(
                      height: height * 0.45,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Published at: ${widget.article['publishedAt']}',
                        style: GoogleFonts.merienda(
                          fontWeight: FontWeight.w900,
                          color: Colors.yellow[700],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Author: ${widget.article['author']}',
                        style: GoogleFonts.merienda(
                          fontWeight: FontWeight.w900,
                          color: Colors.redAccent,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Title: ${widget.article['title']}',
                        style: GoogleFonts.merienda(
                          fontWeight: FontWeight.w900,
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        widget.article['description'] != null
                            ? 'Description: ${widget.article['description']}'
                            : 'Description: No Description Available',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: onTapLink,
                        child: Text(
                          widget.article['url'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.article['content'] != null
                            ? 'Content: ${widget.article['content']}'
                            : 'Content: No Content Available',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 16),
            child: Card(
              color: Colors.transparent,
              elevation: 24,
              shadowColor: black,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
                color: black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
