import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  var coinDate = CoinData();
  var selectedCurrency = 'AUD';
  androidWidget() {
    //this loop is important to get the values in the currenciesList
    List<DropdownMenuItem<String>> items = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      items.add(newItem);
    }
    //after the loop the next lines are to add the values of the list in the DropDownButton
    return DropdownButton(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value.toString();
          getData();
        });
      },
    );
  }

  //ths same thing i do it with androidWidget i do it in the iosWidget ;
  iosWidget() {
    List<Widget> items = [];
    for (String currency in currenciesList) {
      items.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      children: items,
      onSelectedItemChanged: (value) {
        setState(() {
          selectedCurrency = currenciesList[value];
          getData();
        });
      },
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;
  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: ReusableCard(
                  cryptoCurrency: 'BTC',
                  value: isWaiting ? '?' : coinValues['BTC'],
                  selectedCurrency: selectedCurrency,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: ReusableCard(
                  cryptoCurrency: 'ETH',
                  value: isWaiting ? '?' : coinValues['ETH'],
                  selectedCurrency: selectedCurrency,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: ReusableCard(
                  cryptoCurrency: 'LTC',
                  value: isWaiting ? '?' : coinValues['LTC'],
                  selectedCurrency: selectedCurrency,
                ),
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? iosWidget() : androidWidget(),
          ),
        ],
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  final value;
  final selectedCurrency;
  final cryptoCurrency;

  const ReusableCard(
      {Key? key, this.value, this.selectedCurrency, this.cryptoCurrency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $cryptoCurrency = $value $selectedCurrency',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
