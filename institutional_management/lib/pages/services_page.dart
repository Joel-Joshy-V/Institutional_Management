import 'package:flutter/material.dart';

class Service {
  final String name;
  final String description;
  final IconData icon;
  final Widget page;

  Service({
    required this.name,
    required this.description,
    required this.icon,
    required this.page,
  });
}

class ServicesPage extends StatelessWidget {
  final List<Service> services = [
    Service(
      name: 'Canteen',
      description: 'Order food and beverages from the institutional canteen',
      icon: Icons.restaurant,
      page: _getPageByName('CanteenPage'),
    ),
    Service(
      name: 'Accommodation',
      description: 'Book rooms and view accommodation facilities',
      icon: Icons.hotel,
      page: _getPageByName('AccommodationPage'),
    ),
    Service(
      name: 'Transportation',
      description: 'Book transportation and check schedules',
      icon: Icons.directions_bus,
      page: _getPageByName('TransportationPage'),
    ),
    Service(
      name: 'Hall Booking',
      description: 'Book halls for events and meetings',
      icon: Icons.meeting_room,
      page: _getPageByName('HallBookingPage'),
    ),
    Service(
      name: 'Appointments',
      description: 'Schedule appointments with faculty and staff',
      icon: Icons.calendar_today,
      page: _getPageByName('AppointmentPage'),
    ),
    Service(
      name: 'Ticket Booking',
      description: 'Book tickets for campus events',
      icon: Icons.confirmation_number,
      page: _getPageByName('TicketBookingPage'),
    ),
    Service(
      name: 'Payments',
      description: 'Make payments for fees and services',
      icon: Icons.payment,
      page: _getPageByName('PaymentsPage'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.purple.shade600],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ServiceCard(service: service);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _getPageByName(String name) {
    // This is a placeholder. In a real app, you'd use a more structured approach
    // to get the actual page widgets.
    return Center(child: Text('$name Coming Soon'));
  }
}

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({required this.service, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => service.page),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                service.icon,
                size: 48.0,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 16.0),
              Text(
                service.name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                service.description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
