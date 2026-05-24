import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:ribhi/features/subscription/presentation/cubit/subscription_state.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final _phoneController = TextEditingController();
  final _transactionController = TextEditingController();
  final _keyController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _transactionController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    final hp = AppSizes.hPad(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Premium Subscription'),
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listener: (context, state) {
          if (state is PaymentRequestSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment request submitted successfully!'),
              ),
            );
            _phoneController.clear();
            _transactionController.clear();
          } else if (state is LicenseActivated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('License activated successfully!')),
            );
            _keyController.clear();
            context.read<SubscriptionCubit>().loadSubscriptionStatus();
          } else if (state is SubscriptionError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(hp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Banner
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(s(context, 20)),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.orange, Color(0xFFFF6B35)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.star,
                        size: s(context, 48),
                        color: Colors.white,
                      ),
                      SizedBox(height: s(context, 12)),
                      Text(
                        'Unlock Premium Features',
                        style: TextStyle(
                          fontSize: s(context, 24),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: s(context, 24)),

                // Features
                const Text(
                  'Premium Features:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: s(context, 16)),
                _buildFeatureItem('Automatic Cloud Backup'),
                _buildFeatureItem('Restore Anytime'),
                _buildFeatureItem('Secure Firebase Storage'),
                _buildFeatureItem('Multi Device Access'),

                SizedBox(height: s(context, 32)),

                // Vodafone Cash Section
                Container(
                  padding: EdgeInsets.all(s(context, 16)),
                  decoration: BoxDecoration(
                    color: AppColors.navCardBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Method: Vodafone Cash',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: s(context, 12)),
                      Container(
                        padding: EdgeInsets.all(s(context, 12)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.orange),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Send to: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '+201022456065',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.orange,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                  const ClipboardData(text: '+201022456065'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Phone number copied!'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: s(context, 12)),
                      const Text(
                        'Send any amount (minimum 50 EGP) and enter the transaction details below.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: s(context, 24)),

                // Payment Request Form
                const Text(
                  'Submit Payment Request:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: s(context, 16)),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Your Phone Number',
                    hintText: 'Enter your Vodafone Cash number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: s(context, 12)),
                TextField(
                  controller: _transactionController,
                  decoration: const InputDecoration(
                    labelText: 'Transaction ID',
                    hintText: 'Enter the transaction ID from Vodafone Cash',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: s(context, 16)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is SubscriptionLoading
                        ? null
                        : () {
                            if (_phoneController.text.isEmpty ||
                                _transactionController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                ),
                              );
                              return;
                            }
                            context
                                .read<SubscriptionCubit>()
                                .submitPaymentRequest(
                                  phone: _phoneController.text.trim(),
                                  transactionId: _transactionController.text
                                      .trim(),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      padding: EdgeInsets.symmetric(vertical: s(context, 16)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state is SubscriptionLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Submit Payment Request',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),

                SizedBox(height: s(context, 32)),

                // License Key Section
                const Text(
                  'Activate License Key:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: s(context, 16)),
                TextField(
                  controller: _keyController,
                  decoration: const InputDecoration(
                    labelText: 'License Key',
                    hintText:
                        'Enter your activation key (e.g., RBH-X7QP-K29A-ZM81)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: s(context, 16)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is SubscriptionLoading
                        ? null
                        : () {
                            if (_keyController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a license key'),
                                ),
                              );
                              return;
                            }
                            context
                                .read<SubscriptionCubit>()
                                .activateLicenseKey(
                                  _keyController.text.trim().toUpperCase(),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      padding: EdgeInsets.symmetric(vertical: s(context, 16)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state is SubscriptionLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Activate License',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),

                SizedBox(height: s(context, 24)),

                // Current Status
                if (state is SubscriptionLoaded) ...[
                  Container(
                    padding: EdgeInsets.all(s(context, 16)),
                    decoration: BoxDecoration(
                      color: state.isPremium
                          ? AppColors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: state.isPremium ? AppColors.green : Colors.red,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.isPremium ? 'Premium Active' : 'Free Plan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: state.isPremium
                                ? AppColors.green
                                : Colors.red,
                          ),
                        ),
                        if (state.plan != null) ...[
                          SizedBox(height: s(context, 8)),
                          Text('Plan: ${state.plan}'),
                        ],
                        if (state.expiryDate != null) ...[
                          SizedBox(height: s(context, 4)),
                          Text(
                            'Expires: ${state.expiryDate!.toString().split(' ')[0]}',
                          ),
                        ],
                        if (state.lastBackup != null) ...[
                          SizedBox(height: s(context, 4)),
                          Text(
                            'Last Backup: ${state.lastBackup!.toString().split(' ')[0]}',
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
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
}
