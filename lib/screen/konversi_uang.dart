import 'package:flutter/material.dart';

class KonversiUangScreen extends StatefulWidget {
  @override
  _KonversiUangScreenState createState() => _KonversiUangScreenState();
}

class _KonversiUangScreenState extends State<KonversiUangScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _sourceCurrency = 'USD';
  String _targetCurrency = 'IDR';

  // Nilai tukar mata uang tetap yang didefinisikan manual
  final Map<String, double> _conversionRates = {
    'USD': 1.0, // USD sebagai referensi utama
    'IDR': 15000.0, // Contoh nilai tukar USD ke IDR
    'EUR': 0.85, // Contoh nilai tukar USD ke EUR
    'JPY': 130.0, // Contoh nilai tukar USD ke JPY
  };

  double _convertedAmount = 0;

  void _convertCurrency() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double sourceRate = _conversionRates[_sourceCurrency] ?? 1.0;
    double targetRate = _conversionRates[_targetCurrency] ?? 1.0;

    setState(() {
      _convertedAmount = amount * (targetRate / sourceRate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Konversi Uang', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF388E3C)], // Tema hijau
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input jumlah dan dropdown dalam satu baris
            Row(
              children: [
                // Input jumlah
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Jumlah',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Dropdown mata uang asal
                Expanded(
                  flex: 2,
                  child: _buildCurrencyDropdown(
                    'Asal',
                    _sourceCurrency,
                    (value) => setState(() => _sourceCurrency = value),
                  ),
                ),
                const SizedBox(width: 10),
                // Dropdown mata uang tujuan
                Expanded(
                  flex: 2,
                  child: _buildCurrencyDropdown(
                    'Tujuan',
                    _targetCurrency,
                    (value) => setState(() => _targetCurrency = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Tombol konversi
            Center(
              child: ElevatedButton(
                onPressed: _convertCurrency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Konversi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Hasil konversi
            Center(
              child: Text(
                'Hasil: ${_convertedAmount.toStringAsFixed(2)} $_targetCurrency',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown(
    String label,
    String value,
    Function(String) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: (val) => onChanged(val!),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      items: _conversionRates.keys.map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
    );
  }
}
