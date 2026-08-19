import 'package:flutter/material.dart';

class StudentAttendanceModel {
  final String id;
  final String name;
  final String nim;
  String status; // 'Hadir', 'Alpa', 'Izin', 'Sakit'

  StudentAttendanceModel({
    required this.id,
    required this.name,
    required this.nim,
    this.status = 'Hadir',
  });
}

class ManageAttendanceScreen extends StatefulWidget {
  const ManageAttendanceScreen({super.key});

  @override
  State<ManageAttendanceScreen> createState() => _ManageAttendanceScreenState();
}

class _ManageAttendanceScreenState extends State<ManageAttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedCourse = 'Algoritma & Pemrograman II (A2)';

  final List<String> _courseList = [
    'Algoritma & Pemrograman II (A2)',
    'Pemrograman Perangkat Bergerak (B1)',
    'Basis Data Lanjut (A1)',
  ];

  final List<String> _attendanceOptions = ['Hadir', 'Alpa', 'Izin', 'Sakit'];

  // Dummy data daftar siswa
  final List<StudentAttendanceModel> _students = [
    StudentAttendanceModel(
      id: '1',
      name: 'Andi Pratama',
      nim: '220101089',
      status: 'Hadir',
    ),
    StudentAttendanceModel(
      id: '2',
      name: 'Bambang Sudarmono',
      nim: '220101090',
      status: 'Hadir',
    ),
    StudentAttendanceModel(
      id: '3',
      name: 'Citra Dewi',
      nim: '220101091',
      status: 'Izin',
    ),
    StudentAttendanceModel(
      id: '4',
      name: 'Dion Permana',
      nim: '220101092',
      status: 'Alpa',
    ),
    StudentAttendanceModel(
      id: '5',
      name: 'Eka Nurjanah',
      nim: '220101093',
      status: 'Hadir',
    ),
    StudentAttendanceModel(
      id: '6',
      name: 'Fikri Haikal',
      nim: '220101094',
      status: 'Sakit',
    ),
    StudentAttendanceModel(
      id: '7',
      name: 'Gita Gutawa',
      nim: '220101095',
      status: 'Hadir',
    ),
    StudentAttendanceModel(
      id: '8',
      name: 'Hadi Wijaya',
      nim: '220101096',
      status: 'Hadir',
    ),
  ];

  // Fungsi untuk memanggil DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Format tanggal ke teks Indonesia (misal: "19 Agustus 2026")
  String _formatDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Warna badge status berdasarkan pilihan
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hadir':
        return const Color(0xFF059669); // Hijau
      case 'Alpa':
        return const Color(0xFFDC2626); // Merah
      case 'Izin':
        return const Color(0xFFD97706); // Oranye
      case 'Sakit':
        return const Color(0xFF2563EB); // Biru
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Hadir':
        return const Color(0xFFD1FAE5);
      case 'Alpa':
        return const Color(0xFFFEE2E2);
      case 'Izin':
        return const Color(0xFFFEF3C7);
      case 'Sakit':
        return const Color(0xFFDBEAFE);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Absensi Siswa',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterHeader(),
            Expanded(child: _buildStudentList()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomSaveBar(),
    );
  }

  // --- Header Filter: Pemilihan Matkul & Tanggal ---
  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown Mata Pelajaran
          const Text(
            'Mata Pelajaran / Kelas',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCourse,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF4F46E5),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
                items: _courseList.map((String course) {
                  return DropdownMenuItem<String>(
                    value: course,
                    child: Text(course),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCourse = newValue;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Pemilih Tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tanggal Pertemuan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(_selectedDate),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 18,
                        color: Color(0xFF4F46E5),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Ubah Tanggal',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Daftar Siswa & Dropdown Absensi ---
  Widget _buildStudentList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Info Siswa (Avatar, Nama, NIM)
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFEEF2FF),
                      child: Text(
                        student.name[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NIM: ${student.nim}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Dropdown Status Absensi di Samping Nama
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getStatusBgColor(student.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: student.status,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _getStatusColor(student.status),
                      size: 18,
                    ),
                    dropdownColor: Colors.white,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(student.status),
                    ),
                    items: _attendanceOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: TextStyle(
                            color: _getStatusColor(option),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newStatus) {
                      if (newStatus != null) {
                        setState(() {
                          student.status = newStatus;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Bottom Save Button Bar ---
  Widget _buildBottomSaveBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            // Tampilkan snackbar pemberitahuan simpan
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Absensi kelas $_selectedCourse berhasil disimpan!',
                ),
                backgroundColor: const Color(0xFF059669),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.save_rounded, size: 20),
          label: const Text(
            'Simpan Data Absensi',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
