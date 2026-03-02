import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
  static String get startUrl => dotenv.env['START_URL']!;
  static String get agendaUrl => dotenv.env['AGENDA_URL']!;
  static String get googleMapsUrl => dotenv.env['GOOGLE_MAPS_URL']!;
  static String get whatsappNumber => dotenv.env['WHATSAPP_NUMBER']!;
  static String get privacyPolicyUrl => dotenv.env['PRIVACY_POLICY_URL']!;
  
  static String get instagramHost => dotenv.env['INSTAGRAM_HOST']!;
  static String get tiktokHost => dotenv.env['TIKTOK_HOST']!;

  static String get cleanBaseUrl => 
      baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
}
