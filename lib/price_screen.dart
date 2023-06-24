import 'package:bitcoin_ticker/NetworkHelper.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedItem = 'USD';
  final String url =
      'https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC';
  String bitcoinResult = '';
  var bitcoinData;

  DropdownButton<String> getDropDownList() {
    List<DropdownMenuItem<String>> ret = [];
    for (String item in currenciesList) {
      var dropDown = DropdownMenuItem(
        child: Text(item),
        value: item,
      );
      ret.add(dropDown);
    }
    return DropdownButton<String>(
      value: selectedItem,
      items: ret,
      onChanged: (value) async {
        selectedItem = value!;
        String newUrl = url + selectedItem;
        NetworkHelper networkHelper = NetworkHelper(url: newUrl);
        bitcoinData = await networkHelper.getData();
        updateUI(bitcoinData);
      },
    );
  }

  CupertinoPicker getCupertinoList() {
    List<Widget> ret = [];
    for (String item in currenciesList) {
      ret.add(Text(item));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      children: ret,
      onSelectedItemChanged: (value) {
        print(value);
      },
    );
  }

  void getData(String url) async {
    NetworkHelper mNetworkHelper = NetworkHelper(url: url);
    bitcoinData = await mNetworkHelper.getData();
  }

  @override
  void initState() {
    super.initState();
    getData(url + selectedItem);
    updateUI(bitcoinData);
  }

  void updateUI(var data) {
    setState(() {
      if (data == null) {
        bitcoinResult = '?';
        return;
      }
      double temp = data['last'];
      bitcoinResult = temp.toString();

      // bitcoinResult = temp.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $bitcoinResult USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getCupertinoList() : getDropDownList(),
          ),
        ],
      ),
    );
  }
}
