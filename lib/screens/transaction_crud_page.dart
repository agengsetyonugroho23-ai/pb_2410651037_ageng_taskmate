import 'package:flutter/material.dart';
import '../data/mock_transactions.dart';
import '../models/topup_transaction.dart';

class TransactionCrudPage extends StatefulWidget {
  const TransactionCrudPage({super.key});

  @override
  State<TransactionCrudPage> createState() => _TransactionCrudPageState();
}

class _TransactionCrudPageState extends State<TransactionCrudPage> {
  final List<TopupTransaction> _transactions =
      List<TopupTransaction>.from(mockTransactions);

  String _rupiah(int value) =>
      'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  void _feedback(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showForm({TopupTransaction? transaction}) async {
    final isEdit = transaction != null;
    final gameController = TextEditingController(text: transaction?.game ?? '');
    final playerController = TextEditingController(text: transaction?.playerId ?? '');
    final itemController = TextEditingController(text: transaction?.item ?? '');
    final priceController = TextEditingController(
      text: transaction == null ? '' : transaction.price.toString(),
    );
    String payment = transaction?.paymentMethod ?? 'QRIS';
    String status = transaction?.status ?? 'Diproses';

    final result = await showDialog<TopupTransaction>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Ubah Transaksi' : 'Tambah Transaksi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: gameController, decoration: const InputDecoration(labelText: 'Nama game')),
                TextField(controller: playerController, decoration: const InputDecoration(labelText: 'ID pemain')),
                TextField(controller: itemController, decoration: const InputDecoration(labelText: 'Nominal/item')),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Harga (angka)'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: payment,
                  decoration: const InputDecoration(labelText: 'Metode pembayaran'),
                  items: ['QRIS', 'Transfer Bank', 'E-Wallet']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setDialogState(() => payment = v ?? payment),
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['Diproses', 'Berhasil', 'Gagal']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setDialogState(() => status = v ?? status),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
            FilledButton(
              onPressed: () {
                final price = int.tryParse(priceController.text.trim());
                if (gameController.text.trim().isEmpty ||
                    playerController.text.trim().isEmpty ||
                    itemController.text.trim().isEmpty ||
                    price == null || price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lengkapi semua data dan masukkan harga yang valid.')),
                  );
                  return;
                }
                Navigator.pop(
                  dialogContext,
                  TopupTransaction(
                    id: transaction?.id ??
                        'TRX${DateTime.now().millisecondsSinceEpoch}',
                    game: gameController.text.trim(),
                    playerId: playerController.text.trim(),
                    item: itemController.text.trim(),
                    price: price,
                    paymentMethod: payment,
                    status: status,
                    createdAt: transaction?.createdAt ?? DateTime.now(),
                  ),
                );
              },
              child: Text(isEdit ? 'Simpan' : 'Tambah'),
            ),
          ],
        ),
      ),
    );

    gameController.dispose();
    playerController.dispose();
    itemController.dispose();
    priceController.dispose();

    if (result == null || !mounted) return;
    setState(() {
      final index = _transactions.indexWhere((e) => e.id == result.id);
      if (index >= 0) {
        _transactions[index] = result;
      } else {
        _transactions.insert(0, result);
      }
    });
    _feedback(isEdit ? 'Transaksi berhasil diubah.' : 'Transaksi berhasil ditambahkan.');
  }

  void _showDetail(TopupTransaction t) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detail('ID Transaksi', t.id),
            _detail('Game', t.game),
            _detail('ID Pemain', t.playerId),
            _detail('Item', t.item),
            _detail('Harga', _rupiah(t.price)),
            _detail('Pembayaran', t.paymentMethod),
            _detail('Status', t.status),
            _detail('Tanggal', t.createdAt.toString()),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
      ),
    );
  }

  Widget _detail(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text('$label: $value'),
  );

  Future<void> _delete(TopupTransaction t) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus transaksi?'),
        content: Text('Transaksi ${t.id} akan dihapus dari daftar.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      setState(() => _transactions.removeWhere((e) => e.id == t.id));
      _feedback('Transaksi berhasil dihapus.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GameZone Topup - Data Transaksi'),
        backgroundColor: const Color(0xFF172554),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: _transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Belum ada transaksi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Tekan tombol Tambah untuk membuat transaksi.'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: const Color(0xFFEFF6FF),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Total ${_transactions.length} transaksi',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ..._transactions.map((t) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFDBEAFE),
                      child: Icon(Icons.sports_esports, color: Color(0xFF1D4ED8)),
                    ),
                    title: Text(t.game, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${t.item} • ${t.playerId}\n${_rupiah(t.price)} • ${t.status}'),
                    isThreeLine: true,
                    onTap: () => _showDetail(t),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'detail') _showDetail(t);
                        if (value == 'edit') _showForm(transaction: t);
                        if (value == 'delete') _delete(t);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'detail', child: Text('Lihat detail')),
                        PopupMenuItem(value: 'edit', child: Text('Ubah')),
                        PopupMenuItem(value: 'delete', child: Text('Hapus')),
                      ],
                    ),
                  ),
                )),
              ],
            ),
    );
  }
}
