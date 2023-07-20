import 'dart:math';

import 'package:currency/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import 'package:xml/xml.dart';

var width = 125.0;
var height = 75.0;

List minimmum(var geekList){


  double largestGeekValue = double.parse(geekList[0]);
  double smallestGeekValue = double.parse(geekList[0]);

  int largestIndex = 0;
  int smallestIndex = 0;

  for (int i = 0; i < geekList.length; i++) {
    String val = geekList[i].toString().replaceAll(",", ".");

    if (double.parse(val) > largestGeekValue) {
      largestGeekValue = double.parse(val);
      largestIndex = i;
    }

    // Checking for smallest value in the list
    if (double.parse(val) < smallestGeekValue) {
      smallestGeekValue = double.parse(val);
      smallestIndex = i;
    }
  }

  return [smallestGeekValue.toString(), smallestIndex, largestGeekValue.toString(), largestIndex];
}

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
          appBar: AppBar(title: Center(child: Text("Sudoku Currency", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)), ),
            backgroundColor: Colors.blueAccent,
            toolbarHeight: 85.0,
              actions: [
                Builder(
                  builder: (context) => Center(
                    child: ElevatedButton(
                      child: Text("Filter"),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  filterPage())),
                ),
              ),
                )
              ],
          ),
          body: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("Assets/background.jpg", ),fit: BoxFit.fill,)),
            child: Column(children: [
              SizedBox(height: 35),
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
              SizedBox(height: 75.0),

              Row(
                children: [
                  bank(4),
                  SizedBox(width: 30.0),
                  bank(5)
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
  var banks = ["Ziraat Bankası", "Merkez Bankası", "İş Bankası", "Halk Bankası", "Garanti Bankası", "Yapı Kredi Bankası"];

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
                      bra == 2 || bra ==3 || bra == 5?
                      Colors.blue:
                          Colors.greenAccent,
          boxShadow: [
            BoxShadow(
              color: bra == 0 || bra == 1?
              Colors.red:
              bra == 2 || bra ==3 || bra == 5?
              Colors.blue:
              Colors.greenAccent,
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


  var showUsdA = "";
  var showUsdS = "";
  var showEurA = "";
  var showEurS = "";
  var showPndA = "";
  var showPndS = "";

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
      final pndA = doc.getElementsByClassName("text-primary text-right text-title    ")[6].text.replaceAll(' ', "").replaceAll("\n", "");
      final pndS = doc.getElementsByClassName("text-primary text-right text-title    ")[7].text.replaceAll(' ', "").replaceAll("\n", "");
      setState(() {
        showUsdA = usdA;
        showUsdS = usdS;
        showEurA = eurA;
        showEurS = eurS;

      });
    }
    else if(snapBank == "Garanti Bankası"){
      var url = Uri.parse("https://canlidoviz.com/doviz-kurlari/garanti-bankasi");
      final res = await http.post(url);
      final body = res.body;

      final doc = parser.parse(body);

      final usdA = doc.getElementsByClassName("text-primary text-right text-title    ")[0].text.replaceAll(' ', "").replaceAll("\n", "");
      final usdS = doc.getElementsByClassName("text-right")[6].children[0].innerHtml;
      final eurA = doc.getElementsByClassName("text-primary text-right text-title    ")[4].text.replaceAll(' ', "").replaceAll("\n", "");
      final eurS =  doc.getElementsByClassName("text-primary text-right text-title    ")[6].text.replaceAll(' ', "").replaceAll("\n", "");
      final pndA = doc.getElementsByClassName("text-primary text-right text-title    ")[7].text.replaceAll(' ', "").replaceAll("\n", "");
      final pndS = doc.getElementsByClassName("text-primary text-right text-title    ")[10].text.replaceAll(' ', "").replaceAll("\n", "");
      setState(() {
        showUsdA = usdA;
        showUsdS = usdS;
        showEurA = eurA;
        showEurS = eurS;
        showPndA = pndA;
        showPndS = pndS;
      });
    }
    else if(snapBank == "Yapı Kredi Bankası"){
      var url = Uri.parse("https://www.yapikredi.com.tr/yatirimci-kosesi/doviz-bilgileri");
      final res = await http.post(url);
      final body = res.body;

      final doc = parser.parse(body);

      final usdA = doc.getElementsByClassName("table-radius")[0].children[0].children[1].children[0].children[2].innerHtml;
      final usdS = doc.getElementsByClassName("table-radius")[0].children[0].children[1].children[0].children[3].innerHtml;
      final eurA = doc.getElementsByClassName("table-radius")[0].children[0].children[1].children[1].children[2].innerHtml;
      final eurS = doc.getElementsByClassName("table-radius")[0].children[0].children[1].children[1].children[3].innerHtml;
      final pndA = doc.getElementsByClassName("table-radius")[0].children[0].children[1].children[3].children[2].innerHtml;
      final pndS = doc.getElementsByClassName("table-radius")[0].children[0].children[1].children[3].children[3].innerHtml;
      setState(() {
        showUsdA = usdA;
        showUsdS = usdS;
        showEurA = eurA;
        showEurS = eurS;
        showPndA = pndA;
        showPndS = pndS;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(snapBank, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)), ),
        backgroundColor: Colors.blue,
        centerTitle: true,
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
                      border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    child: Center(child: Text("Birim", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),),
                  ),
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                    ),
                    child: Center(child: Text("Alış", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),),
                  ),
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Center(child: Text("Satış", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                    ),
                    child: Center(child: Text("Dolar", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                  ),
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                    ),
                    child: Center(child: Text(showUsdA, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),),
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                    ),
                    child: Center(child: Text(showUsdS, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                  )
                ],
              ),
              TableRow(
                children: <Widget>[
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                    ),
                    child: Center(child: Text("Euro", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                  ),
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                    ),
                    child: Center(child: Text(showEurA, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),),
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                    ),
                    child: Center(child: Text(showEurS, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                  )
                ],
              ),if(snapBank != "Halk Bankası")
                TableRow(
                  children: <Widget>[
                    Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Center(child: Text("Sterlin", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                    ),
                    Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                      ),
                      child: Center(child: Text(showPndA, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),),
                    Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Center(child: Text(showPndS, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
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

class filterPage extends StatefulWidget{
  const filterPage();

  @override
  filterPageState createState() => filterPageState();
}


class filterPageState extends State<filterPage>{

  var minUsdA = "";
  var minEurA = "";
  var minPndA = "";

  var minUsdS = "";
  var minEurS = "";
  var minPndS = "";

  var maxUsdA = "";
  var maxEurA = "";
  var maxPndA = "";

  var maxUsdS = "";
  var maxEurS = "";
  var maxPndS = "";

  final bankList = ["TCMB", "İş Bankası", "Ziraat Bankası", "Garanti Bankası", "Yapı Kredi Bankası"];

  Future<void> getData() async{
    var url = Uri.parse("https://www.tcmb.gov.tr/kurlar/today.xml");

    var res = await http.get(url);
    var body = res.body;
    var doc = XmlDocument.parse(body);
    final usdA1 =  doc.findAllElements("ForexBuying").first.text;
    final usdS1 = doc.findAllElements("ForexSelling").first.text;
    final eurA1 = doc.findAllElements("ForexBuying").elementAt(3).text;
    final eurS1 = doc.findAllElements("ForexSelling").elementAt(3).text;
    final pndA1 = doc.findAllElements("ForexBuying").elementAt(4).text;
    final pndS1 = doc.findAllElements("ForexSelling").elementAt(4).text;

    url = Uri.parse("https://www.isbank.com.tr/doviz-kurlari");
    res = await http.post(url);
    body = res.body;

    var doc2 = parser.parse(body);
    final usdA2 = doc2.getElementsByClassName("dk_L0")[0].children[1].text.toString().replaceAll(" ", "").replaceAll("\n","");
    final usdS2 = doc2.getElementsByClassName("dk_L0")[0].children[2].text.toString().replaceAll(" ", "").replaceAll("\n","");;
    final eurA2 = doc2.getElementsByClassName("dk_L1")[0].children[1].text.toString().replaceAll(" ", "").replaceAll("\n","");;
    final eurS2 = doc2.getElementsByClassName("dk_L1")[0].children[2].text.toString().replaceAll(" ", "").replaceAll("\n","");;
    final pndA2 = doc2.getElementsByClassName("dk_L0")[1].children[1].text.toString().replaceAll(" ", "").replaceAll("\n","");;
    final pndS2 = doc2.getElementsByClassName("dk_L0")[1].children[2].text.toString().replaceAll(" ", "").replaceAll("\n","");;

    url = Uri.parse("https://www.ziraatbank.com.tr/tr/fiyatlar-ve-oranlar");
    res = await http.post(url);
    body = res.body;

    doc2 = parser.parse(body);
    final usdA3 = doc2.getElementsByClassName("table")[7].children[0].children[1].children[0].children[2].text;
    final usdS3 = doc2.getElementsByClassName("table")[7].children[0].children[1].children[0].children[3].text;
    final eurA3 = doc2.getElementsByClassName("table")[7].children[0].children[1].children[1].children[2].text;
    final eurS3= doc2.getElementsByClassName("table")[7].children[0].children[1].children[1].children[3].text;
    final pndA3 = doc2.getElementsByClassName("table")[7].children[0].children[1].children[2].children[2].text;
    final pndS3 = doc2.getElementsByClassName("table")[7].children[0].children[1].children[2].children[3].text;

    url = Uri.parse("https://canlidoviz.com/doviz-kurlari/garanti-bankasi");
    res = await http.post(url);
    body = res.body;

    doc2 = parser.parse(body);

    final usdA4 = doc2.getElementsByClassName("text-primary text-right text-title    ")[0].text.replaceAll(' ', "").replaceAll("\n", "");
    final usdS4 = doc2.getElementsByClassName("text-right")[6].children[0].innerHtml;
    final eurA4= doc2.getElementsByClassName("text-primary text-right text-title    ")[4].text.replaceAll(' ', "").replaceAll("\n", "");
    final eurS4 = doc2.getElementsByClassName("text-primary text-right text-title    ")[6].text.replaceAll(' ', "").replaceAll("\n", "");
    final pndA4= doc2.getElementsByClassName("text-primary text-right text-title    ")[7].text.replaceAll(' ', "").replaceAll("\n", "");
    final pndS4 = doc2.getElementsByClassName("text-primary text-right text-title    ")[10].text.replaceAll(' ', "").replaceAll("\n", "");

    url = Uri.parse("https://www.yapikredi.com.tr/yatirimci-kosesi/doviz-bilgileri");
    res = await http.post(url);
    body = res.body;

    doc2 = parser.parse(body);

    final usdA5 = doc2.getElementsByClassName("table-radius")[0].children[0].children[1].children[0].children[2].innerHtml;
    final usdS5 = doc2.getElementsByClassName("table-radius")[0].children[0].children[1].children[0].children[3].innerHtml;
    final eurA5 = doc2.getElementsByClassName("table-radius")[0].children[0].children[1].children[1].children[2].innerHtml;
    final eurS5 = doc2.getElementsByClassName("table-radius")[0].children[0].children[1].children[1].children[3].innerHtml;
    final pndA5 = doc2.getElementsByClassName("table-radius")[0].children[0].children[1].children[3].children[2].innerHtml;
    final pndS5 = doc2.getElementsByClassName("table-radius")[0].children[0].children[1].children[3].children[3].innerHtml;

    final usdA = [usdA1, usdA2, usdA3, usdA4, usdA5];
    final usdS = [usdS1, usdS2, usdS3, usdS4, usdS5];
    final eurA = [eurA1, eurA2, eurA3, eurA4, eurA5];
    final eurS = [eurS1, eurS2, eurS3, eurS4, eurS5];
    final pndA = [pndA1, pndA2, pndA3, pndA4, pndA5];
    final pndS = [pndS1, pndS2, pndS3, pndS4, pndS5];

    if (this.mounted) {
      setState(() {
        minUsdA = minimmum(usdA)[0].toString() + bankList[minimmum(usdA)[1]];
        minUsdS = minimmum(usdS)[0].toString() + bankList[minimmum(usdS)[1]];

        minEurA = minimmum(eurA)[0].toString() + bankList[minimmum(eurA)[1]];
        minEurS = minimmum(eurS)[0].toString() + bankList[minimmum(eurS)[1]];

        minPndA = minimmum(pndA)[0].toString() + bankList[minimmum(pndA)[1]];
        minPndS = minimmum(pndS)[0].toString() + bankList[minimmum(pndS)[1]];

        maxUsdA = minimmum(usdA)[2].toString() + bankList[minimmum(usdA)[3]];
        maxUsdS = minimmum(usdS)[2].toString() + bankList[minimmum(usdS)[3]];

        maxEurA = minimmum(eurA)[2].toString() + bankList[minimmum(eurA)[3]];
        maxEurS = minimmum(eurS)[2].toString() + bankList[minimmum(eurS)[3]];

        maxPndA = minimmum(pndA)[2].toString() + bankList[minimmum(pndA)[3]];
        maxPndS = minimmum(pndS)[2].toString() + bankList[minimmum(pndS)[3]];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        title: Text("Filter Page", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("Assets/background.jpg"), fit: BoxFit.fill)),
        child: Column(
          children: [
            SizedBox(width: 20,),
            Text("En Düşük", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
            Table(
              border: TableBorder(borderRadius: BorderRadius.circular(15),),
              children: [
                TableRow(
                    children:[
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Birim", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Alış", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Satış", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                    ]
                ),
                TableRow(
                    children:[
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Dolar", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(minUsdA, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(minUsdS, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                    ]
                ),
                TableRow(
                    children:[
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Euro", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(minEurA, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(minEurS, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                    ]
                ),
                TableRow(
                    children:[
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Sterlin", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(minPndA, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(minPndS, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                    ]
                ),
              ],
            ),
            Text("En Yüksek", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
            Table(
              border: TableBorder(borderRadius: BorderRadius.circular(15),),
              children: [
                TableRow(
                    children:[
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Birim", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Alış", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Satış", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                    ]
                ),
                TableRow(
                    children:[
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Dolar", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(maxUsdA, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(maxUsdS, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                    ]
                ),
                TableRow(
                    children:[
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Euro", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(maxEurA, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(maxEurS, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                    ]
                ),
                TableRow(
                    children:[
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text("Sterlin", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(maxPndA, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid, color: Colors.blueAccent, width: 5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(child: Text(maxPndS, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                      ),
                    ]
                ),
              ],
            ),
          ],
        )
      ),

    );
  }
}
