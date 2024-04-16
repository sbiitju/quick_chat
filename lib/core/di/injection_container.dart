import 'package:get_it/get_it.dart';
part 'data_source_injector.dart';
part 'repository_injector.dart';
part 'use_case_injector.dart';

final sl = GetIt.instance;

Future<void> init() async {

  /// UseCase
  await _initUseCases();

  /// Repository
  await _initRepositories();

  /// Datasource
  await _initDataSources();

}