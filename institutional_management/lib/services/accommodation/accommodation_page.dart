import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/accommodation.dart';
import '../../providers/accommodation_provider.dart';
import '../../widgets/accommodation_booking_sheet.dart';
import '../../widgets/accommodation_card.dart';

class AccommodationPage extends StatefulWidget {
  @override
  _AccommodationPageState createState() => _AccommodationPageState();
}

class _AccommodationPageState extends State<AccommodationPage> {
  @override
  void initState() {
    super.initState();
    // Load accommodations when page initializes
    Future.microtask(
      () =>
          Provider.of<AccommodationProvider>(
            context,
            listen: false,
          ).fetchAccommodations(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccommodationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Accommodations'),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.purple.shade600],
                ),
              ),
            ),
          ),
          body:
              provider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : provider.accommodations.isEmpty
                  ? Center(child: Text('No accommodations available'))
                  : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Available Rooms',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final accommodation =
                                provider.accommodations[index];
                            return AccommodationCard(
                              accommodation: accommodation,
                              onTap:
                                  () => _showBookingDialog(
                                    context,
                                    accommodation,
                                  ),
                            );
                          }, childCount: provider.accommodations.length),
                        ),
                      ),
                    ],
                  ),
        );
      },
    );
  }

  void _showBookingDialog(BuildContext context, Accommodation accommodation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AccommodationBookingSheet(accommodation: accommodation),
    );
  }
}

class AccommodationCard extends StatelessWidget {
  final Accommodation accommodation;
  final VoidCallback onTap;

  const AccommodationCard({required this.accommodation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                accommodation.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accommodation.type,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Capacity: ${accommodation.capacity}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${accommodation.price}/night',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
