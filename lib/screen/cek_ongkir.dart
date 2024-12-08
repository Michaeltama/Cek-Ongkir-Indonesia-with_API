import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RajaOngkirService {
  final String apiKey = 'cc5b07492858500cff5c310af0b71481';
  final String baseUrl = 'https://api.rajaongkir.com/starter';

  Future<List<dynamic>> getProvinces() async {
    final url = Uri.parse('$baseUrl/province');
    try {
      final response = await http.get(url, headers: {'key': apiKey}).timeout(
        const Duration(seconds: 20),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['rajaongkir']['results'] ?? [];
      } else {
        throw Exception(
            'Failed to fetch provinces. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching provinces: $e');
    }
  }

  Future<List<dynamic>> getCities(String provinceId) async {
    final url = Uri.parse('$baseUrl/city?province=$provinceId');
    try {
      final response = await http.get(url, headers: {'key': apiKey}).timeout(
        const Duration(seconds: 20),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['rajaongkir']['results'] ?? [];
      } else {
        throw Exception(
            'Failed to fetch cities. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }

  Future<List<dynamic>> getCosts({
    required String origin,
    required String destination,
    required String weight,
    required String courier,
  }) async {
    final url = Uri.parse('$baseUrl/cost');
    try {
      final response = await http.post(
        url,
        headers: {
          'key': apiKey,
          'content-type': 'application/x-www-form-urlencoded',
        },
        body: {
          'origin': origin,
          'destination': destination,
          'weight': weight,
          'courier': courier,
        },
      ).timeout(
        const Duration(seconds: 20),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['rajaongkir']['results'][0]['costs'] ?? [];
      } else {
        throw Exception(
            'Failed to fetch costs. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching costs: $e');
    }
  }
}

class CekOngkirScreen extends StatefulWidget {
  @override
  _CekOngkirScreenState createState() => _CekOngkirScreenState();
}

class _CekOngkirScreenState extends State<CekOngkirScreen> {
  final RajaOngkirService _service = RajaOngkirService();
  List<dynamic> _provinces = [];
  List<dynamic> _originCities = [];
  List<dynamic> _destinationCities = [];
  List<dynamic> _costs = [];
  bool _isLoading = false;

  String? _originProvince;
  String? _originCity;
  String? _destinationProvince;
  String? _destinationCity;
  String? _selectedCourier;
  final TextEditingController _weightController = TextEditingController();

  final List<Map<String, String>> _couriers = [
    {'code': 'jne', 'name': 'JNE'},
    {'code': 'pos', 'name': 'POS Indonesia'},
    {'code': 'tiki', 'name': 'TIKI'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
  }

  Future<void> _fetchProvinces() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final provinces = await _service.getProvinces();
      if (mounted) {
        setState(() {
          _provinces = provinces;
        });
      }
    } catch (e) {
      if (mounted) _showErrorMessage('Error fetching provinces: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchCities(String provinceId, bool isOrigin) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final cities = await _service.getCities(provinceId);
      if (mounted) {
        setState(() {
          if (isOrigin) {
            _originCities = cities;
            _originCity = cities.isNotEmpty ? cities[0]['city_id'] : null;
          } else {
            _destinationCities = cities;
            _destinationCity = cities.isNotEmpty ? cities[0]['city_id'] : null;
          }
        });
      }
    } catch (e) {
      if (mounted) _showErrorMessage('Error fetching cities: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchCosts() async {
    if (_originCity == null ||
        _destinationCity == null ||
        _weightController.text.isEmpty ||
        _selectedCourier == null) {
      _showErrorMessage('Please fill all fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final costs = await _service.getCosts(
        origin: _originCity!,
        destination: _destinationCity!,
        weight: _weightController.text,
        courier: _selectedCourier!,
      );
      if (mounted) {
        setState(() {
          _costs = costs;
        });
      }
    } catch (e) {
      if (mounted) _showErrorMessage('Error fetching costs: $e');
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
  void dispose() {
    _weightController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Ongkir'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Asal Provinsi',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)))),
                    value: _originProvince,
                    items: _provinces.isNotEmpty
                        ? _provinces.map((province) {
                            return DropdownMenuItem<String>(
                              value: province['province_id'],
                              child: Text(province['province']),
                            );
                          }).toList()
                        : null,
                    onChanged: _provinces.isNotEmpty
                        ? (value) {
                            setState(() {
                              _originProvince = value;
                              _fetchCities(value!, true);
                            });
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Asal Kota',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)))),
                    value: _originCity,
                    items: _originCities.isNotEmpty
                        ? _originCities.map((city) {
                            return DropdownMenuItem<String>(
                              value: city['city_id'],
                              child: Text(city['city_name']),
                            );
                          }).toList()
                        : null,
                    onChanged: _originCities.isNotEmpty
                        ? (value) {
                            setState(() {
                              _originCity = value;
                            });
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Tujuan Provinsi',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)))),
                    value: _destinationProvince,
                    items: _provinces.isNotEmpty
                        ? _provinces.map((province) {
                            return DropdownMenuItem<String>(
                              value: province['province_id'],
                              child: Text(province['province']),
                            );
                          }).toList()
                        : null,
                    onChanged: _provinces.isNotEmpty
                        ? (value) {
                            setState(() {
                              _destinationProvince = value;
                              _fetchCities(value!, false);
                            });
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Tujuan Kota',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)))),
                    value: _destinationCity,
                    items: _destinationCities.isNotEmpty
                        ? _destinationCities.map((city) {
                            return DropdownMenuItem<String>(
                              value: city['city_id'],
                              child: Text(city['city_name']),
                            );
                          }).toList()
                        : null,
                    onChanged: _destinationCities.isNotEmpty
                        ? (value) {
                            setState(() {
                              _destinationCity = value;
                            });
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Berat Barang (gram)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Pilih Kurir',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)))),
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
                    onPressed: _fetchCosts,
                    child: const Text('Cek Ongkir'),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _costs.length,
                      itemBuilder: (context, index) {
                        final cost = _costs[index];
                        return Card(
                          child: ListTile(
                            title: Text(cost['service']),
                            subtitle: Text(cost['description']),
                            trailing: Text(
                              'Rp${cost['cost'][0]['value']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
