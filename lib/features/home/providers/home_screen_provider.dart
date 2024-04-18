// providers/user_provider.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/core/provider/common_provider.dart';
import 'package:quick_chat/features/home/data/data_sources/home_data_source_imp.dart';
import 'package:quick_chat/features/home/data/repositories/home_repository_imp.dart';
import 'package:quick_chat/features/home/domain/entities/user_entity.dart';
import 'package:quick_chat/features/home/domain/repositories/home_repository.dart';
import 'package:quick_chat/features/home/domain/use_cases/get_user_list_usecase.dart';

final userRepositoryProvider = Provider<HomeRepository>((ref) {
  final firebaseFirestore = ref.watch(fireStoreProvider);
  return HomeRepositoryImp(
    homeDataSource: HomeDataSourceImp(firestore: firebaseFirestore),
  );
});

final getUserListUseCaseProvider = Provider<GetUserListUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return GetUserListUseCase(userRepository);
});

final userListProvider = FutureProvider<List<UserEntity>>((ref) async {
  final getUserListUseCase = ref.watch(getUserListUseCaseProvider);
  final Either<String, List<UserEntity>> result = await getUserListUseCase();
  return result.fold(
    (failure) => throw FlutterError('Failed to fetch user list: $failure'),
    (userList) => userList,
  );
});

