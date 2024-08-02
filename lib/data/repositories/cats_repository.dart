import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wietapp/data/models/cat.dart';
import 'package:wietapp/data/models/tier.dart';

class CatsRepository {
  final String apiUrl = 'https://portal.wietmobile.com:8443/api/test/data';

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final result = jsonData['Result'];
      return {
        'cats': (result['cats'] as List).map((cat) => Cat.fromJson(cat)).toList(),
        'tiers': (result['tiers'] as List).map((tier) => Tier.fromJson(tier)).toList(),
        'currentTier': result['currentTier'],
        'tierPoints': result['tierPoints'],
      };
    } else {
      throw Exception('Failed to load data');
    }
  }
}