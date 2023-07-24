import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:motoguard/model/app_data_model.dart';
import 'package:scoped_model/scoped_model.dart';

class InfoPage extends StatefulWidget {
  @override
  State<InfoPage> createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  int speed = 0;
  bool movement = false;

  static final String dataServiceUuid = "19b10000-e8f2-537e-4f6c-d104768a1214";
  static final String speedCharacteristicUuid =
      "19b10001-e8f2-537e-4f6c-d104768a1214";
  static final String movementCharacteristicUuid =
      "19b10002-e8f2-537e-4f6c-d104768a1214";

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    AppDataModel model = ScopedModel.of(context);
    if (model.getConnectedDevice() != null) {
      startServices(model);
    }
  }

  void startServices(AppDataModel model) async {
    if (model.getDataService() == null) {
      List<BluetoothService> services =
          await model.getConnectedDevice().discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid.toString().toLowerCase() ==
            dataServiceUuid.toLowerCase()) {
          model.setDataService(service);
        }
      }
    }
    getCharacteristics(model);
  }

  void getCharacteristics(AppDataModel model) {
    getSpeedCharacteristic(model);
    getMovementCharacteristic(model);
    activateNotifications(model);
    getSpeed(model.getSpeedCharacteristic());
    getMovement(model);
  }

  void getSpeedCharacteristic(AppDataModel model) {
    if (model.getSpeedCharacteristic() == null) {
      for (BluetoothCharacteristic characteristic
          in model.getDataService().characteristics) {
        if (characteristic.uuid.toString().toLowerCase() ==
            speedCharacteristicUuid.toLowerCase()) {
          model.setSpeedCharacteristic(characteristic);
        }
      }
    }
  }

  void getMovementCharacteristic(AppDataModel model) {
    if (model.getMovementCharacteristic() == null) {
      for (BluetoothCharacteristic characteristic
          in model.getDataService().characteristics) {
        if (characteristic.uuid.toString().toLowerCase() ==
            movementCharacteristicUuid.toLowerCase()) {
          model.setMovementCharacteristic(characteristic);
        }
      }
    }
  }

  void activateNotifications(AppDataModel model) {
    model.getSpeedCharacteristic().setNotifyValue(true).whenComplete(
        () => model.getMovementCharacteristic().setNotifyValue(true));
  }

  void getSpeed(BluetoothCharacteristic characteristic) {
    characteristic.value.listen((value) {
      if (value.isNotEmpty) {
        print(value.toString());
        setState(() {
          speed = value.first;
        });
      }
    });
  }

  void getMovement(AppDataModel model) {
    model.getMovementCharacteristic().value.listen((value) {
      if (value.isNotEmpty) {
        if (value.first == 1) {
          model.setLastTimeUpdateMovement(DateTime.now());
        }
        setState(() {
          movement = value.first == 1;
        });
      }
    });
  }

  Widget statusSection(AppDataModel model) => Card(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 10,
      child: Column(children: [
        ListTile(
          title: Text(
              model.getConnectedDevice() != null ? "Conectado" : "Desconectado",
              style: TextStyle(fontWeight: FontWeight.w400)),
          subtitle: Text(model.getConnectedDevice() != null
              ? model.getConnectedDevice().id.id
              : "Vete a ajustes para conectarte con un dispositivo"),
          leading: Icon(
            model.getConnectedDevice() != null
                ? Icons.bluetooth_connected
                : Icons.bluetooth_disabled,
            color: Colors.blue[500],
          ),
        ),
      ]));

  Widget movementSection(AppDataModel model) => Card(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 10,
      child: Column(children: [
        ListTile(
          title: Text(movement ? "En movimiento" : "Sin movimiento",
              style: TextStyle(fontWeight: FontWeight.w400)),
          subtitle: Text(model.getLastTimeUpdateMovement() != null
              ? 'Último movimiento: ' +
                  DateFormat('dd/MM – kk:mm')
                      .format(model.getLastTimeUpdateMovement())
              : "No hay registros pasados"),
          leading: Icon(
            Icons.motorcycle,
            color: Colors.blue[500],
          ),
        ),
      ]));

  Widget speedSection() => Card(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 10,
      child: Column(children: [
        ListTile(
          title: Text(speed.toString() + "km/h",
              style: TextStyle(fontWeight: FontWeight.w400)),
          leading: Icon(
            Icons.speed,
            color: Colors.blue[500],
          ),
        ),
      ]));

  Widget positionSection() => Card(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 10,
      child: Column(children: [
        ListTile(
          title: Text("Última posición",
              style: TextStyle(fontWeight: FontWeight.w400)),
          subtitle: Text('Última actualización: hace 2 minutos'),
          leading: Icon(
            Icons.map,
            color: Colors.blue[500],
          ),
        ),
      ]));

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body:
        ScopedModelDescendant<AppDataModel>(builder: (context, child, model) {
      return ListView(
        children: [
          statusSection(model),
          movementSection(model),
          speedSection(),
          positionSection()
        ],
      );
    }));
  }
}
