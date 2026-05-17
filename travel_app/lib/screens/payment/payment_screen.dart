import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/screens/payment/widgets/order_summary.dart';
import 'package:voyageur/screens/payment/widgets/payment_method_card.dart';
import 'package:voyageur/screens/payment/widgets/secure_payment_badge.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  int _selectedMethod = 0;
  bool _isProcessing = false;

  static const _methods = [
    (
      title: 'Carte bancaire',
      icon: Icons.credit_card,
      subtitle: 'Visa, Mastercard'
    ),
    (
      title: 'PayPal',
      icon: Icons.account_balance_wallet,
      subtitle: 'paiement@exemple.com'
    ),
    (title: 'Apple Pay', icon: Icons.phone_iphone, subtitle: null),
    (
      title: 'Virement bancaire',
      icon: Icons.account_balance,
      subtitle: '2-3 jours ouvrés'
    ),
  ];

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    // go() vers succès : on vide le stack de paiement pour éviter
    // que l'utilisateur puisse revenir en arrière après paiement.
    context.go(AppRoutes.paymentSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement'),
        // Bouton retour automatique vers la réservation
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SecurePaymentBadge(),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Mode de paiement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._methods.asMap().entries.map((entry) {
              final index = entry.key;
              final method = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: PaymentMethodCard(
                  title: method.title,
                  icon: method.icon,
                  subtitle: method.subtitle,
                  isSelected: _selectedMethod == index,
                  onTap: () => setState(() => _selectedMethod = index),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.lg),
            const OrderSummary(
              subtotal: 350.00,
              taxes: 35.00,
              total: 385.00,
              numberOfPersons: 2,
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Payer 385,00 €',
              icon: Icons.lock,
              onPressed: _isProcessing ? null : _processPayment,
              isLoading: _isProcessing,
            ),
            const SizedBox(height: AppSpacing.md),
            const Center(
              child: Text(
                'En confirmant, vous acceptez nos conditions générales',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
