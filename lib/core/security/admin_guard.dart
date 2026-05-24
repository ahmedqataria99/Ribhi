import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/features/subscription/data/services/admin_service.dart';
import 'package:ribhi/features/subscription/presentation/screens/admin_screen.dart';

class AdminGuard {
  static Future<bool> canAccessAdmin([AdminService? adminService]) async {
    final service =
        adminService ??
        AdminService(
          firestore: FirebaseFirestore.instance,
          auth: FirebaseAuth.instance,
        );

    return await service.isAdminUser();
  }

  static Widget adminRoute(BuildContext context) {
    final service = RepositoryProvider.of<AdminService>(context);
    return FutureBuilder<bool>(
      future: canAccessAdmin(service),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return AdminScreen(adminService: service);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Access Denied'),
            backgroundColor: Colors.redAccent,
          ),
          body: const Center(
            child: Text(
              'You do not have permission to access the admin panel.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
