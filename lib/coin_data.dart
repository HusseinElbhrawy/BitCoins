import 'dart:convert';

import 'package:http/http.dart' as http;

const currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const APIUrl = 'https://rest.coinapi.io/v1/exchangerate';
const APIKey = '179D8CDA-C76E-45AA-8099-156E7821D39A';

class CoinData {
  getCoinData(String des) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      var currencyDetails = await http.get(
        Uri.parse('$APIUrl/$crypto/$des?apikey=$APIKey'),
      );
      if (currencyDetails.statusCode == 200) {
        double lastPrice = jsonDecode(currencyDetails.body)['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
