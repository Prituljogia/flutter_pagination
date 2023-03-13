import 'package:flutter/material.dart';

import 'model/passenger_data_model.dart';

class ListItem extends StatelessWidget {
  const ListItem({Key? key, required this.passenger}) : super(key: key);
final Datum passenger;
  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
        radius: 25,
        child: Image.network(
          passenger.airline.first.logo,
          fit: BoxFit.cover,
        )),
    title: Text(passenger.name),
    subtitle: Text(passenger.airline.first.country),
  );
}
