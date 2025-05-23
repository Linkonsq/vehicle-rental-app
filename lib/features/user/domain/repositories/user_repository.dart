import 'package:vehicle_rental_app/features/user/domain/entities/user.dart';

abstract class UserRepository {
  Stream<User?> get authStateChanges;
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<void> signOut();
}
