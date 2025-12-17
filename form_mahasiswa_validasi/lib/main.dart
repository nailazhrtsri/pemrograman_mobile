import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Mahasiswa Cantik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          primary: const Color(0xFFEC407A), // Pink cerah
          secondary: const Color(0xFFF48FB1), // Pink lembut
        ),
        scaffoldBackgroundColor: const Color(0xFFFCE4EC),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFEC407A), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
      home: const FormMahasiswaScreen(),
    );
  }
}

class FormMahasiswaScreen extends StatefulWidget {
  const FormMahasiswaScreen({super.key});

  @override
  State<FormMahasiswaScreen> createState() => _FormMahasiswaScreenState();
}

class _FormMahasiswaScreenState extends State<FormMahasiswaScreen> {
  int _currentStep = 0;

  // PERBAIKAN: Kita buat List Key terpisah untuk setiap Step
  final List<GlobalKey<FormState>> _stepKeys = [
    GlobalKey<FormState>(), // Key untuk Step 1 (Data Diri)
    GlobalKey<FormState>(), // Key untuk Step 2 (Akademik)
  ];

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // State Variables
  String? _selectedJurusan;
  double _semester = 1.0;
  bool _isAgreed = false;

  final List<String> _jurusanList = [
    'Sistem Informasi',
    'Teknik Informatika',
    'Manajemen',
    'Akuntansi',
    'Ilmu Komunikasi'
  ];

  final Map<String, bool> _hobbies = {
    'Membaca': false,
    'Coding': false,
    'Traveling': false,
    'Memasak': false,
    'Olahraga': false,
  };

  // --- Logic Navigasi & Validasi Per Step ---

  void _onStepContinue() {
    // 1. Logika untuk STEP 1 (Data Diri)
    if (_currentStep == 0) {
      // Cek validasi HANYA form step 1
      if (_stepKeys[0].currentState!.validate()) {
        setState(() => _currentStep += 1);
      }
    } 
    // 2. Logika untuk STEP 2 (Akademik)
    else if (_currentStep == 1) {
      // Cek validasi form step 2 + Validasi Hobi Manual
      if (_stepKeys[1].currentState!.validate()) {
        if (!_hobbies.containsValue(true)) {
          _showErrorSnackbar('Pilih minimal satu hobi ya, Kak! 🌸');
          return;
        }
        setState(() => _currentStep += 1);
      }
    } 
    // 3. Logika untuk STEP 3 (Konfirmasi)
    else if (_currentStep == 2) {
      if (!_isAgreed) {
        _showErrorSnackbar('Jangan lupa setujui syarat & ketentuan dulu ya! ✨');
        return;
      }
      _submitForm();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  void _submitForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeay! Berhasil ✨', style: TextStyle(color: Colors.pink)),
        content: const Text('Data mahasiswa berhasil disimpan.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Mahasiswa 🎀', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF48FB1),
        centerTitle: true,
      ),
      // PERBAIKAN: Form wrapper utamanya dihapus, dipindah ke dalam Step
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEC407A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(_currentStep == 2 ? 'Kirim Data' : 'Lanjut'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFEC407A)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Kembali', style: TextStyle(color: Color(0xFFEC407A))),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // --- STEP 1: Data Diri ---
          Step(
            title: const Text('Data Diri'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.editing,
            content: Form(
              key: _stepKeys[0], // PERBAIKAN: Pakai Key khusus Step 1
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person_outline, color: Colors.pink),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Nama wajib diisi ya' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.pink),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email wajib diisi';
                      if (!value.contains('@')) return 'Format email salah nih';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Nomor HP',
                      prefixIcon: Icon(Icons.phone_android, color: Colors.pink),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Nomor HP wajib diisi';
                      if (RegExp(r'^[0-9]+$').hasMatch(value) == false) return 'Hanya angka ya';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          // --- STEP 2: Akademik & Minat ---
          Step(
            title: const Text('Akademik & Minat'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.editing,
            content: Form(
              key: _stepKeys[1], // PERBAIKAN: Pakai Key khusus Step 2
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Jurusan',
                      prefixIcon: Icon(Icons.school_outlined, color: Colors.pink),
                    ),
                    value: _selectedJurusan,
                    items: _jurusanList.map((jurusan) {
                      return DropdownMenuItem(value: jurusan, child: Text(jurusan));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedJurusan = val),
                    validator: (value) => value == null ? 'Pilih jurusan dulu yuk' : null,
                  ),
                  const SizedBox(height: 20),
                  Text('Semester: ${_semester.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                  Slider(
                    value: _semester,
                    min: 1,
                    max: 8,
                    divisions: 7,
                    label: _semester.toInt().toString(),
                    activeColor: const Color(0xFFEC407A),
                    onChanged: (val) => setState(() => _semester = val),
                  ),
                  const SizedBox(height: 10),
                  const Text('Hobi (Pilih minimal 1):', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                  ..._hobbies.keys.map((String key) {
                    return CheckboxListTile(
                      title: Text(key),
                      value: _hobbies[key],
                      activeColor: const Color(0xFFEC407A),
                      onChanged: (bool? value) {
                        setState(() {
                          _hobbies[key] = value!;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          // --- STEP 3: Konfirmasi ---
          Step(
            title: const Text('Konfirmasi'),
            isActive: _currentStep >= 2,
            content: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${_nameController.text}'),
                      Text('Email: ${_emailController.text}'),
                      Text('HP: ${_phoneController.text}'), // Added HP
                      Text('Jurusan: $_selectedJurusan'),
                      Text('Semester: ${_semester.toInt()}'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Saya menyetujui syarat & ketentuan yang berlaku'),
                  value: _isAgreed,
                  activeColor: const Color(0xFFEC407A),
                  onChanged: (val) => setState(() => _isAgreed = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}