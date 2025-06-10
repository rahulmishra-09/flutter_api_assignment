import 'package:climafy/crypto%20details/final_result.dart';
import 'package:climafy/crypto%20details/search_crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  List<dynamic> coins = [];

  Future<void> fetchCoinDetails() async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          coins = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCoinDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[50],
      appBar: AppBar(
        backgroundColor: Colors.lime[700],
        title: Text(
          'Cryptels',
          style: GoogleFonts.zillaSlab(
            fontWeight: FontWeight.w900,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchCrypto()),
              );
            },
            icon: Icon(Icons.search, color: Colors.grey[700]),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            coins.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: coins.length,
                  itemBuilder: (context, index) {
                    final coin = coins[index];
                    final imageUrl = coin['image'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FinalResult(coin: coin),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.lime[100],
                        ),
                        child: ListTile(
                          leading:
                              imageUrl != null
                                  ? ClipRRect(
                                    child: Image(
                                      image: NetworkImage(imageUrl),
                                      height: 60,
                                      width: 40,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                  : SizedBox(
                                    height: 60,
                                    width: 40,
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                          title: Text(
                            '${coin['symbol'].toUpperCase()} - ${coin['name']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                          subtitle: Text(
                            'Current Price: ${coin['current_price'].toString()}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rank',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                              Text(
                                '#${coin['market_cap_rank'].toString()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
