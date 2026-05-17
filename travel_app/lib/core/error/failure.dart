import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final int? code;
  final Map<String, List<String>>? fieldErrors;

  const Failure({
    required this.message,
    this.code,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, code, fieldErrors];
}
