import 'package:flutter/foundation.dart';
import 'package:instagram_flutter/models/account.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';

class AccountProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();

  Account? _account;

  Account? get getAccount => _account;

  Future<void> refreshAccount() async {
    Account account = await _authMethods.getAccountDetail();
    _account = account;

    notifyListeners();
  }
}
