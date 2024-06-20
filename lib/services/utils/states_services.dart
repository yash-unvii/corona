import 'dart:convert';

import 'package:covid_track/model/world_state.dart';
import 'package:http/http.dart' as http;
import 'package:covid_track/services/utils/app_urls.dart';

class StatesServices {
  Future<WorldState> worldApi() async {
    final response = await http.get(Uri.parse(Urls.worldStatesList));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return WorldState.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<List<dynamic>> CountriesApi() async {
    final response = await http.get(Uri.parse(Urls.countriesList));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return data;
    } else {
      throw Exception('Error');
    }
  }
}
