import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/features/home/domain/entities/user_entity.dart';
import 'package:quick_chat/features/home/providers/home_screen_provider.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<UserEntity>> userListState = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: userListState.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Failed to fetch user list: $error'),
        ),
        data: (userList) {
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final UserEntity user = userList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(user.isActive ? 'Active' : 'Inactive'),
              );
            },
          );
        },
      ),
    );
  }
}