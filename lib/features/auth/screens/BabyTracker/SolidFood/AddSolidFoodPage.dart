// add_solid_food_page.dart
// A standalone Flutter page that mimics an "Add Solid Food" screen (inspired by Huckleberry).
// Usage: place this file into your lib/ folder and push AddSolidFoodPage() onto navigator.
// Optional dependencies (add to pubspec.yaml):
//   image_picker: ^0.8.7+4
//   intl: ^0.17.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class SolidFoodEntry {
  final String name;
  final double amount;
  final String unit;
  final DateTime time;
  final String notes;
  final File? photo;

  SolidFoodEntry({
    required this.name,
    required this.amount,
    required this.unit,
    required this.time,
    required this.notes,
    this.photo,
  });
}

class AddSolidFoodPage extends StatefulWidget {
  const AddSolidFoodPage({Key? key}) : super(key: key);

  @override
  State<AddSolidFoodPage> createState() => _AddSolidFoodPageState();
}

class _AddSolidFoodPageState extends State<AddSolidFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _pickedDateTime = DateTime.now();
  String _selectedUnit = 'g';
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // common foods chips (like quick presets)
  final List<String> _foodPresets = [
    'Banana',
    'Avocado',
    'Rice cereal',
    'Sweet potato',
    'Apple sauce',
  ];

  void _applyPreset(String preset) {
    setState(() {
      _nameController.text = preset;
    });
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _pickedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime:
      TimeOfDay.fromDateTime(_pickedDateTime),
    );
    if (time == null) return;

    setState(() {
      _pickedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
      if (file != null) {
        setState(() {
          _pickedImage = File(file.path);
        });
      }
    } catch (e) {
      // ignore errors for the example
    }
  }

  void _saveEntry() {
    if (!_formKey.currentState!.validate()) return;

    final entry = SolidFoodEntry(
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      unit: _selectedUnit,
      time: _pickedDateTime,
      notes: _notesController.text.trim(),
      photo: _pickedImage,
    );

    // For demo: pop with result. In a real app you'd persist to DB or send to backend.
    Navigator.of(context).pop(entry);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Solid Food'),
        actions: [
          TextButton(
            onPressed: _saveEntry,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preset chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _foodPresets.map((p) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(p),
                      onPressed: () => _applyPreset(p),
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Food name
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Food',
                          hintText: 'e.g. Bananas, Rice cereal',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a food name' : null,
                      ),
                      const SizedBox(height: 12),

                      // Amount + unit
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _amountController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Amount',
                                border: OutlineInputBorder(),
                                hintText: 'e.g. 20',
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Enter amount';
                                final parsed = double.tryParse(v.trim());
                                if (parsed == null || parsed <= 0) return 'Enter a valid number';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: _selectedUnit,
                              decoration: const InputDecoration(
                                labelText: 'Unit',
                                border: OutlineInputBorder(),
                              ),
                              items: ['g', 'ml', 'tbsp', 'tsp', 'pieces']
                                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedUnit = v ?? 'g'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Date & time
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Time'),
                        subtitle: Text(DateFormat.yMMMd().add_jm().format(_pickedDateTime)),
                        trailing: TextButton(
                          onPressed: _pickDateTime,
                          child: const Text('Change'),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Photo picker
                      Row(
                        children: [
                          _pickedImage == null
                              ? Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: _pickImage,
                            ),
                          )
                              : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(_pickedImage!, width: 80, height: 80, fit: BoxFit.cover),
                              ),
                              Positioned(
                                right: -6,
                                top: -6,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () => setState(() => _pickedImage = null),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Notes (optional)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Save button
                      ElevatedButton.icon(
                        onPressed: _saveEntry,
                        icon: const Icon(Icons.check),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          child: Text('Save solid food'),
                        ),
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),

                      const SizedBox(height: 12),

                      // Small help text
                      Text(
                        'Tip: use presets for faster entry or add a photo of the meal.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
