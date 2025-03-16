import 'package:flutter/material.dart';
import 'appointment_page.dart'; // Import the appointment page
import 'accommodations_page.dart'; // Import the accommodations page
import 'hall_booking.dart'; // Import the hall booking page
import 'payments.dart'; // Import the payments page
import 'ticket_booking.dart'; // Import the ticket booking page
import 'canteen_page.dart'; // Import the canteen page
import 'transportation.dart'; // Import the transportation page

class ServicesPage extends StatelessWidget {
  // List of services
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Appointment',
      'icon': Icons.calendar_today,
      'color': Colors.blue,
      'description': 'Book appointments with faculty or staff.',
    },
    {
      'title': 'Accommodations',
      'icon': Icons.hotel,
      'color': Colors.green,
      'description': 'Find and book accommodations on campus.',
    },
    {
      'title': 'Hall Booking',
      'icon': Icons.meeting_room,
      'color': Colors.orange,
      'description': 'Book halls for events or meetings.',
    },
    {
      'title': 'Payments',
      'icon': Icons.payment,
      'color': Colors.purple,
      'description': 'Make payments for fees or services.',
    },
    {
      'title': 'Ticket Booking',
      'icon': Icons.confirmation_number,
      'color': Colors.red,
      'description': 'Book tickets for events or activities.',
    },
    {
      'title': 'Canteen Food',
      'icon': Icons.fastfood,
      'color': Colors.teal,
      'description': 'Order food from the canteen.',
    },
    {
      'title': 'Transportation',
      'icon': Icons.directions_bus,
      'color': Colors.indigo,
      'description': 'Book transportation services.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            Text(
              'Explore all available services',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade800,
                Colors.purple.shade600,
              ],
            ),
          ),
        ),
        elevation: 0, // Remove app bar shadow
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade800,
              Colors.purple.shade600,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0, // Square cards
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navigate to the respective service page
                  _navigateToService(context, services[index]['title']);
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          services[index]['color'].withOpacity(0.8),
                          services[index]['color'].withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          services[index]['icon'],
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          services[index]['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            services[index]['description'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Navigate to the respective service page
  void _navigateToService(BuildContext context, String serviceTitle) {
    switch (serviceTitle) {
      case 'Appointment':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppointmentPage()),
        );
        break;
      case 'Accommodations':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccommodationsPage()),
        );
        break;
      case 'Hall Booking':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HallBookingPage()),
        );
        break;
      case 'Payments':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentsPage()),
        );
        break;
      case 'Ticket Booking':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TicketBookingPage()),
        );
        break;
      case 'Canteen Food':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CanteenPage()),
        );
        break;
      case 'Transportation':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransportationPage()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Service not implemented yet.'),
            duration: Duration(seconds: 1),
          ),
        );
    }
  }
}