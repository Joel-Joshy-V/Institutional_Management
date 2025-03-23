import 'package:flutter/material.dart';
import '../models/hall.dart';
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
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await context.read<HallProvider>().fetchHalls();
    } catch (e) {
      // Error handling is done in the provider
      print('Error fetching halls: $e');
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hall booked successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book hall. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Hall Booking',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<HallProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (provider.error != null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 60),
                        SizedBox(height: 16),
                        Text(
                          provider.error!,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchData,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (provider.halls.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.meeting_room, color: Colors.grey, size: 60),
                        SizedBox(height: 16),
                        Text(
                          'No halls available',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Available Halls',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    final hall = provider.halls[index - 1];
                    return HallCard(
                      hall: hall,
                      onSelected: () => _showBookingDialog(context, hall),
                    );
                  },
                  childCount: provider.halls.length + 1, // +1 for title
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blue.shade700,
      ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Capacity: ${hall.capacity}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      );
                      if (date != null) {
                        setState(() {
                          _dateController.text =
                              date.toIso8601String().split('T')[0];
                          // Reset time slot when date changes
                          _selectedTimeSlot = null;
                        });
                      }
                    },
                    validator:
                        (value) =>
                            value?.isEmpty ?? true
                                ? 'Please select a date'
                                : null,
                  ),
                  SizedBox(height: 16),
                  if (_dateController.text.isNotEmpty) ...[
                    DropdownButtonFormField<String>(
                      value: _selectedTimeSlot,
                      decoration: InputDecoration(
                        labelText: 'Time Slot',
                        prefixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items:
                          hall.availableSlots
                              .where(
                                (slot) =>
                                    slot.isAvailable &&
                                    slot.date == _dateController.text,
                              )
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
                              value == null
                                  ? 'Please select a time slot'
                                  : null,
                      hint: Text('Select time slot'),
                    ),
                    SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _purposeController,
                    decoration: InputDecoration(
                      labelText: 'Purpose',
                      prefixIcon: Icon(Icons.subject),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: Text('Book'),
              ),
            ],
          ),
    );
  }
}
