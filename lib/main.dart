import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const GameZoneApp());
}

// ==========================================
// KONSTANTA WARNA
// ==========================================
class AppColors {
  static const primary = Color(0xFF4F46E5);
  static const primaryDark = Color(0xFF3730A3);
  static const violet = Color(0xFF7C3AED);
  static const text = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const faint = Color(0xFF94A3B8);
  static const border = Color(0xFFE2E8F0);
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFEA580C);
  static const danger = Color(0xFFEF4444);
  static const diamond = Color(0xFF38BDF8);
}

// ==========================================
// MODEL TRANSAKSI & STORE
// ==========================================
class TxStatus {
  static const success = 'BERHASIL';
  static const pending = 'DIPROSES';
  static const failed = 'GAGAL';
  static const all = [success, pending, failed];

  static Color color(String status) {
    switch (status) {
      case success:
        return AppColors.success;
      case pending:
        return AppColors.warning;
      default:
        return AppColors.danger;
    }
  }
}

class TransactionRecord {
  final String orderId;
  final String game;
  final String item;
  final String userId;
  final String zoneId;
  final String payment;
  final int total;
  final String time;
  final String status;

  const TransactionRecord({
    required this.orderId,
    required this.game,
    required this.item,
    required this.userId,
    required this.zoneId,
    required this.payment,
    required this.total,
    required this.time,
    required this.status,
  });

  String get accountLabel =>
      (zoneId.isEmpty || zoneId == '-') ? userId : '$userId ($zoneId)';
}

// Global Store untuk menyimpan riwayat transaksi (hanya di memori).
class TransactionStore {
  static final List<TransactionRecord> history = [
    const TransactionRecord(
      orderId: 'GZ-DEMO001',
      game: 'Mobile Legends',
      item: '86 Diamonds',
      userId: '12345678',
      zoneId: '2024',
      payment: 'QRIS / All E-Wallet',
      total: 21000,
      time: '24/08/2026 10:15',
      status: TxStatus.success,
    ),
    const TransactionRecord(
      orderId: 'GZ-DEMO002',
      game: 'Free Fire',
      item: '140 Diamonds',
      userId: '987654321',
      zoneId: '-',
      payment: 'GoPay / OVO / DANA',
      total: 21500,
      time: '25/08/2026 14:30',
      status: TxStatus.success,
    ),
  ];
}

// ==========================================
// DATA MODELS
// ==========================================
class PaymentMethod {
  final String name;
  final IconData icon;
  final int fee; // biaya layanan per metode

  const PaymentMethod({
    required this.name,
    required this.icon,
    required this.fee,
  });
}

const List<PaymentMethod> paymentMethods = [
  PaymentMethod(name: 'QRIS / All E-Wallet', icon: Icons.qr_code_2_rounded, fee: 1000),
  PaymentMethod(name: 'GoPay / OVO / DANA', icon: Icons.account_balance_wallet_rounded, fee: 1500),
  PaymentMethod(name: 'Virtual Account BCA', icon: Icons.account_balance_rounded, fee: 2000),
  PaymentMethod(name: 'Alfamart / Indomaret', icon: Icons.store_rounded, fee: 2500),
];

class TopupNominal {
  final String id;
  final String amount; // angka besar, mis. '86' atau 'Weekly Pass'
  final String unit; // mis. 'Diamonds' (kosong untuk pass)
  final int price;
  final String bonus;
  final bool isPopular;
  final bool isPass;

  const TopupNominal({
    required this.id,
    required this.amount,
    this.unit = '',
    required this.price,
    this.bonus = '',
    this.isPopular = false,
    this.isPass = false,
  });

  String get fullName => unit.isEmpty ? amount : '$amount $unit';
}

class GameItem {
  final String id;
  final String title;
  final String publisher;
  final IconData icon;
  final Color themeColor;
  final String badgeText;
  final String? imageAsset;
  final bool needsZone; // apakah game ini memakai Zone ID
  final String currencyName; // Diamonds, VP, UC, dll.
  final IconData currencyIcon;
  final Color currencyColor;
  final String idHint; // petunjuk menemukan User ID
  final List<TopupNominal> nominals;

  GameItem({
    required this.id,
    required this.title,
    required this.publisher,
    required this.icon,
    required this.themeColor,
    required this.nominals,
    this.badgeText = '',
    this.imageAsset,
    this.needsZone = false,
    this.currencyName = 'Diamonds',
    this.currencyIcon = Icons.diamond_rounded,
    this.currencyColor = AppColors.diamond,
    this.idHint = 'Buka profil di dalam game untuk melihat User ID kamu.',
  });

