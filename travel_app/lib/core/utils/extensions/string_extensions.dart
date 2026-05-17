extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeEachWord {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^\+?[\d\s-]{8,15}$').hasMatch(this);
  }

  String get maskEmail {
    if (isEmpty || !contains('@')) return this;
    final parts = split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '***@$domain';
    return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@domain';
  }
}
