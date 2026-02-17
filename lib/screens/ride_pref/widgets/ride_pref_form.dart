import 'package:flutter/material.dart';
import 'package:week3/screens/ride_pref/widgets/search_location_picker.dart';
import '../../../widgets/actions/bla_button.dart';
import '../../../dummy_data/dummy_data.dart';
import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  // The form can be created with an optional initial RidePref.
  final RidePref? initRidePref;

  const RidePrefForm({super.key, this.initRidePref});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  late DateTime departureDate;
  Location? arrival;
  late int requestedSeats;
  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  @override
  void initState() {
    super.initState();
    // TODO
    departure = widget.initRidePref?.departure;
    arrival = widget.initRidePref?.arrival;
    departureDate = widget.initRidePref?.departureDate ?? DateTime.now();
    requestedSeats = widget.initRidePref?.requestedSeats ?? 1;
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------
  void onDepartureChanged(Location? value) {
    setState(() => departure = value);
  }

  void onArrivalChanged(Location? value) {
    setState(() => arrival = value);
  }

  void onSeatsChanged(int? value) {
    setState(() => requestedSeats = value!);
  }

  Future<void> onPickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => departureDate = picked);
    }
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------
  Widget buildFormField() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Departure
          // Departure
          LocationPickerRow(
            label: "Leaving from",
            selectedLocation: departure,
            onLocationPicked: (loc) => setState(() => departure = loc),
          ),

          // Swap button
          IconButton(
            icon: const Icon(Icons.swap_vert, color: Colors.grey, size: 30),
            onPressed: () {
              setState(() {
                final temp = departure;
                departure = arrival;
                arrival = temp;
              });
            },
          ),

          // Arrival
          LocationPickerRow(
            label: "Going to",
            selectedLocation: arrival,
            onLocationPicked: (loc) => setState(() => arrival = loc),
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),
          // Date
          _dateRow(),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // Seats
          _seatsRow(),

          // Search button
          BlaButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const LocationSearchWidget(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }

  Widget _dateRow() {
    return InkWell(
      onTap: onPickDate,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              "${departureDate.toLocal().day}/${departureDate.toLocal().month}/${departureDate.toLocal().year}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: Colors.grey, size: 24),
          const SizedBox(width: 16),
          DropdownButton<int>(
            value: requestedSeats,
            underline: const SizedBox(),
            onChanged: (value) => onSeatsChanged(value ?? 1),
            items: List.generate(
              5,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text("${index + 1}"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [buildFormField()],
    );
  }
}
