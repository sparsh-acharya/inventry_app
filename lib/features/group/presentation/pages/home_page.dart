// features/home/presentation/pages/home_page.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventry_app/features/group/presentation/bloc/group_bloc.dart';
import 'package:inventry_app/features/list/presentation/pages/group_page.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';
import 'package:inventry_app/features/user/presentation/pages/user_profile_page.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  final UserEntity user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _groups = [];
  final TextEditingController _groupNameCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Optional: Show a snackbar or local notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${message.notification?.title}\n${message.notification?.body}',
            ),
          ),
        );
      }
    });
    print(widget.user.avatarUrl);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupBloc>().add(FetchGroupsEvent(uid: widget.user.uid));
    });
  }

  @override
  void dispose() {
    _groupNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserProfileScreen()),
              );
            },
            child: CircleAvatar(
              child: SvgPicture.network(widget.user.avatarUrl ?? ''),
            ),
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent());
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocConsumer<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupcreatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Successfully created ${state.name}')),
            );
          }
          if (state is GroupErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is GroupDeletedState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Deleted Successfully')));
          }
          if (state is GroupLoadedState) {
            setState(() {
              _groups = state.groups!;
            });
          }
        },
        builder: (context, state) {
          if (state is GroupLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupLoadedState) {
            if (_groups.isEmpty) {
              return const Center(
                child: Text('No groups yet. Create your first group!'),
              );
            } else {
              return ListView.builder(
                itemCount: _groups.length,
                itemBuilder:
                    (context, index) => ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => GroupPage(
                                  group: _groups[index],
                                  userId: widget.user.uid,
                                ),
                          ),
                        );
                      },
                      title: Text(_groups[index].groupName),
                      trailing: IconButton(
                        onPressed: () {
                          context.read<GroupBloc>().add(
                            DeleteGroupEvent(
                              groupId: _groups[index].uid,
                              adminId: widget.user.uid,
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ),
              );
            }
          }
          return ListView.builder(
            itemCount: _groups.length,
            itemBuilder:
                (context, index) =>
                    ListTile(title: Text(_groups[index].groupName)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder:
                (context) => AlertDialog(
                  title: Text('Enter the Group Name'),
                  content: TextField(controller: _groupNameCtrl),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<GroupBloc>().add(
                          CreateGroupEvent(
                            groupName: _groupNameCtrl.text.trim(),
                            adminId: widget.user.uid,
                          ),
                        );
                        _groupNameCtrl.clear();
                      },
                      child: Text('Create'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
          );
        },
        child: Icon(Icons.plus_one),
      ),
    );
  }
}
