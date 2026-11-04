import 'package:flutter/material.dart';

void main() {
  runApp(const GameZoneApp());
}

// Global Store untuk menyimpan riwayat transaksi
class TransactionStore {
  static final List<Map<String, dynamic>> history = [
    {
      'orderId': 'GZ-DEMO001',
      'game': 'Mobile Legends',
      'item': '86 Diamonds',
      'userId': '12345678',
      'zoneId': '2024',
      'payment': 'QRIS / All E-Wallet',
      'total': 21000,
      'time': '24/08/2026 10:15',
      'status': 'BERHASIL',
    },
    {
      'orderId': 'GZ-DEMO002',
      'game': 'Free Fire',
      'item': '140 Diamonds',
      'userId': '987654321',
      'zoneId': '-',
      'payment': 'GoPay / OVO / DANA',
      'total': 20000,
      'time': '25/08/2026 14:30',
      'status': 'BERHASIL',
    },
  ];
}

class GameZoneApp extends StatelessWidget {
  const GameZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameZone Topup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Indigo Modern
          primary: const Color(0xFF4F46E5),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          iconTheme: IconThemeData(color: Color(0xFF0F172A)),
          titleTextStyle: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ==========================================
// DATA MODELS
// ==========================================
class GameItem {
  final String id;
  final String title;
  final String publisher;
  final IconData icon;
  final Color themeColor;
  final String badgeText;

  GameItem({
    required this.id,
    required this.title,
    required this.publisher,
    required this.icon,
    required this.themeColor,
    this.badgeText = '',
  });
}

class TopupNominal {
  final String id;
  final String name;
  final int price;
  final String bonus;
  final bool isPopular;

