import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/app_data_model.dart';
import 'pages/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: new AppDataModel(),
        child: MaterialApp(home: Home())
    );
  }
}
