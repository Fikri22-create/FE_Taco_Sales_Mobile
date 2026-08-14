class MockApiException implements Exception {
  final String message;
  const MockApiException(this.message);

  @override
  String toString() => message;
}

class MockApiService {
  static bool simulateOffline = false;

  /// Simulates a network fetch: latency, then either throws (offline) or returns data.
  static Future<T> fetch<T>(
    T Function() load, {
    Duration delay = const Duration(milliseconds: 700),
  }) async {
    await Future.delayed(delay);
    if (simulateOffline) {
      throw const MockApiException(
        'Tidak ada koneksi internet. Periksa jaringan Anda.',
      );
    }
    return load();
  }
}