class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:5137/api'; // Hoặc IP Wifi của ông

 
  static String cleanImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    // Nếu link chứa localhost, ép nó về 10.0.2.2 để máy ảo không bị từ chối kết nối
    return url.replaceAll('localhost', '10.0.2.2'); 
  }
}