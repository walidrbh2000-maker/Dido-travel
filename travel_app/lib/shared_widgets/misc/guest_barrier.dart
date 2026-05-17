import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/providers/auth/guest_provider.dart';
import 'package:voyageur/screens/auth/guest_prompt_sheet.dart';

/// Wraps any widget and intercepts pointer events for guest users.
///
/// When the current user is a guest:
///   - All taps on [child] are absorbed (the child's own `onPressed` never fires)
///   - A [GuestPromptSheet] is shown instead with login / register CTAs
///
/// When the user is authenticated the widget is rendered untouched.
///
/// Example:
/// ```dart
/// GuestBarrier(
///   reason: 'pour réserver ce vol',
///   child: PrimaryButton(
///     label: 'Réserver maintenant',
///     onPressed: () => ...,
///   ),
/// )
/// ```
class GuestBarrier extends ConsumerWidget {
  /// The widget to protect. Rendered normally for authenticated users.
  final Widget child;

  /// Optional context string appended to the prompt subtitle.
  /// e.g. `'pour réserver ce vol'` → "Connectez-vous pour réserver ce vol."
  final String? reason;

  const GuestBarrier({
    super.key,
    required this.child,
    this.reason,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);

    if (!isGuest) return child;

    // AbsorbPointer prevents the child from receiving any pointer events.
    // The outer GestureDetector catches the tap and shows the prompt.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => GuestPromptSheet.show(context, reason: reason),
      child: AbsorbPointer(child: child),
    );
  }
}
