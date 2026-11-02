// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseViewModelHash() => r'ce2a32176dfffde7e828c50d3adca5593ec0d34d';

/// See also [ExpenseViewModel].
@ProviderFor(ExpenseViewModel)
final expenseViewModelProvider =
    AutoDisposeAsyncNotifierProvider<ExpenseViewModel, List<Expense>>.internal(
      ExpenseViewModel.new,
      name: r'expenseViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$expenseViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExpenseViewModel = AutoDisposeAsyncNotifier<List<Expense>>;
String _$currencyViewModelHash() => r'bd7d7ea22f7ff5f9d0986dc3419d8e94ef577962';

/// See also [CurrencyViewModel].
@ProviderFor(CurrencyViewModel)
final currencyViewModelProvider =
    AutoDisposeAsyncNotifierProvider<CurrencyViewModel, Currency>.internal(
      CurrencyViewModel.new,
      name: r'currencyViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currencyViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrencyViewModel = AutoDisposeAsyncNotifier<Currency>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
