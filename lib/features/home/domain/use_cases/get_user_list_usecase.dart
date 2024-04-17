// core/usecases/get_user_list.dart

import 'package:dartz/dartz.dart';
import 'package:quick_chat/features/home/domain/entities/user_entity.dart';
import 'package:quick_chat/features/home/domain/repositories/home_repository.dart';

class GetUserListUseCase {
  final HomeRepository repository;

  GetUserListUseCase(this.repository);

  Future<Either<String, List<UserEntity>>> call() async {
    return await repository.getUserList();
  }
}
