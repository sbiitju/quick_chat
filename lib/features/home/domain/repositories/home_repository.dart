import 'package:dartz/dartz.dart';
import 'package:quick_chat/features/home/domain/entities/user_entity.dart';

abstract class HomeRepository{
  Future<Either<String,List<UserEntity>>> getUserList();
}