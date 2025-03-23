import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../widgets/faculty_card.dart';
import '../models/appointment.dart';
import '../models/appointment_request.dart';
import '../providers/auth_provider.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _purposeController = TextEditingController();
  String? _selectedTimeSlot;
  String _studentName = '';

  @override
  void initState() {
    super.initState();
    _fetchData();

    // Get the user's name from the auth provider if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated && authProvider.currentUser != null) {
        setState(() {
          _studentName = authProvider.currentUser!.name;
        });
      }
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<AppointmentProvider>().fetchFaculty();
    } catch (e) {
      // Error handling is done in the provider
      print('Error fetching faculty: $e');
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _bookAppointment(BuildContext context, Faculty faculty) async {
    if (!_formKey.currentState!.validate()) return;

    final request = AppointmentRequest(
      facultyId: faculty.id,
      studentName: _studentName.isEmpty ? 'Student User' : _studentName,
      date: _dateController.text,
      time: _selectedTimeSlot!,
      purpose: _purposeController.text,
    );

    final success = await context.read<AppointmentProvider>().bookAppointment(
      request,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment booked successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book appointment. Please try again.'),
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
                'Appointment Booking',
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
                    'https://images.unsplash.com/photo-1572025442646-866d16c84a54?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
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
          Consumer<AppointmentProvider>(
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

              if (provider.faculty.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, color: Colors.grey, size: 60),
                        SizedBox(height: 16),
                        Text(
                          'No faculty available',
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
                          'Available Faculty',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    final faculty = provider.faculty[index - 1];
                    return FacultyCard(
                      faculty: faculty,
                      onSelected: () => _showBookingDialog(context, faculty),
                    );
                  },
                  childCount: provider.faculty.length + 1, // +1 for title
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

  void _showBookingDialog(BuildContext context, Faculty faculty) {
    // Reset the form values
    _dateController.text = '';
    _purposeController.text = '';
    _selectedTimeSlot = null;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Book Appointment with ${faculty.name}'),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${faculty.department} - ${faculty.position}',
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
                            faculty.availableSlots
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
                            (value) =>
                                setState(() => _selectedTimeSlot = value),
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
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => _bookAppointment(context, faculty),
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
