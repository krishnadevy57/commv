import 'package:commv/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';

const String kGoogleApiKey =
    'AIzaSyCZS8BFO35e-deCgcJYcXtccNKstXFgQMQ'; // 🔒 Replace with your key
final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({Key? key}) : super(key: key);

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _currentLatLng = const LatLng(37.7749, -122.4194); // Default location
  String _currentAddress = 'Fetching address...';

  final TextEditingController _searchController = TextEditingController();
  List<Prediction> _predictions = [];
  String _sessionToken = const Uuid().v4();

  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _addressUserNameController =
      TextEditingController();
  final TextEditingController _addressUserMobileNumberController =
      TextEditingController();
  final TextEditingController _addressUserAddressPincodeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    _updateCameraPosition(LatLng(position.latitude, position.longitude));
  }

  void _updateCameraPosition(LatLng position) async {
    setState(() => _currentLatLng = position);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      _houseController.text = place.street ?? "";
      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    }
  }

  void _onSearchChanged(String value) async {
    if (value.isEmpty) {
      setState(() => _predictions = []);
      return;
    }

    final response = await _places.autocomplete(
      value,
      sessionToken: _sessionToken,
      types: ['geocode'],
      language: 'en',
    );

    if (response.isOkay) {
      setState(() {
        _predictions = response.predictions;
      });
    }
  }

  Future<void> _selectPrediction(Prediction prediction) async {
    final detail = await _places.getDetailsByPlaceId(
      prediction.placeId!,
      sessionToken: _sessionToken,
    );

    final location = detail.result.geometry!.location;
    final newLatLng = LatLng(location.lat, location.lng);

    _searchController.text = prediction.description ?? '';
    _predictions = [];
    _currentLatLng = newLatLng;
    await _mapController?.animateCamera(CameraUpdate.newLatLng(newLatLng));
    _updateCameraPosition(newLatLng);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Address", style: textTheme.titleLarge),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLatLng,
              zoom: 16,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraIdle: () => _updateCameraPosition(_currentLatLng),
            onCameraMove: (position) => _currentLatLng = position.target,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Center(
            child:
                Icon(Icons.location_pin, color: colorScheme.primary, size: 50),
          ),
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: "Search for a place",
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: colorScheme.onSurface),
                    ),
                  ),
                ),
                if (_predictions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _predictions.length,
                      itemBuilder: (context, index) {
                        final p = _predictions[index];
                        return ListTile(
                          title: Text(
                            p.description ?? '',
                            style: textTheme.bodyMedium,
                          ),
                          onTap: () => _selectPrediction(p),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 120,
            left: 16,
            right: 16,
            child: Card(
              color: colorScheme.surface,
              child: ListTile(
                leading: Icon(Icons.location_on, color: colorScheme.primary),
                title: Text(
                  _currentAddress,
                  style: textTheme.bodyLarge,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _openAddressDetailsModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Proceed',
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onPrimary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _selectedAddressType = 'Home';

  void _openAddressDetailsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final textTheme = theme.textTheme;
        final colorScheme = theme.colorScheme;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add More Address Details",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ['Home', 'Work', 'Other'].map((type) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(type),
                            selected: _selectedAddressType == type,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedAddressType = type;
                                });
                              }
                            },
                            selectedColor: colorScheme.primary,
                            labelStyle: TextStyle(
                              color: _selectedAddressType == type
                                  ? colorScheme.onPrimary
                                  : colorScheme.onBackground,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _houseController,
                      decoration: InputDecoration(
                        labelText: "House/Flat Number",
                        labelStyle: textTheme.bodyMedium,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _landmarkController,
                      decoration: InputDecoration(
                        labelText: "Landmark",
                        labelStyle: textTheme.bodyMedium,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _addressUserNameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: textTheme.bodyMedium,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _addressUserMobileNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Mobile number",
                        labelStyle: textTheme.bodyMedium,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _addressUserAddressPincodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Pincode",
                        labelStyle: textTheme.bodyMedium,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final houseNumber = _houseController.text;
                          final landmark = _landmarkController.text;
                          final addressUserName =
                              _addressUserNameController.text;
                          final addressUserMobileNumber =
                              _addressUserMobileNumberController.text;
                          final addressUserPincode =
                              _addressUserAddressPincodeController.text;
                          var lat = _currentLatLng.latitude;
                          var long = _currentLatLng.longitude;
                          final fullAddress = " $_currentAddress";

                          Navigator.pop(context);

                          final addressMap = {
                            "houseNumber": houseNumber,
                            "landmark": landmark,
                            "addressUserName": addressUserName,
                            "addressUserMobileNumber": addressUserMobileNumber,
                            "addressUserPincode": addressUserPincode,
                            "latitude": lat,
                            "longitude": long,
                            "fullAddress": fullAddress,
                            "addressType": _selectedAddressType,
                          };
                          Navigator.pop(context, AddressModel.fromMap(addressMap));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Done',
                          style: textTheme.bodyLarge
                              ?.copyWith(color: colorScheme.onPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
