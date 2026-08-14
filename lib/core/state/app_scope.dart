import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class AppScope extends StatelessWidget {
  final Widget child;

  const AppScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: child,
    );
  }
}