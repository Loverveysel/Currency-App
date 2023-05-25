import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import 'package:xml/xml.dart';


void main() {
  runApp(MyApp());
}

String snapBank = "none";

class MyApp extends StatelessWidget {
  var spaceBetween = 75.0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Exchange",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: Center(child: Text("Curency", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)), ),
            backgroundColor: Colors.blueAccent,
            toolbarHeight: 65.0,),
          body: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("Assets/background.jpg", ),fit: BoxFit.fill,)),
            child: Column(children: [
              SizedBox(height: spaceBetween),
              Row(
                children: [
                  bank(0),
                  SizedBox(width: 30.0),
                  bank(1)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              SizedBox(height: 75.0,),
              Row(
                children: [
                  bank(2),
                  SizedBox(width: 30.0),
                  bank(3)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),

            ],
            ),
          ),

        ),
        darkTheme: ThemeData.dark()
    );
  }
}

class bank extends StatelessWidget{
  var bra;
  var banks = ["Ziraat Bankası", "Merkez Bankası", "İş Bankası", "Halk Bankası"];

  bank(int bra){
    this.bra = bra;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        snapBank = banks[bra];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NextPage()));
      },
      child: Container(
        height: 150.0,
        width: 150.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: bra == 0 || bra == 1?
                  Colors.red:
                      Colors.blue,
          boxShadow: [
            BoxShadow(
              color: bra == 0 || bra == 1?
                          Colors.red:
                          Colors.blue,
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(15.0), child: Image.asset("Assets/" + banks[bra] + ".png", fit: BoxFit.fill,),),
      ),
    );
  }
}

class NextPage extends StatefulWidget{
  const NextPage();

  @override
  NextPageState createState() => NextPageState();
}

class NextPageState extends State<NextPage> {
  var width = 125.0;
  var height = 50.0;

  var showUsdA = "none";
  var showUsdS = "none";
  var showEurA = "none";
  var showEurS = "none";
  var showPndA = "none";
  var showPndS = "none";

