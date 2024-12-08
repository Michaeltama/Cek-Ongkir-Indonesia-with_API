import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RajaOngkirTrackingService {
  final String apiKey = 'cc5b07492858500cff5c310af0b71481';
  final String baseUrl = 'https://api.rajaongkir.com/starter';

  Future<Map<String, dynamic>> trackShipment({
    required String waybill,
    required String courier,
  }) async {
    final url = Uri.parse('$baseUrl/waybill');
    try {
      final response = await http.post(
        url,
        headers: {
          'key': apiKey,
          'content-type': 'application/x-www-form-urlencoded',
        },
        body: {
          'waybill': waybill,
          'courier': courier,
        },
      ).timeout(
        const Duration(seconds: 20),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['rajaongkir']['result'] ?? {};
      } else {
        throw Exception(
            'Failed to track shipment. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error tracking shipment: $e');
    }
  }
}

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final RajaOngkirTrackingService _service = RajaOngkirTrackingService();
  final TextEditingController _waybillController = TextEditingController();
  String? _selectedCourier;
  Map<String, dynamic>? _trackingData;
  bool _isLoading = false;

  final List<Map<String, String>> _couriers = [
    {'code': 'jne', 'name': 'JNE'},
    {'code': 'pos', 'name': 'POS Indonesia'},
    {'code': 'tiki', 'name': 'TIKI'},
  ];

  Future<void> _trackShipment() async {
    if (_waybillController.text.isEmpty || _selectedCourier == null) {
      _showErrorMessage('Please fill all fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _service.trackShipment(
        waybill: _waybillController.text,
        courier: _selectedCourier!,
      );
      if (mounted) {
        setState(() {
          _trackingData = result;
        });
      }
    } catch (e) {
      if (mounted) _showErrorMessage('Error tracking shipment: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Barang'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF087F23)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _waybillController,
              decoration: const InputDecoration(
                labelText: 'Nomor Resi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  labelText: 'Pilih Kurir',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)))),
              value: _selectedCourier,
              items: _couriers.map((courier) {
                return DropdownMenuItem<String>(
                  value: courier['code'],
                  child: Text(courier['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCourier = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _trackShipment,
              child: const Text('Lacak Barang'),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _trackingData != null
                    ? Expanded(
                        child: ListView(
                          children: [
                            Text(
                              'Status: ${_trackingData!['delivery_status']['status'] ?? 'Unknown'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...(_trackingData!['manifest'] as List<dynamic>)
                                .map(
                                  (manifest) => ListTile(
                                    title: Text(manifest['description']),
                                    subtitle: Text(
                                        '${manifest['city_name']} - ${manifest['manifest_date']} ${manifest['manifest_time']}'),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      )
                    : const Center(child: Text('Masukkan resi untuk melacak')),
          ],
        ),
      ),
    );
  }
}
