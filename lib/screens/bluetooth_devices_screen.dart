import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:motoguard/model/app_data_model.dart';
import 'package:scoped_model/scoped_model.dart';

class BluetoothDevicesScreen extends StatefulWidget {
  const BluetoothDevicesScreen({Key key}) : super(key: key);

  @override
  _BluetoothDevicesScreenState createState() => _BluetoothDevicesScreenState();
}

class _BluetoothDevicesScreenState extends State<BluetoothDevicesScreen> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];
  static final String localName = "MotoGuard";

  _showDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device) && device.name == localName) {
      setState(() {
        devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    flutterBlue.startScan();

    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _showDeviceTolist(result.device);
      }
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dispositivo conectado'),
          actions: <Widget>[
            TextButton(
              child: Text('Genial'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String getName(AppDataModel model, BluetoothDevice bluetoothDevice) {
    if (model.getConnectedDevice() != null &&
        model.getConnectedDevice().name == bluetoothDevice.name) {
      return bluetoothDevice.name + (' (Conectado)');
    } else if (bluetoothDevice.name != '') {
      return bluetoothDevice.name;
    } else
      return '(desconocido)';
  }

  ListView _buildListViewOfDevices(AppDataModel model) {
    List<Container> sizedBoxList = new List<Container>();
    for (BluetoothDevice device in devicesList) {
      sizedBoxList.add(Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
        child: RaisedButton(
            padding: const EdgeInsets.all(15.0),
            onPressed: () async {
              flutterBlue.stopScan();
              try {
                await device.connect();
              } catch (e) {
                if (e.code != 'already_connected') {
                  throw e;
                }
              }
              model.setConnectedDevice(device);
              _showMyDialog();
            },
            child: Text(getName(model, device),
                style: TextStyle(fontWeight: FontWeight.w400))),
      ));
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...sizedBoxList,
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un dispositivo'),
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              flutterBlue.stopScan();
              Navigator.pop(context);
            }),
      ),
      body:
          ScopedModelDescendant<AppDataModel>(builder: (context, child, model) {
        return _buildListViewOfDevices(model);
      }));
}