  List<TopupNominal> get currencyItems =>
      nominals.where((n) => !n.isPass).toList();
  List<TopupNominal> get passItems => nominals.where((n) => n.isPass).toList();
}

// Data dummy game top up (nominal berbeda untuk tiap game)
final List<GameItem> gameList = [
  GameItem(
    id: 'mlbb',
    title: 'Mobile Legends',
    publisher: 'Moonton',
    icon: Icons.sports_esports,
    themeColor: const Color(0xFF4F46E5),
    badgeText: 'HOT',
    imageAsset: 'assets/images/ml.jpg',
    needsZone: true,
    idHint: 'Ketuk foto profil di game. User ID dan Zone ID tampil di sana, contoh: 12345678 (2024).',
    nominals: const [
      TopupNominal(id: '1', amount: '56', unit: 'Diamonds', price: 15000, bonus: '+2 Bonus'),
      TopupNominal(id: '2', amount: '86', unit: 'Diamonds', price: 20000, bonus: '+5 Bonus', isPopular: true),
      TopupNominal(id: '3', amount: '172', unit: 'Diamonds', price: 40000, bonus: '+10 Bonus'),
      TopupNominal(id: '4', amount: '257', unit: 'Diamonds', price: 60000, bonus: '+15 Bonus', isPopular: true),
      TopupNominal(id: '5', amount: '344', unit: 'Diamonds', price: 80000, bonus: '+20 Bonus'),
      TopupNominal(id: '6', amount: '706', unit: 'Diamonds', price: 160000, bonus: '+50 Bonus'),
      TopupNominal(id: '7', amount: '2195', unit: 'Diamonds', price: 500000, bonus: '+150 Bonus'),
      TopupNominal(id: '8', amount: 'Weekly Pass', price: 28000, bonus: 'Hemat 400%', isPopular: true, isPass: true),
    ],
  ),
  GameItem(
    id: 'ff',
    title: 'Free Fire',
    publisher: 'Garena',
    icon: Icons.local_fire_department,
    themeColor: const Color(0xFFEA580C),
    imageAsset: 'assets/images/ff.jpg',
    badgeText: 'HOT',
    idHint: 'Ketuk foto profil di game, ID ada di bawah nickname kamu.',
    nominals: const [
      TopupNominal(id: '1', amount: '5', unit: 'Diamonds', price: 1000),
      TopupNominal(id: '2', amount: '50', unit: 'Diamonds', price: 7000, bonus: '+5 Bonus'),
      TopupNominal(id: '3', amount: '140', unit: 'Diamonds', price: 20000, bonus: '+10 Bonus', isPopular: true),
      TopupNominal(id: '4', amount: '355', unit: 'Diamonds', price: 50000, bonus: '+25 Bonus'),
      TopupNominal(id: '5', amount: '720', unit: 'Diamonds', price: 100000, bonus: '+60 Bonus', isPopular: true),
      TopupNominal(id: '6', amount: 'Member Mingguan', price: 30000, bonus: 'Hemat 300%', isPopular: true, isPass: true),
      TopupNominal(id: '7', amount: 'Member Bulanan', price: 90000, bonus: 'Hemat 500%', isPass: true),
    ],
  ),
  GameItem(
    id: 'pubg',
    title: 'PUBG Mobile',
    publisher: 'Tencent',
    icon: Icons.ads_click,
    themeColor: const Color(0xFFD97706),
    imageAsset: 'assets/images/pubg.jpg',
    currencyName: 'UC',
    currencyIcon: Icons.monetization_on_rounded,
    currencyColor: const Color(0xFFF59E0B),
    idHint: 'Ketuk foto profil di game untuk melihat Character ID.',
    nominals: const [
      TopupNominal(id: '1', amount: '60', unit: 'UC', price: 15000),
      TopupNominal(id: '2', amount: '325', unit: 'UC', price: 75000, bonus: '+13 Bonus', isPopular: true),
      TopupNominal(id: '3', amount: '660', unit: 'UC', price: 150000, bonus: '+30 Bonus'),
      TopupNominal(id: '4', amount: '1800', unit: 'UC', price: 400000, bonus: '+120 Bonus'),
    ],
  ),
  GameItem(
    id: 'gi',
    title: 'Genshin Impact',
    publisher: 'HoYoverse',
    icon: Icons.auto_awesome,
    themeColor: const Color(0xFF7C3AED),
    imageAsset: 'assets/images/gensin.jpg',
    currencyName: 'Genesis Crystal',
    currencyIcon: Icons.auto_awesome,
    currencyColor: const Color(0xFF7C3AED),
    idHint: 'UID ada di pojok kanan bawah layar menu game.',
    nominals: const [
      TopupNominal(id: '1', amount: '60', unit: 'Genesis Crystal', price: 16000),
      TopupNominal(id: '2', amount: '330', unit: 'Genesis Crystal', price: 79000, bonus: '+30 Bonus', isPopular: true),
      TopupNominal(id: '3', amount: '1090', unit: 'Genesis Crystal', price: 249000, bonus: '+110 Bonus'),
      TopupNominal(id: '4', amount: '2240', unit: 'Genesis Crystal', price: 479000, bonus: '+260 Bonus'),
      TopupNominal(id: '5', amount: 'Welkin Moon', price: 79000, bonus: 'Hemat 300%', isPopular: true, isPass: true),
    ],
  ),
  GameItem(
    id: 'val',
    title: 'Valorant',
    publisher: 'Riot Games',
    icon: Icons.gps_fixed,
    themeColor: const Color(0xFFE11D48),
    imageAsset: 'assets/images/valoran.jpg',
    currencyName: 'VP',
    currencyIcon: Icons.change_history_rounded,
    currencyColor: const Color(0xFFE11D48),
    idHint: 'Gunakan Riot ID kamu, contoh: 12345678.',
    nominals: const [
      TopupNominal(id: '1', amount: '475', unit: 'VP', price: 55000),
      TopupNominal(id: '2', amount: '1000', unit: 'VP', price: 110000, bonus: '+50 Bonus', isPopular: true),
      TopupNominal(id: '3', amount: '2050', unit: 'VP', price: 220000, bonus: '+100 Bonus'),
      TopupNominal(id: '4', amount: '3650', unit: 'VP', price: 380000, bonus: '+250 Bonus'),
    ],
  ),
  GameItem(
    id: 'hsr',
    title: 'Honkai: Star Rail',
    publisher: 'HoYoverse',
    icon: Icons.stars,
    themeColor: const Color(0xFF0284C7),
    imageAsset: 'assets/images/honkai.jpg',
    currencyName: 'Oneiric Shard',
    currencyIcon: Icons.stars,
    currencyColor: const Color(0xFF0284C7),
    idHint: 'UID ada di pojok kanan bawah layar menu game.',
    nominals: const [
      TopupNominal(id: '1', amount: '60', unit: 'Oneiric Shard', price: 16000),
      TopupNominal(id: '2', amount: '330', unit: 'Oneiric Shard', price: 79000, bonus: '+30 Bonus', isPopular: true),
      TopupNominal(id: '3', amount: '1090', unit: 'Oneiric Shard', price: 249000, bonus: '+110 Bonus'),
      TopupNominal(id: '4', amount: 'Express Supply Pass', price: 79000, bonus: 'Hemat 300%', isPass: true),
    ],
  ),
  GameItem(
    id: 'ro',
    title: 'Ragnarok Origin',
    publisher: 'Gravity',
    icon: Icons.shield,
    themeColor: const Color(0xFF059669),
    imageAsset: 'assets/images/ragnarok.jpg',
    currencyName: 'Zeny',
    currencyIcon: Icons.monetization_on_rounded,
    currencyColor: const Color(0xFF059669),
    idHint: 'Gunakan ID karakter yang tampil di menu profil.',
    nominals: const [
      TopupNominal(id: '1', amount: '60', unit: 'Zeny', price: 15000),
      TopupNominal(id: '2', amount: '300', unit: 'Zeny', price: 75000, bonus: '+20 Bonus', isPopular: true),
      TopupNominal(id: '3', amount: '980', unit: 'Zeny', price: 230000, bonus: '+80 Bonus'),
    ],
  ),
  GameItem(
    id: 'ea',
    title: 'FC Mobile',
    publisher: 'EA Sports',
    icon: Icons.sports_soccer,
    themeColor: const Color(0xFF16A34A),
    imageAsset: 'assets/images/fcmobile.jpg',
    currencyName: 'FC Points',
    currencyIcon: Icons.sports_soccer,
    currencyColor: const Color(0xFF16A34A),
    idHint: 'Gunakan ID akun EA kamu yang tampil di menu pengaturan.',
    nominals: const [
      TopupNominal(id: '1', amount: '100', unit: 'FC Points', price: 15000),
      TopupNominal(id: '2', amount: '520', unit: 'FC Points', price: 75000, bonus: '+20 Bonus', isPopular: true),
      TopupNominal(id: '3', amount: '1070', unit: 'FC Points', price: 150000, bonus: '+50 Bonus'),
      TopupNominal(id: '4', amount: '2200', unit: 'FC Points', price: 300000, bonus: '+120 Bonus'),
    ],
  ),
];