  TopupNominal({
    required this.id,
    required this.name,
    required this.price,
    this.bonus = '',
    this.isPopular = false,
  });
}

// Data Dummy Game Top Up Saja
final List<GameItem> gameList = [
  GameItem(
    id: 'mlbb',
    title: 'Mobile Legends',
    publisher: 'Moonton',
    icon: Icons.sports_esports,
    themeColor: const Color(0xFF4F46E5),
    badgeText: 'HOT',
  ),
  GameItem(
    id: 'ff',
    title: 'Free Fire',
    publisher: 'Garena',
    icon: Icons.local_fire_department,
    themeColor: const Color(0xFFEA580C),
    badgeText: 'HOT',
  ),
  GameItem(
    id: 'pubg',
    title: 'PUBG Mobile',
    publisher: 'Tencent',
    icon: Icons.ads_click,
    themeColor: const Color(0xFFD97706),
  ),
  GameItem(
    id: 'gi',
    title: 'Genshin Impact',
    publisher: 'HoYoverse',
    icon: Icons.auto_awesome,
    themeColor: const Color(0xFF7C3AED),
  ),
  GameItem(
    id: 'val',
    title: 'Valorant',
    publisher: 'Riot Games',
    icon: Icons.gps_fixed,
    themeColor: const Color(0xFFE11D48),
  ),
  GameItem(
    id: 'hsr',
    title: 'Honkai: Star Rail',
    publisher: 'HoYoverse',
    icon: Icons.stars,
    themeColor: const Color(0xFF0284C7),
  ),
  GameItem(
    id: 'ro',
    title: 'Ragnarok Origin',
    publisher: 'Gravity',
    icon: Icons.shield,
    themeColor: const Color(0xFF059669),
  ),
  GameItem(
    id: 'ea',
    title: 'FC Mobile',
    publisher: 'EA Sports',
    icon: Icons.sports_soccer,
    themeColor: const Color(0xFF16A34A),
  ),
];

// Data Nominal Item Topup
final List<TopupNominal> nominalList = [
  TopupNominal(id: '1', name: '56 Diamonds', price: 15000, bonus: '+2 Bonus'),
  TopupNominal(id: '2', name: '86 Diamonds', price: 20000, bonus: '+5 Bonus', isPopular: true),
  TopupNominal(id: '3', name: '172 Diamonds', price: 40000, bonus: '+10 Bonus'),
  TopupNominal(id: '4', name: '257 Diamonds', price: 60000, bonus: '+15 Bonus', isPopular: true),
  TopupNominal(id: '5', name: '344 Diamonds', price: 80000, bonus: '+20 Bonus'),
  TopupNominal(id: '6', name: '706 Diamonds', price: 160000, bonus: '+50 Bonus'),
  TopupNominal(id: '7', name: '2195 Diamonds', price: 500000, bonus: '+150 Bonus'),
  TopupNominal(id: '8', name: 'Weekly Pass', price: 28000, bonus: 'Hemat 400%', isPopular: true),
];

// Helper Format Rupiah
String formatRupiah(int number) {
  return 'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
}

// ==========================================
// SCREEN 1: HOME (HANYA TOP UP & CEK RIWAYAT)
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredGames = gameList
        .where((game) =>
        game.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              'GAMEZONE',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            const Text(
              '.topup',
              style: TextStyle(
                color: Color(0xFF4F46E5),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckTransactionScreen()),
              );
            },
            icon: const Icon(Icons.history_rounded, size: 16, color: Color(0xFF4F46E5)),
            label: const Text(
              'Cek Riwayat',
              style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Modern Gradient
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '⚡ FLASH SALE TOP UP',
                          style: TextStyle(
                            color: Color(0xFFE0E7FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Proses Instan & Otomatis 24/7',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_fire_department, color: Colors.amber, size: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar Modern
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari game favoritmu...',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 18),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Label Section
            Row(
              children: const [
                Icon(Icons.sports_esports_rounded, color: Color(0xFF4F46E5), size: 16),
                SizedBox(width: 6),
                Text(
                  'PILIHAN GAME TOP UP',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Grid Kotak Game Kecil & Kompak (4 Kolom)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 Kolom agar kotak kecil & rapi
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: filteredGames.length,
              itemBuilder: (context, index) {
                final game = filteredGames[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopupDetailScreen(game: game),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: game.themeColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                game.icon,
                                color: game.themeColor,
                                size: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                game.title,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              game.publisher,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 8,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        if (game.badgeText.isNotEmpty)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                game.badgeText,
                                style: const TextStyle(
                                  fontSize: 6,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 2: DETAIL TOP UP & CHECKOUT
// ==========================================
class TopupDetailScreen extends StatefulWidget {
  final GameItem game;

  const TopupDetailScreen({super.key, required this.game});

  @override
  State<TopupDetailScreen> createState() => _TopupDetailScreenState();
}

class _TopupDetailScreenState extends State<TopupDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _zoneIdController = TextEditingController();
  TopupNominal? selectedNominal;
  String selectedPayment = 'QRIS / All E-Wallet';
  String statusMessage = 'Isi User ID, Zone ID, dan pilih nominal top up.';

  final List<String> paymentList = [
    'QRIS / All E-Wallet',
    'GoPay / OVO / DANA',
    'Virtual Account BCA',
    'Alfamart / Indomaret',
  ];

  @override
  void dispose() {
    _userIdController.dispose();
    _zoneIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Up ${widget.game.title}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Game Modern Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.game.themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.game.icon,
                        color: widget.game.themeColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.game.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.game.publisher} • Proses Cepat ⚡',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Step 1: Input Data Akun
            const Text(
              '1. Masukkan Data Akun',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _userIdController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'User ID',
                        hintText: 'Cth: 12345678',
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        final input = value?.trim() ?? '';
                        if (input.isEmpty) return 'User ID wajib diisi.';
                        if (!RegExp(r'^[0-9]{5,20}$').hasMatch(input)) {
                          return 'User ID harus 5–20 angka.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _zoneIdController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Zone ID',
                        hintText: '2024',
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        final input = value?.trim() ?? '';
                        if (input.isEmpty) return 'Zone ID wajib diisi.';
                        if (!RegExp(r'^[0-9]{1,10}$').hasMatch(input)) {
                          return 'Zone ID harus berupa angka.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Step 2: Pilih Nominal Top Up (Kotak Kecil & Rapih)
            const Text(
              '2. Pilih Nominal Top Up',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: nominalList.length,
              itemBuilder: (context, index) {
                final item = nominalList[index];
                final isSelected = selectedNominal?.id == item.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedNominal = item;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4F46E5).withOpacity(0.04)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFFE2E8F0),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: isSelected
                                    ? const Color(0xFF4F46E5)
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            if (item.isPopular)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: const Text(
                                  'HOT',
                                  style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatRupiah(item.price),
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            if (item.bonus.isNotEmpty)
                              Text(
                                item.bonus,
                                style: const TextStyle(
                                  color: Color(0xFF059669),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Step 3: Pilih Pembayaran
            const Text(
              '3. Metode Pembayaran',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Column(
              children: paymentList.map((payment) {
                final isSelected = selectedPayment == payment;
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: RadioListTile<String>(
                    dense: true,
                    title: Text(
                      payment,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    value: payment,
                    groupValue: selectedPayment,
                    activeColor: const Color(0xFF4F46E5),
                    onChanged: (val) {
                      setState(() {
                        selectedPayment = val!;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF4F46E5), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      statusMessage,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF3730A3)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
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
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Pembayaran', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                    Text(
                      selectedNominal != null
                          ? formatRupiah(selectedNominal!.price + 1000)
                          : 'Rp 0',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  if (!_formKey.currentState!.validate()) {
                    setState(() {
                      statusMessage = 'Data akun belum valid. Periksa kembali pesan error.';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Form belum valid. Periksa User ID dan Zone ID.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (selectedNominal == null) {
                    setState(() {
                      statusMessage = 'Silakan pilih nominal top up terlebih dahulu.';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nominal top up wajib dipilih.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  setState(() {
                    statusMessage = 'Data valid. Menyiapkan transaksi...';
                  });

                  final orderId = "GZ-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";
                  final totalPrice = selectedNominal!.price + 1000;
                  final timeNow = '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Validasi berhasil. Transaksi diproses (simulasi).'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  TransactionStore.history.insert(0, {
                    'orderId': orderId,
                    'game': widget.game.title,
                    'item': selectedNominal!.name,
                    'userId': _userIdController.text,
                    'zoneId': _zoneIdController.text,
                    'payment': selectedPayment,
                    'total': totalPrice,
                    'time': timeNow,
                    'status': 'BERHASIL',
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceiptScreen(
                        gameTitle: widget.game.title,
                        itemName: selectedNominal!.name,
                        userId: _userIdController.text,
                        zoneId: _zoneIdController.text,
                        paymentMethod: selectedPayment,
                        totalPrice: totalPrice,
                        orderId: orderId,
                        timeStr: timeNow,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  disabledBackgroundColor: const Color(0xFFCBD5E1),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 3: BUKTI TRANSAKSI (RECEIPT)
// ==========================================
class ReceiptScreen extends StatelessWidget {
  final String gameTitle;
  final String itemName;
  final String userId;
  final String zoneId;
  final String paymentMethod;
  final int totalPrice;
  final String orderId;
  final String timeStr;

  const ReceiptScreen({
    super.key,
    required this.gameTitle,
    required this.itemName,
    required this.userId,
    required this.zoneId,
    required this.paymentMethod,
    required this.totalPrice,
    required this.orderId,
    required this.timeStr,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bukti Transaksi'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 36),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Pembayaran Berhasil!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'No. Order: $orderId',
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    ),
                    const Divider(height: 24, color: Color(0xFFE2E8F0)),

                    _buildRow('Game', gameTitle),
                    _buildRow('Item Top Up', itemName),
                    _buildRow('User ID', zoneId.isNotEmpty ? '$userId ($zoneId)' : userId),
                    _buildRow('Metode Pembayaran', paymentMethod),
                    _buildRow('Waktu', timeStr),
                    _buildRow('Status', 'BERHASIL', statusColor: const Color(0xFF16A34A)),

                    const Divider(height: 24, color: Color(0xFFE2E8F0)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Bayar',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          formatRupiah(totalPrice),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Struk berhasil disimpan!')),
                        );
                      },
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Simpan Struk', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Ke Beranda',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: statusColor ?? const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 4: CEK RIWAYAT TRANSAKSI
// ==========================================
class CheckTransactionScreen extends StatefulWidget {
  const CheckTransactionScreen({super.key});

  @override
  State<CheckTransactionScreen> createState() => _CheckTransactionScreenState();
}

class _CheckTransactionScreenState extends State<CheckTransactionScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResult = [];
  bool hasSearched = false;

  @override
  void initState() {
    super.initState();
    searchResult = List<Map<String, dynamic>>.from(TransactionStore.history);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void searchTransaction(String query) {
    setState(() {
      hasSearched = true;
      final keyword = query.trim().toLowerCase();
      if (keyword.isEmpty) {
        searchResult = List<Map<String, dynamic>>.from(TransactionStore.history);
      } else {
        searchResult = TransactionStore.history.where((tx) =>
          tx['orderId'].toString().toLowerCase().contains(keyword) ||
          tx['userId'].toString().toLowerCase().contains(keyword) ||
          tx['game'].toString().toLowerCase().contains(keyword)
        ).toList();
      }
    });
  }

  void _refreshList() {
    searchTransaction(_searchController.text);
  }

  Future<void> _showTransactionForm({Map<String, dynamic>? transaction}) async {
    final isEdit = transaction != null;
    final gameController = TextEditingController(text: transaction?['game']?.toString() ?? '');
    final itemController = TextEditingController(text: transaction?['item']?.toString() ?? '');
    final userController = TextEditingController(text: transaction?['userId']?.toString() ?? '');
    final zoneController = TextEditingController(text: transaction?['zoneId']?.toString() ?? '');
    final totalController = TextEditingController(
      text: transaction == null ? '' : transaction['total'].toString(),
    );
    String payment = transaction?['payment']?.toString() ?? 'QRIS / All E-Wallet';
    String status = transaction?['status']?.toString() ?? 'BERHASIL';

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Ubah Data Transaksi' : 'Tambah Transaksi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: gameController, decoration: const InputDecoration(labelText: 'Nama game')),
                TextField(controller: itemController, decoration: const InputDecoration(labelText: 'Item top up')),
                TextField(controller: userController, decoration: const InputDecoration(labelText: 'User ID')),
                TextField(controller: zoneController, decoration: const InputDecoration(labelText: 'Zone ID')),
                TextField(
                  controller: totalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Total pembayaran (angka)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: payment,
                  decoration: const InputDecoration(labelText: 'Metode pembayaran'),
                  items: const [
                    'QRIS / All E-Wallet',
                    'GoPay / OVO / DANA',
                    'Virtual Account BCA',
                    'Alfamart / Indomaret',
                  ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                  onChanged: (v) => setDialogState(() => payment = v ?? payment),
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(labelText: 'Status transaksi'),
                  items: const ['BERHASIL', 'DIPROSES', 'GAGAL']
                      .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                  onChanged: (v) => setDialogState(() => status = v ?? status),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final total = int.tryParse(totalController.text.trim());
                if (gameController.text.trim().isEmpty ||
                    itemController.text.trim().isEmpty ||
                    userController.text.trim().isEmpty ||
                    zoneController.text.trim().isEmpty ||
                    total == null || total <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lengkapi semua data dan masukkan total yang valid.')),
                  );
                  return;
                }
                Navigator.pop(dialogContext, {
                  'orderId': transaction?['orderId'] ??
                      'GZ-${DateTime.now().millisecondsSinceEpoch}',
                  'game': gameController.text.trim(),
                  'item': itemController.text.trim(),
                  'userId': userController.text.trim(),
                  'zoneId': zoneController.text.trim(),
                  'payment': payment,
                  'total': total,
                  'time': transaction?['time'] ??
                      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} '
                      '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                  'status': status,
                });
              },
              child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah'),
            ),
          ],
        ),
      ),
    );

    gameController.dispose();
    itemController.dispose();
    userController.dispose();
    zoneController.dispose();
    totalController.dispose();

    if (result == null || !mounted) return;

    setState(() {
      if (isEdit) {
        final index = TransactionStore.history.indexWhere(
          (tx) => tx['orderId'] == transaction['orderId'],
        );
        if (index != -1) TransactionStore.history[index] = result;
      } else {
        TransactionStore.history.insert(0, result);
      }
    });
    _refreshList();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEdit
          ? 'Data transaksi berhasil diubah.'
          : 'Transaksi baru berhasil ditambahkan.')),
    );
  }

  void _showDetail(Map<String, dynamic> tx) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No. Order: ${tx['orderId']}'),
            Text('Game: ${tx['game']}'),
            Text('Item: ${tx['item']}'),
            Text('User ID: ${tx['userId']}'),
            Text('Zone ID: ${tx['zoneId']}'),
            Text('Pembayaran: ${tx['payment']}'),
            Text('Total: ${formatRupiah(tx['total'] as int)}'),
            Text('Waktu: ${tx['time']}'),
            Text('Status: ${tx['status']}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  Future<void> _deleteTransaction(Map<String, dynamic> tx) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus transaksi?'),
        content: Text('Data ${tx['orderId']} akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() {
        TransactionStore.history.removeWhere((item) => item['orderId'] == tx['orderId']);
      });
      _refreshList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil dihapus.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Riwayat Transaksi'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: _refreshList,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTransactionForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Data'),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Total data transaksi: ${TransactionStore.history.length}',
                style: const TextStyle(
                  color: Color(0xFF3730A3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: searchTransaction,
                    decoration: InputDecoration(
                      labelText: 'Cari No. Order / User ID / Game',
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => searchTransaction(_searchController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Cari', style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: searchResult.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.receipt_long_outlined, size: 54, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 8),
                          Text(
                            hasSearched
                                ? 'Tidak ada riwayat transaksi ditemukan.'
                                : 'Belum ada transaksi tersimpan.\\nTekan Tambah Data untuk membuat transaksi.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              _searchController.clear();
                              searchTransaction('');
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tampilkan semua data'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: searchResult.length,
                      itemBuilder: (context, index) {
                        final tx = searchResult[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      tx['orderId'].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    tx['status'].toString(),
                                    style: TextStyle(
                                      color: tx['status'] == 'GAGAL'
                                          ? Colors.red
                                          : const Color(0xFF16A34A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'detail') _showDetail(tx);
                                      if (value == 'edit') _showTransactionForm(transaction: tx);
                                      if (value == 'delete') _deleteTransaction(tx);
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(value: 'detail', child: Text('Lihat detail')),
                                      PopupMenuItem(value: 'edit', child: Text('Ubah data')),
                                      PopupMenuItem(value: 'delete', child: Text('Hapus data')),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(height: 14, color: Color(0xFFE2E8F0)),
                              Text(
                                '${tx['game']} - ${tx['item']}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'ID: ${tx['userId']} (${tx['zoneId']})',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      tx['time'].toString(),
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                    ),
                                  ),
                                  Text(
                                    formatRupiah(tx['total'] as int),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4F46E5),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
