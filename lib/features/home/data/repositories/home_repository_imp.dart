import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_chat/features/home/data/data_sources/home_data_source.dart';
import 'package:quick_chat/features/home/domain/entities/user_entity.dart';
import 'package:quick_chat/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImp extends HomeRepository {
  final HomeDataSource homeDataSource;

  HomeRepositoryImp({required this.homeDataSource});

  @override
  Future<Either<String, List<UserEntity>>> getUserList() async {
    final String currentUserEmail = FirebaseAuth.instance.currentUser?.email??"";
    final userListResponse = await homeDataSource.getUserList();
    return userListResponse.map((userList) {
      return userList.where((user) => user.email != currentUserEmail).toList().map((e) => e.toEntity()).toList();
    });
  }
}
