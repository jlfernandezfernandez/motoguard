import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:motoguard/model/app_data_model.dart';
import 'package:motoguard/screens/change_telephone_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:settings_ui/settings_ui.dart';

import '../screens/bluetooth_devices_screen.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  bool lockInBackground = true;
  bool notificationsEnabled = true;

  static final String settingsServiceUuid =
      "20b20000-e8f2-537e-4f6c-d104768a1214";
  static final String settingsCharacteristicUuid =
      "20b20001-e8f2-537e-4f6c-d104768a1214";

  @override
  void initState() {
    super.initState();
  }

  void requestDataToDevice(AppDataModel model) async {
    if (model.getSettingsService() == null) {
      List<BluetoothService> services =
          await model.getConnectedDevice().discoverServices();
      services.forEach((service) {
        if (service.uuid.toString().toLowerCase() ==
            settingsServiceUuid.toLowerCase()) {
          model.setSettingsService(service);
        }
      });
    }
    getSettingsCharacteristic(model);
  }

  void getSettingsCharacteristic(AppDataModel model) {
    if (model.getContactsCharacteristic() == null) {
      model.getSettingsService().characteristics.forEach((characteristic) {
        if (characteristic.uuid.toString().toLowerCase() ==
            settingsCharacteristicUuid.toLowerCase()) {
          model.setContactsCharacteristic(characteristic);
        }
      });
    }
    doAsyncRequests(model);
  }

  void doAsyncRequests(AppDataModel model) async {
    model
        .getContactsCharacteristic()
        .write(utf8.encode("3"), withoutResponse: true);
    List<int> telephone1value = await model.getContactsCharacteristic().read();

    model
        .getContactsCharacteristic()
        .write(utf8.encode("4"), withoutResponse: true);
    List<int> telephone2value = await model.getContactsCharacteristic().read();

    model
        .getContactsCharacteristic()
        .write(utf8.encode("5"), withoutResponse: true);
    List<int> telephone3value = await model.getContactsCharacteristic().read();

    model.setFirstTelephone(
        utf8.decode(telephone1value.sublist(1, telephone1value.length)));
    model.setSecondTelephone(
        utf8.decode(telephone2value.sublist(1, telephone2value.length)));
    model.setThirdTelephone(
        utf8.decode(telephone3value.sublist(1, telephone3value.length)));
  }

  _navigateToBluetoothDevicesScreen(
      BuildContext context, AppDataModel model) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BluetoothDevicesScreen()),
    );
    if (model.getConnectedDevice() != null) {
      requestDataToDevice(model);
    }
  }

  _navigateToChangeTelephoneScreen(
      BuildContext context, int contactOrder) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChangeTelephoneScreen(
                contactOrder: contactOrder,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        ScopedModelDescendant<AppDataModel>(builder: (context, child, model) {
      return SettingsList(
        // backgroundColor: Colors.black54,
        sections: [
          SettingsSection(
            title: 'Ajustes',
            // titleTextStyle: TextStyle(fontSize: 30),
            tiles: [
              SettingsTile(
                title: 'Bluetooth',
                subtitle: model.getConnectedDevice() != null
                    ? "Conectado"
                    : "Desconectado",
                leading: Icon(Icons.bluetooth),
                onTap: () {
                  _navigateToBluetoothDevicesScreen(context, model);
                },
              ),
              SettingsTile(
                title: 'Mi teléfono',
                subtitle: model.getFirstTelephone() != null &&
                        model.getFirstTelephone().isNotEmpty
                    ? model.getFirstTelephone()
                    : "Sin teléfono",
                leading: Icon(Icons.call),
                onTap: () {
                  _navigateToChangeTelephoneScreen(context, 0);
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Contactos de emergencia',
            tiles: [
              SettingsTile(
                title: 'Contacto principal',
                subtitle: model.getSecondTelephone() != null &&
                        model.getSecondTelephone().isNotEmpty
                    ? model.getSecondTelephone()
                    : "Sin asignar",
                leading: Icon(Icons.call),
                onTap: () {
                  _navigateToChangeTelephoneScreen(context, 1);
                },
              ),
              SettingsTile(
                title: 'Contacto secundario',
                subtitle: model.getThirdTelephone() != null &&
                        model.getThirdTelephone().isNotEmpty
                    ? model.getThirdTelephone()
                    : "Sin asignar",
                leading: Icon(Icons.call),
                onTap: () {
                  _navigateToChangeTelephoneScreen(context, 2);
                },
              ),
            ],
          ),
          CustomSection(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                ),
                Text(
                  'Version: 0.0.1 (Alpha)',
                  style: TextStyle(color: Color(0xFF777777)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                ),
              ],
            ),
          ),
        ],
      );
    }));
  }
}
