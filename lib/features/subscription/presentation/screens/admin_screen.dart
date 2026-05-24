import 'package:flutter/material.dart';
import 'package:ribhi/features/subscription/data/services/admin_service.dart';

class AdminScreen extends StatefulWidget {
  final AdminService adminService;

  const AdminScreen({
    super.key,
    required this.adminService,
  });

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();

  String _plan = 'Premium';
  int _durationDays = 30;
  int _batchCount = 1;

  Map<String, dynamic>? _stats;

  bool _loadingStats = true;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final result = await widget.adminService.getSubscriptionStats();

      if (!mounted) return;

      setState(() {
        _stats = result;
        _loadingStats = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _stats = {
          'totalLicenseKeys': 0,
          'usedLicenseKeys': 0,
          'availableLicenseKeys': 0,
          'activeSubscriptions': 0,
          'pendingRequests': 0,
        };

        _loadingStats = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// =========================
            /// LICENSE KEY GENERATION
            /// =========================
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Generate License Keys',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _plan,
                        decoration: const InputDecoration(
                          labelText: 'Plan',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Basic',
                            child: Text('Basic'),
                          ),
                          DropdownMenuItem(
                            value: 'Premium',
                            child: Text('Premium'),
                          ),
                          DropdownMenuItem(
                            value: 'Pro',
                            child: Text('Pro'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            _plan = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        initialValue: _durationDays.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Duration (days)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter duration';
                          }

                          final days = int.tryParse(value);

                          if (days == null || days <= 0) {
                            return 'Please enter valid duration';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          _durationDays =
                              int.tryParse(value) ?? 30;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        initialValue: _batchCount.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Batch Count',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter count';
                          }

                          final count = int.tryParse(value);

                          if (count == null || count <= 0) {
                            return 'Please enter valid count';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          _batchCount =
                              int.tryParse(value) ?? 1;
                        },
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isGenerating
                                  ? null
                                  : _generateSingleKey,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: _isGenerating
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Generate Single Key',
                                    ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isGenerating
                                  ? null
                                  : _generateBatchKeys,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text(
                                'Generate Batch',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// =========================
            /// STATISTICS
            /// =========================
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subscription Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (_loadingStats)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else ...[
                      _buildStatRow(
                        label: 'Total License Keys',
                        value:
                            '${_stats?['totalLicenseKeys'] ?? 0}',
                      ),

                      _buildStatRow(
                        label: 'Used License Keys',
                        value:
                            '${_stats?['usedLicenseKeys'] ?? 0}',
                      ),

                      _buildStatRow(
                        label: 'Available License Keys',
                        value:
                            '${_stats?['availableLicenseKeys'] ?? 0}',
                      ),

                      _buildStatRow(
                        label: 'Active Subscriptions',
                        value:
                            '${_stats?['activeSubscriptions'] ?? 0}',
                      ),

                      _buildStatRow(
                        label: 'Pending Requests',
                        value:
                            '${_stats?['pendingRequests'] ?? 0}',
                      ),

                      const SizedBox(height: 12),

                      ElevatedButton.icon(
                        onPressed: _loadStats,
                        icon: const Icon(Icons.refresh),
                        label: const Text(
                          'Refresh Statistics',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// =========================
            /// MANAGEMENT
            /// =========================
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed:
                          _viewActivatedSubscriptions,
                      icon: const Icon(Icons.people),
                      label: const Text(
                        'View Activated Subscriptions',
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      onPressed: _viewPendingRequests,
                      icon: const Icon(Icons.payment),
                      label: const Text(
                        'View Pending Requests',
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      onPressed: _cleanupOldRequests,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.delete),
                      label: const Text(
                        'Cleanup Old Requests',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _generateSingleKey() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final key =
          await widget.adminService.generateLicenseKey(
        plan: _plan,
        durationDays: _durationDays,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Generated key: $key'),
        ),
      );

      await _loadStats();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _generateBatchKeys() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final keys = await widget.adminService
          .generateBatchLicenseKeys(
        plan: _plan,
        durationDays: _durationDays,
        count: _batchCount,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Batch Generation Complete',
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generated ${keys.length} keys',
                    ),

                    const SizedBox(height: 12),

                    ...keys.map(
                      (key) => Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: SelectableText(key),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      await _loadStats();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _viewActivatedSubscriptions() async {
    try {
      final subscriptions = await widget.adminService
          .getActivatedSubscriptions();

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Activated Subscriptions',
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: subscriptions.docs.length,
                itemBuilder: (context, index) {
                  final data =
                      subscriptions.docs[index].data()
                          as Map<String, dynamic>;

                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      subscriptions.docs[index].id,
                    ),
                    subtitle: Text(
                      data['plan'] ?? 'Unknown',
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> _viewPendingRequests() async {
    try {
      final requests = await widget.adminService
          .getPendingPaymentRequests();

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Pending Payment Requests',
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: requests.docs.length,
                itemBuilder: (context, index) {
                  final data =
                      requests.docs[index].data()
                          as Map<String, dynamic>;

                  return ListTile(
                    leading:
                        const Icon(Icons.payment_outlined),
                    title: Text(
                      data['uid'] ?? '',
                    ),
                    subtitle: Text(
                      data['phone'] ?? '',
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> _cleanupOldRequests() async {
    try {
      await widget.adminService
          .deleteOldPaymentRequests(30);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Old requests cleaned successfully',
          ),
        ),
      );

      await _loadStats();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
}