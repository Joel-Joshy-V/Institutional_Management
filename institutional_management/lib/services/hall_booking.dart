import 'package:flutter/material.dart';
import 'package:institutional_management/models/hall.dart';
import 'package:provider/provider.dart';
import '../providers/hall_provider.dart';
import '../widgets/hall_card.dart';
import '../models/hall_booking_request.dart';

class HallBookingPage extends StatefulWidget {
  const HallBookingPage({Key? key}) : super(key: key);

  @override
  _HallBookingPageState createState() => _HallBookingPageState();
}

class _HallBookingPageState extends State<HallBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _purposeController = TextEditingController();
  String? _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    context.read<HallProvider>().fetchHalls();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _bookHall(BuildContext context, Hall hall) async {
    if (!_formKey.currentState!.validate()) return;

    final request = HallBookingRequest(
      hallId: hall.id,
      date: _dateController.text,
      timeSlot: _selectedTimeSlot!,
      purpose: _purposeController.text,
    );

    final success = await context.read<HallProvider>().bookHall(request);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hall booked successfully!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book hall. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HallProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(title: Text('Hall Booking')),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: provider.halls.length,
                  itemBuilder: (context, index) {
                    final hall = provider.halls[index];
                    return HallCard(
                      hall: hall,
                      onSelected: () => _showBookingDialog(context, hall),
                    );
                  },
                ),
              ),
              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    provider.error!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showBookingDialog(BuildContext context, Hall hall) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Book ${hall.name}'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Date'),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      );
                      if (date != null) {
                        _dateController.text =
                            date.toIso8601String().split('T')[0];
                      }
                    },
                    validator:
                        (value) =>
                            value?.isEmpty ?? true
                                ? 'Please select a date'
                                : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedTimeSlot,
                    decoration: InputDecoration(labelText: 'Time Slot'),
                    items:
                        hall.availableSlots
                            .where((slot) => slot.isAvailable)
                            .map(
                              (slot) => DropdownMenuItem(
                                value: slot.time,
                                child: Text(slot.time),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() => _selectedTimeSlot = value),
                    validator:
                        (value) =>
                            value == null ? 'Please select a time slot' : null,
                  ),
                  TextFormField(
                    controller: _purposeController,
                    decoration: InputDecoration(labelText: 'Purpose'),
                    validator:
                        (value) =>
                            value?.isEmpty ?? true
                                ? 'Please enter purpose'
                                : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => _bookHall(context, hall),
                child: Text('Book'),
              ),
            ],
          ),
    );
  }
}
