import 'package:equatable/equatable.dart';

/// A reciter / audio edition ("artist") — pure domain entity.
class Edition extends Equatable {
  const Edition({
    required this.id,
    required this.name,
    required this.arabicName,
  });

  /// CDN edition id (e.g. `ar.alafasy`) — drives the audio URL.
  final String id;

  /// Display name in Latin script.
  final String name;

  /// Display name in Arabic script.
  final String arabicName;

  @override
  List<Object> get props => [id, name, arabicName];
}
