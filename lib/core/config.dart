import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get agendaUrl => 
      dotenv.env['AGENDA_URL'] ?? '${baseUrl}agendar-cita/';
  static String get googleMapsUrl => 
      dotenv.env['GOOGLE_MAPS_URL'] ?? 'https://maps.app.goo.gl/Q9TG27dRxv8aTXbC8';
  static String get whatsappNumber => 
      dotenv.env['WHATSAPP_NUMBER'] ?? '50768984998';
  static String get privacyPolicyUrl => 
      dotenv.env['PRIVACY_POLICY_URL'] ?? '';
  
  static String get instagramHost => 
      Uri.tryParse(dotenv.env['INSTAGRAM_URL'] ?? '')?.host ?? 'instagram.com';
  static String get tiktokHost => 
      Uri.tryParse(dotenv.env['TIKTOK_URL'] ?? '')?.host ?? 'tiktok.com';

  static String get cleanBaseUrl => 
      baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
}
