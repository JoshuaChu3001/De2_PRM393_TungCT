import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../viewmodels/expense_view_model.dart';
import 'edit_expense_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseViewModelProvider);
    final currency = ref.watch(currencyViewModelProvider);

    ref.listen(expenseViewModelProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Có lỗi: ${next.error}')));
      }
    });

    ref.listen(currencyViewModelProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể lưu tiền tệ: ${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: currency.hasValue
                ? () => _changeCurrency(context, ref, currency.value!)
                : null,
          ),
        ],
      ),
      body: expenses.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: TextButton(
            onPressed: () =>
                ref.read(expenseViewModelProvider.notifier).loadExpenses(),
            child: const Text('Không tải được dữ liệu. Thử lại'),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Chưa có khoản chi nào.'));
          }

          return ListView(
            children: items.map((expense) {
              final selectedCurrency = currency.valueOrNull ?? Currency.vnd;
              final amount = NumberFormat.currency(
                locale: selectedCurrency == Currency.vnd ? 'vi_VN' : 'en_US',
                symbol: selectedCurrency.symbol,
                decimalDigits: selectedCurrency == Currency.vnd ? 0 : 2,
              ).format(expense.price);

              return ListTile(
                title: Text(expense.title),
                subtitle: Text(
                  '${DateFormat('dd/MM/yyyy').format(expense.day)}'
                  ' · ${expense.category}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(amount),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditExpenseScreen(expense: expense),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _changeCurrency(
    BuildContext context,
    WidgetRef ref,
    Currency current,
  ) async {
    var selected = current;

    final result = await showDialog<Currency>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Đơn vị tiền tệ'),
          content: RadioGroup<Currency>(
            groupValue: selected,
            onChanged: (value) {
              if (value != null) setState(() => selected = value);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Currency.values.map((currency) {
                return RadioListTile(
                  title: Text(currency.code),
                  value: currency,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, selected),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );

    if (result == null) return;

    try {
      await ref.read(currencyViewModelProvider.notifier).setCurrency(result);
    } catch (_) {}
  }
}
