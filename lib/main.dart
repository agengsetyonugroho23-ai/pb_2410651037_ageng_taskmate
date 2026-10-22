import 'package:flutter/material.dart';

void main() {
  runApp(const GameZoneApp());
}

class GameZoneApp extends StatelessWidget {
  const GameZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameZone Top Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

// Model Data Game
class GameItem {
  final String title;
  final String category;
  final IconData icon;

  GameItem({required this.title, required this.category, required this.icon});
}

// SCREEN 1: Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GameItem> games = [
      GameItem(title: 'Mobile Legends', category: 'MOBA', icon: Icons.sports_esports),
      GameItem(title: 'Free Fire', category: 'Battle Royale', icon: Icons.local_fire_department),
      GameItem(title: 'PUBG Mobile', category: 'Battle Royale', icon: Icons.gps_fixed),
      GameItem(title: 'Genshin Impact', category: 'RPG', icon: Icons.auto_awesome),
      GameItem(title: 'Valorant', category: 'FPS', icon: Icons.bolt),
      GameItem(title: 'Honor of Kings', category: 'MOBA', icon: Icons.shield),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 GameZone Top Up', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Promo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.blueAccent],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROMO MINGGU INI!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Top up game favoritmu dan dapatkan cashback hingga 30%.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Pilih Game',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Grid Daftar Game
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Event Handling Navigasi ke Screen 2
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopUpFormScreen(game: game),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.deepPurple.shade300,
                          child: Icon(game.icon, size: 32, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          game.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          game.category,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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

// SCREEN 2: Top Up Form Screen (Input Pengguna)
class TopUpFormScreen extends StatefulWidget {
  final GameItem game;

  const TopUpFormScreen({super.key, required this.game});

  @override
  State<TopUpFormScreen> createState() => _TopUpFormScreenState();
}

class _TopUpFormScreenState extends State<TopUpFormScreen> {
  final _userIdController = TextEditingController();
  final _zoneIdController = TextEditingController();
  String? selectedNominal;
  String? selectedPayment;

  final List<String> nominalList = [
    '50 Diamonds (Rp 15.000)',
    '150 Diamonds (Rp 45.000)',
    '300 Diamonds (Rp 90.000)',
    '500 Diamonds (Rp 150.000)',
    '1000 Diamonds (Rp 290.000)',
  ];

  final List<String> paymentList = ['QRIS / BRImo', 'Gopay / OVO', 'Transfer Bank BRI'];

  @override
  void dispose() {
    _userIdController.dispose();
    _zoneIdController.dispose();
    super.dispose();
  }

  void _submitTransaction() {
    if (_userIdController.text.trim().isEmpty || selectedNominal == null || selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data transaksi!')),
      );
      return;
    }

    // Event Handling Navigasi ke Screen 3 (Kirim Data)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionSuccessScreen(
          gameTitle: widget.game.title,
          userId: _userIdController.text,
          zoneId: _zoneIdController.text.isEmpty ? '-' : _zoneIdController.text,
          nominal: selectedNominal!,
          paymentMethod: selectedPayment!,
        ),
      ),
    );
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
            const Text('1. Masukkan User ID & Zone ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _userIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User ID',
                      hintText: 'Contoh: 12345678',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _zoneIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Zone ID',
                      hintText: '1234',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('2. Pilih Nominal Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: nominalList.map((nominal) {
                final isSelected = selectedNominal == nominal;
                return ChoiceChip(
                  label: Text(nominal),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedNominal = selected ? nominal : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            const Text('3. Pilih Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Column(
              children: paymentList.map((payment) {
                return RadioListTile<String>(
                  title: Text(payment),
                  value: payment,
                  groupValue: selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _submitTransaction,
                child: const Text(
                  'BAYAR SEKARANG',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SCREEN 3: Transaction Success Screen (Hasil Navigasi & Data)
class TransactionSuccessScreen extends StatelessWidget {
  final String gameTitle;
  final String userId;
  final String zoneId;
  final String nominal;
  final String paymentMethod;

  const TransactionSuccessScreen({
    super.key,
    required this.gameTitle,
    required this.userId,
    required this.zoneId,
    required this.nominal,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'Transaksi Berhasil!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pesanan top up kamu sedang diproses.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDetailRow('Game', gameTitle),
                      const Divider(),
                      _buildDetailRow('User ID (Zone)', '$userId ($zoneId)'),
                      const Divider(),
                      _buildDetailRow('Item / Nominal', nominal),
                      const Divider(),
                      _buildDetailRow('Metode Pembayaran', paymentMethod),
                      const Divider(),
                      _buildDetailRow('Status', 'BERHASIL', isStatus: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.home, color: Colors.white),
                  label: const Text('Kembali ke Beranda', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  onPressed: () {
                    // Event Handling Pop kembali ke Home
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isStatus ? Colors.green : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}