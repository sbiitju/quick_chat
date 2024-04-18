import 'package:dartz/dartz.dart';
import 'package:quick_chat/features/home/data/models/response/user_model.dart';

abstract class HomeDataSource {
  Future<Either<String, List<UserResponse>>> getUserList();
}
