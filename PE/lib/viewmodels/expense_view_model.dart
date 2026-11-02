import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database_helper.dart';
import '../models/expense.dart';

part 'expense_view_model.g.dart';

enum Currency {
  vnd('VND', '₫'),
  usd('USD', r'$');

  const Currency(this.code, this.symbol);

  final String code;
  final String symbol;
}

@riverpod
class ExpenseViewModel extends _$ExpenseViewModel {
  final DatabaseHelper _database = DatabaseHelper.instance;

  @override
  Future<List<Expense>> build() => _database.getExpenses();

  Future<void> loadExpenses() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_database.getExpenses);
  }

  Future<void> addExpense(Expense expense) async {
    await _runMutation(() => _database.insertExpense(expense));
  }

  Future<void> updateExpense(Expense expense) async {
    await _runMutation(() => _database.updateExpense(expense));
  }

  Future<void> deleteExpense(int id) async {
    await _runMutation(() => _database.deleteExpense(id));
  }

  Future<void> _runMutation(Future<int> Function() mutation) async {
    final result = await AsyncValue.guard(() async {
      await mutation();
      return _database.getExpenses();
    });
    state = result;
    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
  }
}

@riverpod
class CurrencyViewModel extends _$CurrencyViewModel {
  static const _preferenceKey = 'preferred_currency';

  @override
  Future<Currency> build() async {
    final preferences = await SharedPreferences.getInstance();
    final savedCode = preferences.getString(_preferenceKey);
    return Currency.values.firstWhere(
      (currency) => currency.code == savedCode,
      orElse: () => Currency.vnd,
    );
  }

  Future<void> setCurrency(Currency currency) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(_preferenceKey, currency.code);
    if (!saved) {
      throw StateError('Không thể lưu loại tiền tệ đã chọn.');
    }
    state = AsyncData(currency);
  }
}
