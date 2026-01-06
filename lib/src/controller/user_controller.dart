import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Kullanıcı Modeli (State)
class UserState {
  final String name;
  final String email;

  UserState({required this.name, required this.email});

  UserState copyWith({String? name, String? email}) {
    return UserState(name: name ?? this.name, email: email ?? this.email);
  }
}

// Controller Sınıfı
class UserController extends StateNotifier<UserState> {
  UserController()
    : super(UserState(name: "Misafir Kullanıcı", email: "misafir@lafbaz.ai")) {
    loadUser(); // Uygulama açılınca verileri yükle
  }

  // 1. Verileri Telefondan Oku
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name') ?? "Misafir Kullanıcı";
    final savedEmail = prefs.getString('user_email') ?? "misafir@lafbaz.ai";

    state = UserState(name: savedName, email: savedEmail);
  }

  // 2. Verileri Kaydet ve State'i Güncelle
  Future<void> saveUser({String? name, String? email}) async {
    final prefs = await SharedPreferences.getInstance();

    if (name != null) {
      await prefs.setString('user_name', name);
    }
    if (email != null) {
      await prefs.setString('user_email', email);
    }

    // State'i güncelle ki Drawer anında değişsin
    state = state.copyWith(name: name, email: email);
  }

  // 3. Hesabı Sil (Sıfırla)
  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_email');

    state = UserState(name: "Misafir Kullanıcı", email: "misafir@lafbaz.ai");
  }
}

// Provider Tanımı
final userControllerProvider = StateNotifierProvider<UserController, UserState>(
  (ref) {
    return UserController();
  },
);
