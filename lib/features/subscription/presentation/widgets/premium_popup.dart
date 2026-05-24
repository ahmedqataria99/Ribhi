import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:ribhi/features/subscription/presentation/cubit/subscription_state.dart';
import 'package:ribhi/features/subscription/presentation/screens/subscription_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumPopup extends StatefulWidget {
  const PremiumPopup({super.key});

  @override
  State<PremiumPopup> createState() => _PremiumPopupState();
}

class _PremiumPopupState extends State<PremiumPopup> {
  @override
  void initState() {
    super.initState();
    _checkAndShowPopup();
  }

  Future<void> _checkAndShowPopup() async {
    // Wait a bit for the subscription state to load
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final subscriptionCubit = context.read<SubscriptionCubit>();
    final isPremium = await _isUserPremium(subscriptionCubit);

    if (!isPremium) {
      final prefs = await SharedPreferences.getInstance();
      final lastShown = prefs.getInt('premium_popup_last_shown');
      final now = DateTime.now().millisecondsSinceEpoch;

      if (lastShown == null || (now - lastShown) > 24 * 60 * 60 * 1000) {
        // Show popup
        await prefs.setInt('premium_popup_last_shown', now);
        if (mounted) {
          _showPremiumDialog();
        }
      }
    }
  }

  Future<bool> _isUserPremium(SubscriptionCubit cubit) async {
    return await cubit.isUserPremium();
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Unlock Ribhi Premium',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.orange,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            _buildFeatureItem('Automatic Cloud Backup'),
            _buildFeatureItem('Restore Anytime'),
            _buildFeatureItem('Secure Firebase Storage'),
            _buildFeatureItem('Multi Device Access'),
            const SizedBox(height: 24),
            const Text(
              'Subscribe now and never lose your data!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to subscription screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<SubscriptionCubit>(),
                    child: const SubscriptionScreen(),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Subscribe Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 20),
          const SizedBox(width: 12),
          Text(feature, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
