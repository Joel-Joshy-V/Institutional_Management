import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/accommodation.dart';
import '../models/accommodation_booking_request.dart';
import '../providers/accommodation_provider.dart';

class AccommodationBookingSheet extends StatefulWidget {
  final Accommodation accommodation;

  const AccommodationBookingSheet({required this.accommodation, Key? key})
    : super(key: key);

  @override
  _AccommodationBookingSheetState createState() =>
      _AccommodationBookingSheetState();
}

class _AccommodationBookingSheetState extends State<AccommodationBookingSheet> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _checkInDate;
  late DateTime _checkOutDate;

  @override
  void initState() {
    super.initState();
    _checkInDate = DateTime.now().add(Duration(days: 1));
    _checkOutDate = DateTime.now().add(Duration(days: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              widget.accommodation.type,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.accommodation.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Capacity'),
                        trailing: Text(widget.accommodation.capacity),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Price per night'),
                        trailing: Text(
                          '\$${widget.accommodation.price.toStringAsFixed(2)}',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Check-in Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectCheckInDate(context),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_checkInDate.day}/${_checkInDate.month}/${_checkInDate.year}',
                              ),
                              Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Check-out Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectCheckOutDate(context),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_checkOutDate.day}/${_checkOutDate.month}/${_checkOutDate.year}',
                              ),
                              Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Total Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$${_calculateTotalPrice()}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: Consumer<AccommodationProvider>(
                          builder: (context, provider, child) {
                            return ElevatedButton(
                              onPressed:
                                  provider.isLoading
                                      ? null
                                      : () => _submitBooking(context, provider),
                              child:
                                  provider.isLoading
                                      ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text('Book Now'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != _checkInDate) {
      setState(() {
        _checkInDate = picked;
        if (_checkInDate.isAfter(_checkOutDate) ||
            _checkInDate == _checkOutDate) {
          _checkOutDate = _checkInDate.add(Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate,
      firstDate: _checkInDate.add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  String _calculateTotalPrice() {
    final nights = _checkOutDate.difference(_checkInDate).inDays;
    final totalPrice = nights * widget.accommodation.price;
    return totalPrice.toStringAsFixed(2);
  }

  Future<void> _submitBooking(
    BuildContext context,
    AccommodationProvider provider,
  ) async {
    if (_formKey.currentState!.validate()) {
      final request = AccommodationBookingRequest(
        accommodationId: widget.accommodation.id,
        checkIn:
            '${_checkInDate.year}-${_checkInDate.month.toString().padLeft(2, '0')}-${_checkInDate.day.toString().padLeft(2, '0')}',
        checkOut:
            '${_checkOutDate.year}-${_checkOutDate.month.toString().padLeft(2, '0')}-${_checkOutDate.day.toString().padLeft(2, '0')}',
        purpose: 'Academic Stay',
      );

      final success = await provider.bookAccommodation(request);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book accommodation: ${provider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
