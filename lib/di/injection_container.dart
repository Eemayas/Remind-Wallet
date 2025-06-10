import 'package:get_it/get_it.dart';
import '../repositories/expense_repository.dart';
import '../bloc/expense_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => HiveExpenseRepository(),
  );

  // BLoC
  sl.registerFactory(
    () => ExpenseBloc(repository: sl()),
  );
}