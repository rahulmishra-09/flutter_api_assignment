import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FinalResult extends StatelessWidget {
  const FinalResult({super.key, required this.coin});

  final Map<String, dynamic> coin;

  @override
  Widget build(BuildContext context) {
    String formatDate(String date) {
      DateTime parseDate = DateTime.parse(date);
      String formattedDate = DateFormat('dd-MM-yyyy').format(parseDate);
      return formattedDate;
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final imageUrl = coin['image'];
    String athDate = coin['ath_date'];
    String formatAthDate = formatDate(athDate);
    String atlDate = coin['atl_date'];
    String formatAtlDate = formatDate(atlDate);

    var textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.grey[600],
    );
    return Scaffold(
      backgroundColor: Colors.lime[200],
      appBar: AppBar(
        backgroundColor: Colors.lime[700],
        title: Text(
          'Cryptels',
          style: GoogleFonts.zillaSlab(
            fontWeight: FontWeight.w900,
            color: Colors.grey[700],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 10, left: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Current Price',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      coin['current_price'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Rank',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '#${coin['market_cap_rank'].toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: height * 0.4,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child:
                  imageUrl != null
                      ? ClipOval(
                        child: Image(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.fill,
                        ),
                      )
                      : Icon(Icons.broken_image, color: Colors.red),
            ),
          ),
          Expanded(
            child: Container(
              width: width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lime[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[${coin['symbol'].toUpperCase()}] - ${coin['name']}',
                      style: GoogleFonts.merienda(
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Market Capitalization: ${coin['market_cap']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Market Capitalization Rank: ${coin['market_cap_rank']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fully Diluted Valuation: ${coin['fully_diluted_valuation']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Volume: ${coin['total_volume']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'High in 24 Hour: ${coin['high_24h']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Low in 24 Hour: ${coin['low_24h']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price Change 24 Hour: ${coin['price_change_24h']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price Change 24 Hour Percentage: ${coin['price_change_percentage_24h']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Market Capitalization 24 Hour: ${coin['market_cap_change_24h']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Market Capitalization 24 Hour Percentage: ${coin['market_cap_change_percentage_24h']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Circulating Supply: ${coin['circulating_supply']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Supply: ${coin['total_supply']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text('Max Supply: ${coin['max_supply']}', style: textStyle),
                    Text(
                      'All Time High[ATH]: ${coin['ath']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ATH Change Percentage: ${coin['ath_change_percentage']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text('ATH Date: $formatAthDate', style: textStyle),
                    const SizedBox(height: 8),
                    Text('All Time Low[ATL]: ${coin['atl']}', style: textStyle),
                    const SizedBox(height: 8),
                    Text(
                      'ATL Change Percentage: ${coin['atl_change_percentage']}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text('ATL Date: $formatAtlDate', style: textStyle),
                    const SizedBox(height: 8),
                    Text(
                      'Last Updated: ${coin['last_updated']}',
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
