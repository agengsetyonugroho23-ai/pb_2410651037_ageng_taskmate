import '../models/topup_transaction.dart';

final List<TopupTransaction> mockTransactions = [
  TopupTransaction(
    id: 'TRX001',
    game: 'Mobile Legends',
    playerId: '12345678 (1234)',
    item: '86 Diamonds',
    price: 20000,
    paymentMethod: 'QRIS',
    status: 'Berhasil',
    createdAt: DateTime(2026, 8, 24, 10, 15),
  ),
  TopupTransaction(
    id: 'TRX002',
    game: 'Free Fire',
    playerId: '987654321',
    item: '140 Diamonds',
    price: 19000,
    paymentMethod: 'Transfer Bank',
    status: 'Diproses',
    createdAt: DateTime(2026, 8, 25, 14, 30),
  ),
  TopupTransaction(
    id: 'TRX003',
    game: 'PUBG Mobile',
    playerId: '555666777',
    item: '60 UC',
    price: 15000,
    paymentMethod: 'E-Wallet',
    status: 'Berhasil',
    createdAt: DateTime(2026, 8, 26, 9, 0),
  ),
];