  Future<void> getData() async{
    if(snapBank == "Merkez Bankası"){
      var url = Uri.parse("https://www.tcmb.gov.tr/kurlar/today.xml");

      var res = await http.get(url);
      final body = res.body;
      final doc = XmlDocument.parse(body);
      final usdA =  doc.findAllElements("ForexBuying").first.text;
      final usdS = doc.findAllElements("ForexSelling").first.text;
      final eurA = doc.findAllElements("ForexBuying").elementAt(3).text;
      final eurS = doc.findAllElements("ForexSelling").elementAt(3).text;
      final pndA = doc.findAllElements("ForexBuying").elementAt(4).text;
      final pndS = doc.findAllElements("ForexSelling").elementAt(4).text;

      setState((){
        showUsdA = usdA;
        showUsdS = usdS;
        showEurA = eurA;
        showEurS = eurS;
        showPndA = pndA;
        showPndS = pndS;
      });
    }
    else if(snapBank == "İş Bankası"){
      var url = Uri.parse("https://www.isbank.com.tr/doviz-kurlari");
      final res = await http.post(url);
      final body = res.body;

      final doc = parser.parse(body);
      final usdA = doc.getElementsByClassName("dk_L0")[0].children[1].text.toString().replaceAll(" ", "").replaceAll("\n","");
      final usdS = doc.getElementsByClassName("dk_L0")[0].children[2].text.toString().replaceAll(" ", "").replaceAll("\n","");;
      final eurA = doc.getElementsByClassName("dk_L1")[0].children[1].text.toString().replaceAll(" ", "").replaceAll("\n","");;
      final eurS = doc.getElementsByClassName("dk_L1")[0].children[2].text.toString().replaceAll(" ", "").replaceAll("\n","");;
      final pndA = doc.getElementsByClassName("dk_L0")[1].children[1].text.toString().replaceAll(" ", "").replaceAll("\n","");;
      final pndS = doc.getElementsByClassName("dk_L0")[1].children[2].text.toString().replaceAll(" ", "").replaceAll("\n","");;

      setState(() {
        showUsdA = usdA;
        showUsdS = usdS;
        showEurA = eurA;
        showEurS = eurS;
        showPndA = pndA;
        showPndS = pndS;
      });
    }
    else if(snapBank == "Ziraat Bankası"){
      var url = Uri.parse("https://www.ziraatbank.com.tr/tr/fiyatlar-ve-oranlar");
      final res = await http.post(url);
      final body = res.body;



      final doc = parser.parse(body);
      final usdA = doc.getElementsByClassName("table")[7].children[0].children[1].children[0].children[2].text;
      final usdS = doc.getElementsByClassName("table")[7].children[0].children[1].children[0].children[3].text;
      final eurA = doc.getElementsByClassName("table")[7].children[0].children[1].children[1].children[2].text;
      final eurS = doc.getElementsByClassName("table")[7].children[0].children[1].children[1].children[3].text;
      final pndA = doc.getElementsByClassName("table")[7].children[0].children[1].children[2].children[2].text;
      final pndS = doc.getElementsByClassName("table")[7].children[0].children[1].children[2].children[3].text;

      setState(() {
        showUsdA = usdA;
        showUsdS = usdS;
        showEurA = eurA;
        showEurS = eurS;
        showPndA = pndA;
        showPndS = pndS;
      });
    }
    else if(snapBank == "Halk Bankası"){
      var url = Uri.parse("https://canlidoviz.com/doviz-kurlari/halkbank");
      final res = await http.post(url);
      final body = res.body;



      final doc = parser.parse(body);
      final usdA = doc.getElementsByClassName("text-primary text-right text-title    ")[0].text.replaceAll(' ', "").replaceAll("\n", "");
      final usdS = doc.getElementsByClassName("text-right")[6].children[0].innerHtml;
      final eurA = doc.getElementsByClassName("text-primary text-right text-title    ")[4].text.replaceAll(' ', "").replaceAll("\n", "");
      final eurS =  doc.getElementsByClassName("text-primary text-right text-title    ")[5].text.replaceAll(' ', "").replaceAll("\n", "");
      setState(() {
        showUsdA = usdA;
        showUsdS = usdS;
        showEurA = eurA;
        showEurS = eurS;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(snapBank, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)), ),
        backgroundColor: Colors.blue,
        toolbarHeight: 65.0,),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("Assets/background.jpg"), fit: BoxFit.fill)),
        child: Center(
          child: Table(
            border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.purpleAccent),
                    ),
                    child: Center(child: Text("Birim", style: TextStyle(fontSize: 24)),),
                  ),
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.purpleAccent),
                    ),
                    child: Center(child: Text("Alış", style: TextStyle(fontSize: 24)),),
                  ),
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.purpleAccent),
                    ),
                    child: Center(child: Text("Satış", style: TextStyle(fontSize: 24)),),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  Container(
                    height: height,
                    width: width,
                    child: Center(child: Text("Dolar", style: TextStyle(fontSize: 24),),),
                  ),
                  Container(
                    height: height,
                    width: width,
                    child: Center(child: Text(showUsdA, style: TextStyle(fontSize: 24),),),),
                  Container(
                    height: height,
                    width: width,
                    child: Center(child: Text(showUsdS, style: TextStyle(fontSize: 24),),),
                  )
                ],
              ),
              TableRow(
                children: <Widget>[
                  Container(
                    height: height,
                    width: width,
                    child: Center(child: Text("Euro", style: TextStyle(fontSize: 24),),),
                  ),
                  Container(
                    height: height,
                    width: width,
                    child: Center(child: Text(showEurA, style: TextStyle(fontSize: 24),),),),
                  Container(
                    height: height,
                    width: width,
                    child: Center(child: Text(showEurS, style: TextStyle(fontSize: 24),),),
                  )
                ],
              ),if(snapBank != "Halk Bankası")
                TableRow(
                  children: <Widget>[
                    Container(
                      height: height,
                      width: width,
                      child: Center(child: Text("Sterlin", style: TextStyle(fontSize: 24),),),
                    ),
                    Container(
                      height: height,
                      width: width,
                      child: Center(child: Text(showPndA, style: TextStyle(fontSize: 24),),),),
                    Container(
                      height: height,
                      width: width,
                      child: Center(child: Text(showPndS, style: TextStyle(fontSize: 24),),),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}