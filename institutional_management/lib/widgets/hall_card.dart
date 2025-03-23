import 'package:flutter/material.dart';
import '../models/hall.dart';

class HallCard extends StatelessWidget {
  final Hall hall;
  final VoidCallback onSelected;

  const HallCard({Key? key, required this.hall, required this.onSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(hall.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Capacity: ${hall.capacity}'),
            Text(
              'Available Slots: ${hall.availableSlots.where((slot) => slot.isAvailable).length}',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onSelected,
          child: Text('Book Now'),
        ),
      ),
    );
  }
}
