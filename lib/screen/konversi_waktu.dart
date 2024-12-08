import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format waktu

class TimezoneScreen extends StatefulWidget {
  @override
  _TimezoneScreenState createState() => _TimezoneScreenState();
}

class _TimezoneScreenState extends State<TimezoneScreen> {
  // Zona waktu dan offset dalam jam tanpa Tokyo
  final Map<String, int> _zoneOffsets = {
    'WIB (Asia/Jakarta)': 7, // UTC +7
    'WITA (Asia/Makassar)': 8, // UTC +8
    'WIT (Asia/Jayapura)': 9, // UTC +9
    'London': 0, // UTC
    'Amsterdam': 1, // UTC +1
  };

  final TextEditingController _inputTimeController = TextEditingController();
  String _sourceZone = 'WIB (Asia/Jakarta)'; // Zona waktu asal
  String _targetZone = 'Amsterdam'; // Zona waktu tujuan
  String? _convertedTime;

  // Fungsi untuk mengonversi waktu berdasarkan zona waktu asal dan tujuan
  String _convertTimeManually(
      String sourceZone, String targetZone, String time) {
    // Mendapatkan offset zona waktu asal dan tujuan
    int sourceOffset = _zoneOffsets[sourceZone] ?? 0;
    int targetOffset = _zoneOffsets[targetZone] ?? 0;

    // Menghitung selisih antara zona waktu asal dan tujuan
    int offsetDifference = targetOffset - sourceOffset;

    // Parse waktu input
    final timeParts = time.split(':').map(int.parse).toList();
    final inputTime = DateTime(0, 1, 1, timeParts[0], timeParts[1]);

    // Menambahkan selisih waktu ke waktu input
    final convertedTime = inputTime.add(Duration(hours: offsetDifference));

    // Format hasil konversi
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(convertedTime);

    return formattedTime;
  }

  Future<void> _convertTime() async {
    String time = _inputTimeController.text.trim();

    // Validasi dan konversi input
    if (time.isEmpty) {
      _showErrorDialog('Harap masukkan waktu.');
      return;
    }

    // Deteksi format input
    if (RegExp(r'^\d{4}$').hasMatch(time)) {
      // Format angka saja (misalnya 1209)
      time = '${time.substring(0, 2)}:${time.substring(2, 4)}';
    } else if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(time)) {
      _showErrorDialog(
          'Format waktu salah. Gunakan HH:MM atau angka 4 digit (misalnya, 1209).');
      return;
    }

    // Lakukan konversi waktu
    final convertedTime = _convertTimeManually(_sourceZone, _targetZone, time);

    setState(() {
      _convertedTime = convertedTime; // Menyimpan hasil konversi
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Waktu'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF388E3C)], // Gradien hijau
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Dropdown untuk memilih zona waktu asal
            DropdownButtonFormField<String>(
              value: _sourceZone,
              decoration: InputDecoration(
                labelText: 'Zona Waktu Asal',
                labelStyle:
                    TextStyle(color: Color(0xFF4CAF50)), // Warna label hijau
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xFF4CAF50),
                      width: 2.0), // Fokus border hijau
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _sourceZone = value!;
                });
              },
              items: _zoneOffsets.keys
                  .map((zone) => DropdownMenuItem(
                        value: zone,
                        child: Text(zone),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Dropdown untuk memilih zona waktu tujuan
            DropdownButtonFormField<String>(
              value: _targetZone,
              decoration: InputDecoration(
                labelText: 'Zona Waktu Tujuan',
                labelStyle:
                    TextStyle(color: Color(0xFF4CAF50)), // Warna label hijau
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xFF4CAF50),
                      width: 2.0), // Fokus border hijau
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _targetZone = value!;
                });
              },
              items: _zoneOffsets.keys
                  .map((zone) => DropdownMenuItem(
                        value: zone,
                        child: Text(zone),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Input waktu
            TextField(
              controller: _inputTimeController,
              decoration: InputDecoration(
                labelText: 'Masukkan Waktu (HH:MM atau 4 digit, misal 1209)',
                labelStyle:
                    TextStyle(color: Color(0xFF4CAF50)), // Warna label hijau
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xFF4CAF50),
                      width: 2.0), // Fokus border hijau
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol untuk mengonversi waktu
            ElevatedButton(
              onPressed: _convertTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50), // Warna tombol hijau
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text('Konversi Waktu'),
            ),
            const SizedBox(height: 20),

            // Menampilkan hasil konversi
            _convertedTime != null
                ? Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: const Text('Waktu Konversi'),
                      subtitle: Text(_convertedTime!),
                    ),
                  )
                : const Text(
                    'Tekan tombol untuk memulai konversi waktu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputTimeController.dispose();
    super.dispose();
  }
}
