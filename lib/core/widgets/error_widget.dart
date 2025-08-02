import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  String _getUserFriendlyMessage(String technicalMessage) {
    final lowerMessage = technicalMessage.toLowerCase();

    if (lowerMessage.contains('network') ||
        lowerMessage.contains('connection') ||
        lowerMessage.contains('timeout') ||
        lowerMessage.contains('socket') ||
        lowerMessage.contains('networkexception')) {
      return 'Tidak dapat terhubung ke internet. Periksa koneksi Anda dan coba lagi.';
    }

    if (lowerMessage.contains('server') ||
        lowerMessage.contains('500') ||
        lowerMessage.contains('503') ||
        lowerMessage.contains('502') ||
        lowerMessage.contains('serverexception')) {
      return 'Server sedang bermasalah. Silakan coba lagi dalam beberapa saat.';
    }

    if (lowerMessage.contains('404') ||
        lowerMessage.contains('not found') ||
        lowerMessage.contains('notfoundexception')) {
      return 'Data yang dicari tidak ditemukan.';
    }

    if (lowerMessage.contains('401') ||
        lowerMessage.contains('unauthorized') ||
        lowerMessage.contains('forbidden') ||
        lowerMessage.contains('403') ||
        lowerMessage.contains('authexception') ||
        lowerMessage.contains('authorizationexception')) {
      return 'Akses ditolak. Silakan login kembali.';
    }

    if (lowerMessage.contains('format') ||
        lowerMessage.contains('parse') ||
        lowerMessage.contains('json') ||
        lowerMessage.contains('formatexception') ||
        lowerMessage.contains('parseexception')) {
      return 'Terjadi kesalahan dalam memproses data. Silakan coba lagi.';
    }

    if (lowerMessage.contains('cache') ||
        lowerMessage.contains('cacheexception')) {
      return 'Gagal mengakses data tersimpan. Silakan coba lagi.';
    }

    return 'Terjadi kesalahan. Silakan coba lagi dalam beberapa saat.';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _getUserFriendlyMessage(message),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
