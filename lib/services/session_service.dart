import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyEmail = 'user_email';

  // Simpan data login user (Email)
  static Future<void> saveLogin(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyEmail, email);
  }

  // Cek apakah user sedang dalam sesi login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Mengambil email user yang sedang login
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? '';
  }

  // Menghapus data sesi login saat user logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyEmail);
  }
}
