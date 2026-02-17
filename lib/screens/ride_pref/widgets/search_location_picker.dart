import 'package:flutter/material.dart';
import 'package:week3/model/ride/locations.dart';
import '../../../dummy_data/dummy_data.dart';

class LocationPickerRow extends StatelessWidget {
  final String label;
  final Location? selectedLocation;
  final ValueChanged<Location> onLocationPicked;

  const LocationPickerRow({
    super.key,
    required this.label,
    required this.selectedLocation,
    required this.onLocationPicked,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push<Location>(
          context,
          MaterialPageRoute(builder: (context) => LocationSearchPage()),
        );

        if (result != null) {
          onLocationPicked(result);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF004D4D), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                selectedLocation?.name ?? label,
                style: TextStyle(
                  color: selectedLocation != null
                      ? const Color(0xFF004D4D)
                      : Colors.grey[600],
                  fontSize: 16,
                  fontWeight: selectedLocation != null
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF004D4D)),
          ],
        ),
      ),
    );
  }
}

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Location> _filteredLocations = List.from(fakeLocations);
  final Color primaryTeal = const Color(0xFF004D4D);
  final Color secondaryGrey = const Color(0xFF6A7D7D);
  final Color backgroundGrey = const Color(0xFFF2F5F5);

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLocations = fakeLocations
          .where(
            (loc) =>
                loc.name.toLowerCase().contains(query) ||
                loc.country.name.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundGrey,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(
                    color: primaryTeal,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search location...",
                    hintStyle: TextStyle(color: secondaryGrey),
                    prefixIcon: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: primaryTeal,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close, color: primaryTeal),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            Expanded(
              child: _filteredLocations.isEmpty
                  ? Center(
                      child: Text(
                        "No locations found",
                        style: TextStyle(color: secondaryGrey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredLocations.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey[200],
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final loc = _filteredLocations[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 4,
                          ),
                          // Matches the history/location icons in the image
                          leading: Icon(
                            _searchController.text.isEmpty
                                ? Icons.access_time
                                : Icons.location_on_outlined,
                            color: secondaryGrey,
                            size: 20,
                          ),
                          title: Text(
                            loc.name,
                            style: TextStyle(
                              color: primaryTeal,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            loc.country.name,
                            style: TextStyle(
                              color: secondaryGrey,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: primaryTeal,
                            size: 20,
                          ),
                          onTap: () => Navigator.pop(context, loc),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
