import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_chat/features/home/data/data_sources/home_data_source.dart';
import 'package:quick_chat/features/home/data/models/response/user_model.dart';

class HomeDataSourceImp extends HomeDataSource {
  final FirebaseFirestore firestore;

  HomeDataSourceImp({required this.firestore});

  @override
  Future<Either<String, List<UserResponse>>> getUserList() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').get();
      List<UserResponse> userList = querySnapshot.docs
          .map((doc) => UserResponse.fromFirestore(doc))
          .toList();
      return Right(userList);
    } catch (e) {
      return Left('Failed to fetch user list: $e');
    }
  }
}
