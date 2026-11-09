import 'package:flutter/material.dart';

// ================= WARNA TEMA (BIRU) =================

const Color kPrimary = Color(0xFF1565C0); // biru utama
const Color kSecondary = Color(0xFF0288D1); // biru muda (barang hilang)
const Color kSoft = Color(0xFFE3F2FD); // biru sangat muda
const Color kBackground = Color(0xFFF3F7FC); // latar belakang

void main() {
  runApp(const LostifyApp());
}

// ================= MODEL BARANG =================

class LostItem {
  final String title;
  final String description;
  final String location;
  final String waktu;
  final String category;
  final String type;
  final DateTime date;
  final bool hasPhoto; // Menggantikan file_picker dengan status foto

  LostItem({
    required this.title,
    required this.description,
    required this.location,
    required this.waktu,
    required this.category,
    required this.type,
    required this.date,
    this.hasPhoto = false,
  });
}

// ================= APLIKASI UTAMA =================

class LostifyApp extends StatelessWidget {
  const LostifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LOSTIFY ITPLN',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimary,
        ),
        scaffoldBackgroundColor: kBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const MainPage(),
    );
  }
}

// ================= HALAMAN UTAMA =================

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  // Data contoh laporan terbaru (terbaru di paling atas)
  final List<LostItem> items = [
    LostItem(
      title: 'Dompet Kulit Hitam',
      description:
          'Dompet kulit warna hitam berisi KTP, KTM ITPLN, dan beberapa kartu ATM. Hilang setelah kelas siang.',
      location: 'Gedung A lantai 2',
      waktu: '13:00 WIB',
      category: 'Dokumen',
      type: 'Hilang',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      hasPhoto: true,
    ),
    LostItem(
      title: 'Kunci Motor Honda',
      description:
          'Ditemukan kunci motor Honda dengan gantungan kunci berbentuk bola. Saat ini dititipkan di pos satpam.',
      location: 'Parkiran Motor Gedung B',
      waktu: '10:30 WIB',
      category: 'Aksesori',
      type: 'Ditemukan',
      date: DateTime.now().subtract(const Duration(hours: 6)),
      hasPhoto: true,
    ),
    LostItem(
      title: 'Charger Laptop ASUS',
      description:
          'Charger laptop ASUS 65W warna hitam, kabel sedikit terlilit selotip putih.',
      location: 'Perpustakaan ITPLN',
      waktu: '15:00 WIB (Kemarin)',
      category: 'Elektronik',
      type: 'Hilang',
      date: DateTime.now().subtract(const Duration(days: 1)),
      hasPhoto: false,
    ),
    LostItem(
      title: 'Jaket Almamater',
      description:
          'Ditemukan jaket almamater ukuran L tertinggal di kursi. Ada nama tertulis di bagian dalam kerah.',
      location: 'Kantin Utama',
      waktu: '12:15 WIB (Kemarin)',
      category: 'Pakaian',
      type: 'Ditemukan',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      hasPhoto: true,
    ),
  ];

  Future<void> openReport(String type) async {
    final result = await Navigator.push<LostItem>(
      context,
      MaterialPageRoute(
        builder: (context) => ReportPage(type: type),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        items.insert(0, result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan berhasil ditambahkan!'),
        ),
      );
    }
  }

  void openDetail(LostItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(item: item),
      ),
    );
  }

  void goToTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Pilihan jenis laporan saat tombol + di tengah ditekan
  void showReportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buat Laporan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: kSoft,
                    child: Icon(Icons.search, color: kSecondary),
                  ),
                  title: const Text('Barang Hilang'),
                  subtitle: const Text('Saya kehilangan sebuah barang'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    openReport('Hilang');
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: kSoft,
                    child: Icon(Icons.inventory_2_outlined, color: kPrimary),
                  ),
                  title: const Text('Barang Ditemukan'),
                  subtitle: const Text('Saya menemukan barang milik orang lain'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    openReport('Ditemukan');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        items: items,
        onGoToTab: goToTab,
        onDetail: openDetail,
      ),
      ItemListPage(
        title: 'Barang Hilang',
        type: 'Hilang',
        items: items,
        onDetail: openDetail,
      ),
      ItemListPage(
        title: 'Barang Ditemukan',
        type: 'Ditemukan',
        items: items,
        onDetail: openDetail,
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: showReportOptions,
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 64,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Expanded(
              child: NavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Beranda',
                selected: selectedIndex == 0,
                onTap: () => goToTab(0),
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.search,
                selectedIcon: Icons.search,
                label: 'Hilang',
                selected: selectedIndex == 1,
                onTap: () => goToTab(1),
              ),
            ),
            const SizedBox(width: 72),
            Expanded(
              child: NavItem(
                icon: Icons.inventory_2_outlined,
                selectedIcon: Icons.inventory_2,
                label: 'Ditemukan',
                selected: selectedIndex == 2,
                onTap: () => goToTab(2),
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profil',
                selected: selectedIndex == 3,
                onTap: () => goToTab(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ITEM NAVIGASI BAWAH =================

class NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? kPrimary : Colors.black54;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(selected ? selectedIcon : icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= BERANDA =================

class HomePage extends StatelessWidget {
  final List<LostItem> items;
  final Function(int) onGoToTab;
  final Function(LostItem) onDetail;

  const HomePage({
    super.key,
    required this.items,
    required this.onGoToTab,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final lostCount = items.where((item) => item.type == 'Hilang').length;
    final foundCount = items.where((item) => item.type == 'Ditemukan').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOSTIFY ITPLN',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Halo, Mahasiswa ITPLN!',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Temukan kembali barangmu bersama LOSTIFY.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kPrimary, kSecondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 35,
                ),
                SizedBox(height: 12),
                Text(
                  'Laporkan Barang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Tekan tombol + di bawah untuk membuat laporan.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Dashboard Laporan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.search,
                  label: 'Barang Hilang',
                  count: lostCount,
                  color: kSecondary,
                  onTap: () => onGoToTab(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  icon: Icons.inventory_2_outlined,
                  label: 'Barang Ditemukan',
                  count: foundCount,
                  color: kPrimary,
                  onTap: () => onGoToTab(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Laporan Terbaru',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const EmptyState(
              message: 'Belum ada laporan barang.',
            )
          else
            ...items.take(5).map(
                  (item) => ItemCard(
                    item: item,
                    onTap: () => onDetail(item),
                  ),
                ),
        ],
      ),
    );
  }
}

// ================= KARTU DASHBOARD =================

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: kSoft,
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Lihat daftar',
                  style: TextStyle(fontSize: 12, color: color),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 11, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DAFTAR BARANG =================

class ItemListPage extends StatefulWidget {
  final String title;
  final String type;
  final List<LostItem> items;
  final Function(LostItem) onDetail;

  const ItemListPage({
    super.key,
    required this.title,
    required this.type,
    required this.items,
    required this.onDetail,
  });

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      final matchesType = item.type == widget.type;
      final matchesSearch =
          item.title.toLowerCase().contains(searchText.toLowerCase()) ||
              item.location.toLowerCase().contains(searchText.toLowerCase());

      return matchesType && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama barang atau lokasi...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty
                ? const EmptyState(
                    message: 'Belum ada barang yang dilaporkan.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];

                      return ItemCard(
                        item: item,
                        onTap: () => widget.onDetail(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ================= KARTU BARANG =================

class ItemCard extends StatelessWidget {
  final LostItem item;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLost = item.type == 'Hilang';

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 65,
            height: 65,
            color: kSoft,
            child: Icon(
              item.hasPhoto ? Icons.image : (isLost ? Icons.search : Icons.inventory_2_outlined),
              color: kPrimary,
            ),
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${item.category} • ${item.location}\n${item.type}',
          ),
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// ================= FORM LAPORAN =================

class ReportPage extends StatefulWidget {
  final String type;

  const ReportPage({
    super.key,
    required this.type,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final waktuController = TextEditingController();

  String selectedCategory = 'Elektronik';
  bool isPhotoUploaded = false;
  bool isSubmitting = false;

  final List<String> categories = [
    'Elektronik',
    'Dokumen',
    'Aksesori',
    'Pakaian',
    'Lainnya',
  ];

  void togglePhoto() {
    setState(() {
      isPhotoUploaded = !isPhotoUploaded;
    });
  }

  void submitReport() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final newItem = LostItem(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      location: locationController.text.trim(),
      waktu: waktuController.text.trim(),
      category: selectedCategory,
      type: widget.type,
      date: DateTime.now(),
      hasPhoto: isPhotoUploaded,
    );

    Navigator.pop(context, newItem);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    waktuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Barang ${widget.type}'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Lengkapi Informasi Barang',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Foto Barang (Simulasi)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: togglePhoto,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isPhotoUploaded ? kSoft : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isPhotoUploaded ? kPrimary : Colors.black26,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isPhotoUploaded ? Icons.check_circle : Icons.add_a_photo_outlined,
                      size: 40,
                      color: kPrimary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isPhotoUploaded ? 'Foto Berhasil Disimulasikan' : 'Ketuk untuk Pilih Foto',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPhotoUploaded ? kPrimary : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Nama Barang',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Dompet hitam',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama barang wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Kategori Barang',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Lokasi',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Gedung A lantai 2',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lokasi wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Waktu Kejadian',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: waktuController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Pagi hari (09:00 WIB)',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Waktu wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Jelaskan ciri-ciri barang...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Deskripsi wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Kirim Laporan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DETAIL BARANG =================

class DetailPage extends StatelessWidget {
  final LostItem item;

  const DetailPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: kSoft,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              item.hasPhoto ? Icons.image : Icons.inventory_2_outlined,
              size: 65,
              color: kPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text('Barang ${item.type}'),
              backgroundColor: kSoft,
            ),
          ),
          const Divider(height: 30),
          const Text(
            'Kategori',
            style: TextStyle(color: Colors.black54),
          ),
          Text(
            item.category,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 18),
          const Text(
            'Lokasi',
            style: TextStyle(color: Colors.black54),
          ),
          Text(
            item.location,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 18),
          const Text(
            'Waktu Kejadian',
            style: TextStyle(color: Colors.black54),
          ),
          Text(
            item.waktu,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 18),
          const Text(
            'Deskripsi',
            style: TextStyle(color: Colors.black54),
          ),
          Text(
            item.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 18),
          const Text(
            'Tanggal Laporan',
            style: TextStyle(color: Colors.black54),
          ),
          Text(
            '${item.date.day}/${item.date.month}/${item.date.year}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// ================= PROFIL =================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: kSoft,
                child: Icon(
                  Icons.person,
                  size: 55,
                  color: kPrimary,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Mahasiswa ITPLN',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Pengguna LOSTIFY ITPLN',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 25),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Tentang LOSTIFY'),
                subtitle: Text(
                  'Aplikasi pelaporan barang hilang dan ditemukan di lingkungan ITPLN.',
                ),
              ),
              const ListTile(
                leading: Icon(Icons.school_outlined),
                title: Text('ITPLN'),
                subtitle: Text('Institut Teknologi PLN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= TAMPILAN KOSONG =================

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 45),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 55,
            color: Colors.black26,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}