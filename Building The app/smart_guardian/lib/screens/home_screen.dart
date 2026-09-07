import 'package:flutter/material.dart';
import '../models/user_role.dart';

class HomeScreen extends StatelessWidget {
  final UserRole role;
  const HomeScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${role.label} Dashboard')),
      body: Center(
        child: Text(
          'Welcome, ${role.label}!\nBuild the ${role.label.toLowerCase()} dashboard here.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}