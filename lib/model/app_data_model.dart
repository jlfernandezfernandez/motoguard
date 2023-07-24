import 'package:flutter_blue/flutter_blue.dart';
import 'package:scoped_model/scoped_model.dart';

class AppDataModel extends Model {
  BluetoothDevice connectedDevice;
  BluetoothService dataService;
  BluetoothService settingsService;
  BluetoothCharacteristic contactsCharacteristic;
  BluetoothCharacteristic speedCharacteristic;
  BluetoothCharacteristic movementCharacteristic;
  DateTime lastTimeUpdateMovement;
  List<String> telephones = new List(3);

  void setConnectedDevice(BluetoothDevice bluetoothDevice) {
    connectedDevice = bluetoothDevice;
    notifyListeners();
  }

  BluetoothDevice getConnectedDevice() {
    return connectedDevice;
  }

  void setSettingsService(BluetoothService bluetoothService) {
    settingsService = bluetoothService;
    notifyListeners();
  }

  BluetoothService getSettingsService() {
    return settingsService;
  }

  void setDataService(BluetoothService bluetoothService) {
    dataService = bluetoothService;
    notifyListeners();
  }

  BluetoothService getDataService() {
    return dataService;
  }

  void setContactsCharacteristic(
      BluetoothCharacteristic bluetoothCharacteristic) {
    contactsCharacteristic = bluetoothCharacteristic;
    notifyListeners();
  }

  BluetoothCharacteristic getContactsCharacteristic() {
    return contactsCharacteristic;
  }

  void setSpeedCharacteristic(BluetoothCharacteristic bluetoothCharacteristic) {
    speedCharacteristic = bluetoothCharacteristic;
    notifyListeners();
  }

  BluetoothCharacteristic getSpeedCharacteristic() {
    return speedCharacteristic;
  }

  void setMovementCharacteristic(
      BluetoothCharacteristic bluetoothCharacteristic) {
    movementCharacteristic = bluetoothCharacteristic;
    notifyListeners();
  }

  BluetoothCharacteristic getMovementCharacteristic() {
    return movementCharacteristic;
  }

  void setLastTimeUpdateMovement(DateTime dateTime) {
    lastTimeUpdateMovement = dateTime;
    notifyListeners();
  }

  DateTime getLastTimeUpdateMovement() {
    return lastTimeUpdateMovement;
  }

  void setFirstTelephone(String telephone) {
    telephones[0] = telephone;
    notifyListeners();
  }

  String getFirstTelephone() {
    return telephones[0];
  }

  void setSecondTelephone(String telephone) {
    telephones[1] = telephone;
    notifyListeners();
  }

  String getSecondTelephone() {
    return telephones[1];
  }

  void setThirdTelephone(String telephone) {
    telephones[2] = telephone;
    notifyListeners();
  }

  String getThirdTelephone() {
    return telephones[2];
  }

  void setTelephone(int contactOrder, String telephone) {
    telephones[contactOrder] = telephone;
    notifyListeners();
  }

  List<String> getTelephones() {
    return telephones;
  }
}
