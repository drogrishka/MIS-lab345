import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import '../Models/list_item.dart';
import 'adaptive_flat_button.dart';

class NovElement extends StatefulWidget {
  final Function addItem;

  NovElement(this.addItem);
  @override
  State<StatefulWidget> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement> {
  final _naslovController = TextEditingController();
  final _vrednostController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  void _submitData() {
    if (_vrednostController.text.isEmpty) {
      return;
    }
    final vnesenNaslov = _naslovController.text;
    final vnesenaVrednost = _vrednostController.text;
    final vnesenaLatitude = _latitudeController.text;
    final vnesenaLongitude = _longitudeController.text;

    if (vnesenNaslov.isEmpty || vnesenaVrednost.isEmpty || vnesenaLongitude.isEmpty || vnesenaLatitude.isEmpty) {
      return;
    }

    final newItem = ListItem(id: nanoid(5), subject: vnesenNaslov,
                             date: DateTime.parse(vnesenaVrednost),
                              latitude: double.parse(vnesenaLatitude) ,
                              longitude: double.parse(vnesenaLongitude),);
    widget.addItem(newItem);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Subject added to the calendar"),
          duration: Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _naslovController,
            decoration: InputDecoration(labelText: "Subject",),
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _vrednostController,
            decoration: InputDecoration(labelText: "Date"),
            keyboardType: TextInputType.datetime,
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _latitudeController,
            decoration: InputDecoration(labelText: "Latitude"),
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _longitudeController,
            decoration: InputDecoration(labelText: "Longitude"),
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _submitData(),
          ),
          AdaptiveFlatButton("Add", _submitData)
        ],
      ),
    );
  }
}
