import 'dart:convert';

import 'package:climafy/crypto%20details/final_result.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../color.dart';

class SearchCrypto extends StatefulWidget {
  const SearchCrypto({super.key});

  @override
  State<SearchCrypto> createState() => _SearchCryptoState();
}

class _SearchCryptoState extends State<SearchCrypto> {
  final transparent = Colors.transparent;
  final searchController = TextEditingController();
  List<dynamic> coins = [];
  List<dynamic> filteredCoins = [];

  Future<void> searchData(String query) async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd',
    );

    try {
      if (query.isNotEmpty) {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final result =
              data.where((coin) {
                final name = coin['name'].toString().toLowerCase();
                final symbol = coin['symbol'].toString().toLowerCase();

                return name.contains(query.toLowerCase()) ||
                    symbol.contains(query.toLowerCase());
              }).toList();
          setState(() {
            coins = data;
            filteredCoins = result;
          });
        } else {
          throw Exception('Failed to fetch Data');
        }
      } else {
        throw Exception('Enter Data First!');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime[700],
        title: Text(
          'Search Crypto',
          style: GoogleFonts.zillaSlab(
            fontWeight: FontWeight.w900,
            color: Colors.grey[700],
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
                      hintText: 'Search crypto...',
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
                    onPressed: () {
                      searchData(searchController.text.trim());
                    },
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
                  filteredCoins.isEmpty
                      ? Center(child: Text('No Coins Found...'))
                      : ListView.builder(
                        itemCount: filteredCoins.length,
                        itemBuilder: (context, index) {
                          final coin = filteredCoins[index];
                          final imageUrl = coin['image'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
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
          ],
        ),
      ),
    );
  }
}
