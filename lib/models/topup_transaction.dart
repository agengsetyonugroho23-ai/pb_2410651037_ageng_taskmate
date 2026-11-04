class TopupTransaction {
  final String id;
  final String game;
  final String playerId;
  final String item;
  final int price;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  const TopupTransaction({
    required this.id,
    required this.game,
    required this.playerId,
    required this.item,
    required this.price,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  TopupTransaction copyWith({
    String? game,
    String? playerId,
    String? item,
    int? price,
    String? paymentMethod,
    String? status,
    DateTime? createdAt,
  }) {
    return TopupTransaction(
      id: id,
      game: game ?? this.game,
      playerId: playerId ?? this.playerId,
      item: item ?? this.item,
      price: price ?? this.price,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
