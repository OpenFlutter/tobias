import 'package:flutter/material.dart';

import 'package:tobias/tobias.dart' as tobias;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _payInfo = "";
  Map _payResult;

  final myController = new TextEditingController();

  void _loadData() {
    _payInfo = "";
    _payResult = {};

    http
        .post("http://120.79.190.42:8071/pay/test_pay/create",
            body: json.encode({"fee": 1, "title": "test pay"}))
        .then((http.Response response) {
      if (response.statusCode == 200) {
        print(response.body);
        var map = json.decode(response.body);
        int flag = map["flag"];
        if (flag == 0) {
          var result = map["result"];
          setState(() {
            _payInfo = result["credential"]["payInfo"];
            myController.text = _payInfo;

          });
          return;
        }
      }
      throw new Exception("创建订单失败");
    }).catchError((e) {
      setState(() {
        _payInfo = e.toString();
        myController.text = _payInfo;
      });
    });

    setState(() {});
  }

  @override
  initState() {
    super.initState();

    _loadData();
  }

  onChanged(String value) {
    _payInfo = value;
  }

  callAlipay() async {
    Map payResult;
    try {
      print("The pay info is : " + _payInfo);
      payResult = await tobias.payWithOrder(_payInfo);
      print("-->$payResult");
    } on Exception catch (e) {
      payResult = {};
    }

    if (!mounted) return;

    setState(() {
      _payResult = payResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Tobias example'),
        ),
        body: new SingleChildScrollView(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text("input order info"),
              new TextField(
                  maxLines: 15, onChanged: onChanged, controller: myController),
              new RaisedButton(onPressed: callAlipay, child: new Text("pay")),
              new RaisedButton(
                  onPressed: () {
                    _loadData();
                  },
                  child: new Text("reopen an order")),
              new Text(_payResult == null ? "no results" : "result:${_payResult.toString()}")
            ],
          ),
        ),
      ),
    );
  }
}