// ==========================================
// HELPER
// ==========================================
String formatRupiah(int number) {
  return 'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
}

String formatTime(DateTime d) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
}

// Gambar game dengan efek fade-in dan fallback ikon jika gagal dimuat.
Widget _gameImage(GameItem game,
    {double? size, BoxFit fit = BoxFit.cover, double iconSize = 28}) {
  return Image.asset(
    game.imageAsset!,
    width: size,
    height: size,
    fit: fit,
    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded) return child;
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: child,
      );
    },
    errorBuilder: (context, error, stackTrace) {
      return Container(
        color: game.themeColor.withOpacity(0.12),
        child: Center(
          child: Icon(game.icon, color: game.themeColor, size: iconSize),
        ),
      );
    },
  );
}

// Widget cadangan jika game belum memiliki gambar.
Widget _gameIconFallback(GameItem game) {
  return Container(
    width: 72,
    height: 72,
    decoration: BoxDecoration(
      color: game.themeColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(game.icon, color: game.themeColor, size: 38),
  );
}

// Baris "judul ... nilai" yang dipakai di dialog, struk, dan ringkasan.
Widget _infoRow(String title, String value,
    {Color? valueColor, bool bold = false, double fontSize = 13}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: AppColors.muted, fontSize: fontSize)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontSize: fontSize,
              color: valueColor ?? AppColors.text,
            ),
          ),
        ),
      ],
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final c = TxStatus.color(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final int number;
  final String title;
  final bool done;

  const _StepHeader({
    required this.number,
    required this.title,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: done ? AppColors.success : AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, size: 15, color: Colors.white)
                : Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
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
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          iconTheme: IconThemeData(color: AppColors.text),
          titleTextStyle: TextStyle(
            color: AppColors.text,
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
// SCREEN 1: HOME
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
        game.title.toLowerCase().contains(searchQuery.trim().toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.violet],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              'GAMEZONE',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            const Text(
              '.topup',
              style: TextStyle(
                color: AppColors.primary,
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
            icon: const Icon(Icons.history_rounded, size: 18, color: AppColors.primary),
            label: const Text(
              'Cek Riwayat',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.violet],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '⚡ FLASH SALE TOP UP',
                              style: TextStyle(
                                color: Color(0xFFE0E7FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Proses Instan & Otomatis 24/7',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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

                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari game favoritmu...',
                    hintStyle: const TextStyle(fontSize: 14, color: AppColors.faint),
                    prefixIcon: const Icon(Icons.search, color: AppColors.faint, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Label Section
                const Row(
                  children: [
                    Icon(Icons.sports_esports_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'PILIHAN GAME TOP UP',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (filteredGames.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.search_off_rounded, size: 52, color: AppColors.faint),
                          const SizedBox(height: 8),
                          Text(
                            'Game "$searchQuery" tidak ditemukan.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.muted, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Coba kata kunci lain.',
                            style: TextStyle(color: AppColors.faint, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: filteredGames.length,
                    itemBuilder: (context, index) {
                      final game = filteredGames[index];
                      return _buildGameCard(game);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(GameItem game) {
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
          border: Border.all(color: AppColors.border),
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
            if (game.imageAsset != null) ...[
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Latar saat gambar belum selesai dimuat
                      ColoredBox(color: game.themeColor.withOpacity(0.10)),
                      _gameImage(game, iconSize: 48),
                    ],
                  ),
                ),
              ),
              // Gradasi agar nama game tetap terbaca di atas gambar.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xCC000000)],
                      stops: [0.45, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 6,
                right: 6,
                bottom: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      game.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      game.publisher,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ] else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _gameIconFallback(game),
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
                          fontSize: 12,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      game.publisher,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            if (game.badgeText.isNotEmpty)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    game.badgeText,
                    style: const TextStyle(
                      fontSize: 9,
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
  PaymentMethod selectedPayment = paymentMethods.first;

  bool _checkingAccount = false;
  bool _processing = false;
  String? _nickname;

  @override
  void dispose() {
    _userIdController.dispose();
    _zoneIdController.dispose();
    super.dispose();
  }

  // ---------- Status kelengkapan form ----------
  bool get _userIdValid =>
      RegExp(r'^[0-9]{5,20}$').hasMatch(_userIdController.text.trim());

  bool get _zoneValid =>
      !widget.game.needsZone ||
          RegExp(r'^[0-9]{1,10}$').hasMatch(_zoneIdController.text.trim());

  bool get _accountValid => _userIdValid && _zoneValid;

  bool get _canPay => _accountValid && selectedNominal != null;

  int get _total =>
      selectedNominal == null ? 0 : selectedNominal!.price + selectedPayment.fee;

  String get _hintMessage {
    if (!_accountValid) {
      return widget.game.needsZone
          ? 'Isi User ID dan Zone ID dengan benar untuk melanjutkan.'
          : 'Isi User ID dengan benar untuk melanjutkan.';
    }
    if (selectedNominal == null) {
      return 'Pilih nominal top up yang kamu inginkan.';
    }
    return 'Semua data lengkap. Periksa ringkasan, lalu tekan Bayar Sekarang.';
  }

  String get _accountText {
    final uid = _userIdController.text.trim();
    return widget.game.needsZone ? '$uid (${_zoneIdController.text.trim()})' : uid;
  }

  void _snack(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // ---------- Cek akun (SIMULASI) ----------
  // Untuk aplikasi nyata, ganti dengan pemanggilan API yang mengembalikan nickname asli.
  Future<void> _checkAccount() async {
    if (!_accountValid) {
      _formKey.currentState!.validate();
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _checkingAccount = true;
      _nickname = null;
    });
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final id = _userIdController.text.trim();
    setState(() {
      _checkingAccount = false;
      _nickname = 'Player_${id.substring(id.length - 4)}';
    });
  }

  // ---------- Proses pembayaran ----------
  Future<void> _onPay() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      _snack('Data akun belum valid. Periksa kembali isian kamu.', color: Colors.red);
      return;
    }
    final nominal = selectedNominal;
    if (nominal == null) {
      _snack('Nominal top up wajib dipilih.', color: Colors.red);
      return;
    }
    final payment = selectedPayment;
    final total = nominal.price + payment.fee;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Pesanan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow('Game', widget.game.title),
              _infoRow('Item', nominal.fullName),
              _infoRow(widget.game.needsZone ? 'User ID (Zone)' : 'User ID', _accountText),
              if (_nickname != null) _infoRow('Nickname', _nickname!),
              _infoRow('Pembayaran', payment.name),
              const Divider(height: 20),
              _infoRow('Total', formatRupiah(total),
                  bold: true, valueColor: AppColors.primary, fontSize: 15),
              const SizedBox(height: 10),
              const Text(
                'Pastikan data akun sudah benar. Item yang terkirim ke akun yang salah tidak dapat dikembalikan.',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Periksa Lagi'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Bayar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _processing = true);
    await Future.delayed(const Duration(milliseconds: 1400)); // simulasi proses
    if (!mounted) return;

    final now = DateTime.now();
    final record = TransactionRecord(
      orderId: 'GZ-${now.millisecondsSinceEpoch.toString().substring(5)}',
      game: widget.game.title,
      item: nominal.fullName,
      userId: _userIdController.text.trim(),
      zoneId: widget.game.needsZone ? _zoneIdController.text.trim() : '-',
      payment: payment.name,
      total: total,
      time: formatTime(now),
      status: TxStatus.success,
    );
    TransactionStore.history.insert(0, record);

    setState(() => _processing = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          tx: record,
          itemPrice: nominal.price,
          fee: payment.fee,
        ),
      ),
    );
  }

  // ---------- Widget bantu ----------
  InputDecoration _fieldDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      counterText: '',
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _subLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.muted,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildNominalGrid(List<TopupNominal> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200, // lebar maksimal tiap kartu
        mainAxisExtent: 136, // tinggi tetap, tidak ikut melebar
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildNominalCard(items[index]),
    );
  }

  Widget _buildNominalCard(TopupNominal item) {
    final game = widget.game;
    final isSelected = selectedNominal?.id == item.id;

    return InkWell(
      onTap: () => setState(() => selectedNominal = item),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ]
              : [],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ikon + jumlah
                Padding(
                  padding: EdgeInsets.only(right: item.isPopular ? 32 : 0),
                  child: Row(
                    children: [
                      Icon(
                        item.isPass ? Icons.card_giftcard_rounded : game.currencyIcon,
                        color: item.isPass ? AppColors.violet : game.currencyColor,
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.amount,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: item.isPass ? 14 : 18,
                            color: isSelected ? AppColors.primary : AppColors.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Satuan
                Text(
                  item.unit.isEmpty ? 'Paket spesial' : item.unit,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
                // Bonus
                if (item.bonus.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.bonus,
                      style: const TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20),
                // Harga
                Text(
                  formatRupiah(item.price),
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : const Color(0xFF475569),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // Badge HOT
            if (item.isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'HOT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Centang saat dipilih
            if (isSelected)
              const Positioned(
                bottom: 0,
                right: 0,
                child: Icon(Icons.check_circle, color: AppColors.primary, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTile(PaymentMethod method) {
    final isSelected = selectedPayment.name == method.name;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => selectedPayment = method),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.04) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(method.icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Biaya layanan ${formatRupiah(method.fee)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primary : AppColors.faint,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final nominal = selectedNominal;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pembayaran',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          const SizedBox(height: 6),
          if (nominal == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Belum ada nominal yang dipilih.',
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            )
          else ...[
            _infoRow('Item', nominal.fullName),
            _infoRow('Harga', formatRupiah(nominal.price)),
            _infoRow('Biaya layanan', formatRupiah(selectedPayment.fee)),
            const Divider(height: 16, color: AppColors.border),
            _infoRow('Total', formatRupiah(_total),
                bold: true, valueColor: AppColors.primary, fontSize: 15),
          ],
        ],
      ),
    );
  }

  Widget _buildHintCard() {
    final ready = _canPay;
    final color = ready ? AppColors.success : AppColors.primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ready ? const Color(0xFFF0FDF4) : const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ready ? const Color(0xFFBBF7D0) : const Color(0xFFC7D2FE),
        ),
      ),
      child: Row(
        children: [
          Icon(ready ? Icons.check_circle_outline : Icons.info_outline,
              color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _hintMessage,
              style: TextStyle(
                fontSize: 13,
                color: ready ? const Color(0xFF166534) : AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    final passItems = game.passItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Up ${game.title}'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Game
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: game.themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: game.imageAsset != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _gameImage(game, size: 44, iconSize: 22),
                        )
                            : Icon(game.icon, color: game.themeColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${game.publisher} • Proses Cepat ⚡',
                              style: const TextStyle(fontSize: 12, color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Step 1: Data akun
                _StepHeader(number: 1, title: 'Masukkan Data Akun', done: _accountValid),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _userIdController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: _fieldDecoration('User ID', 'Cth: 12345678'),
                          onChanged: (_) => setState(() => _nickname = null),
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
                      if (game.needsZone) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _zoneIdController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: _fieldDecoration('Zone ID', '2024'),
                            onChanged: (_) => setState(() => _nickname = null),
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
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.help_outline_rounded, size: 16, color: AppColors.faint),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        game.idHint,
                        style: const TextStyle(fontSize: 12, color: AppColors.muted),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: (_accountValid && !_checkingAccount) ? _checkAccount : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _checkingAccount
                          ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Cek Akun', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                if (_nickname != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Akun ditemukan: $_nickname',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF166534),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 22),

                // Step 2: Nominal
                _StepHeader(number: 2, title: 'Pilih Nominal Top Up', done: selectedNominal != null),
                const SizedBox(height: 10),
                _subLabel(game.currencyName.toUpperCase()),
                _buildNominalGrid(game.currencyItems),
                if (passItems.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _subLabel('PASS & BUNDLE'),
                  _buildNominalGrid(passItems),
                ],
                const SizedBox(height: 22),

                // Step 3: Pembayaran
                const _StepHeader(number: 3, title: 'Metode Pembayaran', done: false),
                const SizedBox(height: 10),
                ...paymentMethods.map(_buildPaymentTile),
                const SizedBox(height: 14),

                // Ringkasan + petunjuk
                _buildSummaryCard(),
                const SizedBox(height: 12),
                _buildHintCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(color: AppColors.muted, fontSize: 12),
                          ),
                          Text(
                            formatRupiah(_total),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (selectedNominal != null)
                            Text(
                              selectedNominal!.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.muted, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: (_canPay && !_processing) ? _onPay : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: const Color(0xFFCBD5E1),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _processing
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        'Bayar Sekarang',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
  final TransactionRecord tx;
  final int itemPrice;
  final int fee;

  const ReceiptScreen({
    super.key,
    required this.tx,
    required this.itemPrice,
    required this.fee,
  });

  String get _receiptText => [
    'GAMEZONE.topup - Bukti Transaksi',
    'No. Order : ${tx.orderId}',
    'Game      : ${tx.game}',
    'Item      : ${tx.item}',
    'User ID   : ${tx.accountLabel}',
    'Pembayaran: ${tx.payment}',
    'Waktu     : ${tx.time}',
    'Status    : ${tx.status}',
    'Harga     : ${formatRupiah(itemPrice)}',
    'Biaya     : ${formatRupiah(fee)}',
    'Total     : ${formatRupiah(tx.total)}',
  ].join('\n');

  void _copy(BuildContext context, String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bukti Transaksi'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
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
                        child: const Icon(Icons.check_circle, color: AppColors.success, size: 36),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Pembayaran Berhasil!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No. Order: ${tx.orderId}',
                            style: const TextStyle(color: AppColors.muted, fontSize: 13),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => _copy(context, tx.orderId, 'Nomor order disalin.'),
                            borderRadius: BorderRadius.circular(6),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.copy_rounded, size: 16, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, color: AppColors.border),
                      _infoRow('Game', tx.game),
                      _infoRow('Item Top Up', tx.item),
                      _infoRow('User ID', tx.accountLabel),
                      _infoRow('Metode Pembayaran', tx.payment),
                      _infoRow('Waktu', tx.time),
                      _infoRow('Status', tx.status, valueColor: TxStatus.color(tx.status)),
                      const Divider(height: 24, color: AppColors.border),
                      _infoRow('Harga', formatRupiah(itemPrice)),
                      _infoRow('Biaya layanan', formatRupiah(fee)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Bayar',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.text),
                          ),
                          Text(
                            formatRupiah(tx.total),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
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
                        onPressed: () => _copy(context, _receiptText, 'Struk disalin ke clipboard.'),
                        icon: const Icon(Icons.copy_all_rounded, size: 18),
                        label: const Text('Salin Struk', style: TextStyle(fontSize: 14)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckTransactionScreen()),
                                (route) => route.isFirst,
                          );
                        },
                        icon: const Icon(Icons.history_rounded, size: 18),
                        label: const Text('Lihat Riwayat', style: TextStyle(fontSize: 14)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Ke Beranda',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
  String _statusFilter = 'Semua';
  bool _adminMode = false; // CRUD hanya tersedia di mode admin

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TransactionRecord> get _results {
    final keyword = _searchController.text.trim().toLowerCase();
    return TransactionStore.history.where((tx) {
      final matchStatus = _statusFilter == 'Semua' || tx.status == _statusFilter;
      final matchKeyword = keyword.isEmpty ||
          tx.orderId.toLowerCase().contains(keyword) ||
          tx.userId.toLowerCase().contains(keyword) ||
          tx.game.toLowerCase().contains(keyword);
      return matchStatus && matchKeyword;
    }).toList();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showTransactionForm({TransactionRecord? record}) async {
    final isEdit = record != null;
    final gameController = TextEditingController(text: record?.game ?? '');
    final itemController = TextEditingController(text: record?.item ?? '');
    final userController = TextEditingController(text: record?.userId ?? '');
    final zoneController = TextEditingController(
      text: (record == null || record.zoneId == '-') ? '' : record.zoneId,
    );
    final totalController = TextEditingController(
      text: record == null ? '' : record.total.toString(),
    );
    String payment = record?.payment ?? paymentMethods.first.name;
    String status = record?.status ?? TxStatus.success;
    String? formError;

    final result = await showDialog<TransactionRecord>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Ubah Data Transaksi' : 'Tambah Transaksi'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: gameController, decoration: const InputDecoration(labelText: 'Nama game')),
                  TextField(controller: itemController, decoration: const InputDecoration(labelText: 'Item top up')),
                  TextField(
                    controller: userController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'User ID'),
                  ),
                  TextField(
                    controller: zoneController,
                    decoration: const InputDecoration(
                      labelText: 'Zone ID (kosongkan jika tidak ada)',
                    ),
                  ),
                  TextField(
                    controller: totalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Total pembayaran (angka)'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: payment,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Metode pembayaran'),
                    items: paymentMethods
                        .map((m) => DropdownMenuItem(value: m.name, child: Text(m.name)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => payment = v ?? payment),
                  ),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Status transaksi'),
                    items: TxStatus.all
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => status = v ?? status),
                  ),
                  if (formError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        formError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
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
                    total == null ||
                    total <= 0) {
                  setDialogState(() {
                    formError = 'Lengkapi semua data dan masukkan total yang valid.';
                  });
                  return;
                }
                final zone = zoneController.text.trim();
                Navigator.pop(
                  dialogContext,
                  TransactionRecord(
                    orderId: record?.orderId ?? 'GZ-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                    game: gameController.text.trim(),
                    item: itemController.text.trim(),
                    userId: userController.text.trim(),
                    zoneId: zone.isEmpty ? '-' : zone,
                    payment: payment,
                    total: total,
                    time: record?.time ?? formatTime(DateTime.now()),
                    status: status,
                  ),
                );
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
              (tx) => tx.orderId == record!.orderId,
        );
        if (index != -1) TransactionStore.history[index] = result;
      } else {
        TransactionStore.history.insert(0, result);
      }
    });
    _snack(isEdit
        ? 'Data transaksi berhasil diubah.'
        : 'Transaksi baru berhasil ditambahkan.');
  }

  void _showDetail(TransactionRecord tx) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Transaksi'),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow('No. Order', tx.orderId),
              _infoRow('Game', tx.game),
              _infoRow('Item', tx.item),
              _infoRow('User ID', tx.accountLabel),
              _infoRow('Pembayaran', tx.payment),
              _infoRow('Total', formatRupiah(tx.total)),
              _infoRow('Waktu', tx.time),
              _infoRow('Status', tx.status, valueColor: TxStatus.color(tx.status)),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: tx.orderId));
              Navigator.pop(context);
              _snack('Nomor order disalin.');
            },
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text('Salin No. Order'),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  Future<void> _deleteTransaction(TransactionRecord tx) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus transaksi?'),
        content: Text('Data ${tx.orderId} akan dihapus.'),
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
        TransactionStore.history.removeWhere((item) => item.orderId == tx.orderId);
      });
      _snack('Transaksi berhasil dihapus.');
    }
  }

  Widget _buildTransactionCard(TransactionRecord tx) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => _showDetail(tx),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tx.orderId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  _StatusBadge(tx.status),
                  if (_adminMode)
                    PopupMenuButton<String>(
                      tooltip: 'Menu admin',
                      onSelected: (value) {
                        if (value == 'detail') _showDetail(tx);
                        if (value == 'edit') _showTransactionForm(record: tx);
                        if (value == 'delete') _deleteTransaction(tx);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'detail', child: Text('Lihat detail')),
                        PopupMenuItem(value: 'edit', child: Text('Ubah data')),
                        PopupMenuItem(value: 'delete', child: Text('Hapus data')),
                      ],
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.chevron_right_rounded, color: AppColors.faint),
                    ),
                ],
              ),
              const Divider(height: 16, color: AppColors.border),
              Text(
                '${tx.game} - ${tx.item}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                'ID: ${tx.accountLabel}',
                style: const TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tx.time,
                      style: const TextStyle(fontSize: 12, color: AppColors.faint),
                    ),
                  ),
                  Text(
                    formatRupiah(tx.total),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Riwayat Transaksi'),
        actions: [
          const Text('Mode Admin', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          Switch(
            value: _adminMode,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _adminMode = v),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: _adminMode
          ? FloatingActionButton.extended(
        onPressed: () => _showTransactionForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Data'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (_adminMode)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFED7AA)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.admin_panel_settings_outlined, color: AppColors.warning, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Mode admin aktif: kamu bisa menambah, mengubah, dan menghapus data.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF9A3412)),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Pencarian langsung saat mengetik
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari No. Order / User ID / Game',
                    hintStyle: const TextStyle(fontSize: 14, color: AppColors.faint),
                    prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.faint),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Filter status
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Semua', ...TxStatus.all].map((s) {
                      final selected = _statusFilter == s;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(s, style: const TextStyle(fontSize: 12)),
                          selected: selected,
                          selectedColor: AppColors.primary.withOpacity(0.12),
                          onSelected: (_) => setState(() => _statusFilter = s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Menampilkan ${results.length} dari ${TransactionStore.history.length} transaksi',
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: results.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.receipt_long_outlined, size: 54, color: AppColors.faint),
                        const SizedBox(height: 8),
                        Text(
                          TransactionStore.history.isEmpty
                              ? 'Belum ada transaksi tersimpan.'
                              : 'Tidak ada riwayat transaksi yang cocok.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.muted, fontSize: 14),
                        ),
                        if (TransactionStore.history.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _statusFilter = 'Semua');
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tampilkan semua data'),
                          ),
                        ],
                      ],
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: results.length,
                    itemBuilder: (context, index) =>
                        _buildTransactionCard(results[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}