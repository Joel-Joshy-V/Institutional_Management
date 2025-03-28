import 'package:flutter/material.dart';
import '../models/hall.dart';

class HallCard extends StatelessWidget {
  final Hall hall;
  final VoidCallback onSelected;

  const HallCard({Key? key, required this.hall, required this.onSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Count available slots
    final availableSlotCount =
        hall.availableSlots.where((slot) => slot.isAvailable).length;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Left side with icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.meeting_room,
                  color: Colors.blue.shade700,
                  size: 32,
                ),
              ),
              SizedBox(width: 16),
              // Middle with hall info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hall.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Capacity: ${hall.capacity}',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 16,
                          color:
                              availableSlotCount > 0
                                  ? Colors.green
                                  : Colors.red,
                        ),
                        SizedBox(width: 4),
                        Text(
                          availableSlotCount > 0
                              ? '$availableSlotCount available slots'
                              : 'No available slots',
                          style: TextStyle(
                            color:
                                availableSlotCount > 0
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Right side with button
              ElevatedButton(
                onPressed: availableSlotCount > 0 ? onSelected : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
