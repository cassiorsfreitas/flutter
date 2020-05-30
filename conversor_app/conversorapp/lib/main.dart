import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

//biblioteca que permite fazer as requisições em http
import 'package:http/http.dart' as http;

//biblioteca permite que façamos requisições sem precisar esperar pela resposta (requisição assincrona)
import 'dart:async';

//converter os dados json para ler e chamar conversão de map
import 'dart:convert';

//declarar como const ajuda a não fazer besteira depois sem querer...
const request = "https://api.hgbrasil.com/finance?key=7822b134";

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getData() async {
  //variavel que recebe a resposta do servidor | solicitação get request e não retorna na hora | await vai fazer esperar
  http.Response response = await http.get(request);
  //usado para transformar o nosso json em um map
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.amber,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[800],
        child: Icon(Icons.refresh),
        onPressed: _clearAll,
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            
          ],
        ),
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando...",
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao carregar dados :(",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  //dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  //euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  dolar = 3;
                  euro = 6;



                  // LAYOUT COMEÇA AQUI
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        
                        Container(
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: new EdgeInsets.all(30.0),
                          child: Column(
                            
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text("Conversor",
                                    style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.w500),
                                  )),
                                ],
                              ),

                              buildTextField(
                                  "Reais", "R\$", realController, _realChanged),
                              SizedBox(height: 7),
                              buildTextField("Dolares", "US\$", dolarController,
                                  _dolarChanged),
                              SizedBox(height: 7),
                              buildTextField(
                                  "Euros", "€", euroController, _euroChanged),
                            ],
                          ),
                        ),
                        SizedBox(height: 14),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.cyan[100],
                          ),
                          padding: new EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text("EURO",
                                      style: TextStyle(color: Colors.blueGrey),)
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      Text("€ " + euro.toString(),
                                      style: TextStyle(color: Colors.blueGrey),)
                                    ],
                                  ),
                                ],
                              ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
            }
          }),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  ),
                  accountName: Text("Capitão América"),
                  accountEmail: Text("cassio.rsfreitas@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                  backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS
                    ? Colors.blue: Colors.white,
                  child: Text("C", style: 
                    TextStyle(fontSize: 40.0, color: Colors.cyan[100]),
                  ),
                  ),
                ),
                
                  ListTile( 
                 leading: Icon(Icons.account_circle),
                 title: Text("Perfil"),
                 subtitle: Text("Perfil do usuário..."),
                 trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.pop(context);
                }
               ),
               ListTile(
                  leading: Icon (Icons.star),
                  title: Text("Minhas moedas"),
                  subtitle: Text("Principais moedas..."),
                  trailing: Icon (Icons.arrow_forward),
                  onTap: () {
                    debugPrint('toquei no drawer');
                  },
                  ),
              ],
            ),
        )
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      prefixText: prefix,
      prefixStyle: TextStyle(color: Colors.amber),
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 1.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 1.0),
        borderRadius: BorderRadius.circular(0.0),
        
      ),
    ),
    style: TextStyle(color: Colors.amber),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
