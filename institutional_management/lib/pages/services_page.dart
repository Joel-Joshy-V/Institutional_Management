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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Services',
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
                    'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
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
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Services',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final service = services[index];
                return ServiceCard(service: service);
              }, childCount: services.length),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
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
              Icon(service.icon, size: 48.0, color: Colors.blue.shade700),
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
