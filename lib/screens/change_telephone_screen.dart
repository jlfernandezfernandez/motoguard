import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motoguard/model/app_data_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ChangeTelephoneScreen extends StatelessWidget {
  final int contactOrder;

  // receive data from the FirstScreen as a parameter
  ChangeTelephoneScreen({Key key, @required this.contactOrder})
      : super(key: key);

  final myController = TextEditingController();

  void saveAndSendTelephone(AppDataModel model) {
    if (model.getConnectedDevice() != null) {
      model.getContactsCharacteristic().write(
          utf8.encode(contactOrder.toString() + myController.text),
          withoutResponse: true);
      model.setTelephone(contactOrder, myController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Actualizar número de teléfono'),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            )),
        body: ScopedModelDescendant<AppDataModel>(
            builder: (context, child, model) {
          return ListView(
            children: [
              new Container(
                  margin: new EdgeInsets.all(10.0),
                  child: new Column(
                    children: [
                      new Text('Actual',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      new Text(model.getTelephones()[contactOrder] != null
                          ? model.getTelephones()[contactOrder]
                          : "Sin asignar"),
                    ],
                  )),
              new Container(
                margin: new EdgeInsets.all(10.0),
                child: new Column(
                  children: [
                    new Text('Nuevo',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    new TextField(
                      controller: myController,
                      maxLength: 9,
                      decoration:
                          new InputDecoration(labelText: 'Número de teléfono'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    )
                  ],
                ),
              ),
              new RaisedButton(
                  child: const Text('Guardar', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    saveAndSendTelephone(model);
                  })
            ],
          );
        }));
  }
}
