// features/home/presentation/pages/home_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventry_app/features/group/presentation/bloc/group_bloc.dart';
import 'package:inventry_app/features/list/presentation/pages/group_page.dart';
import 'package:inventry_app/features/user/presentation/pages/user_profile_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _groups = [];
  final TextEditingController _groupNameCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupBloc>().add(FetchGroupsEvent(uid: widget.uid));
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
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserProfileScreen()),
            );
          },
          icon: Icon(Icons.person),
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
                                (context) => GroupPage(group: _groups[index],userId: widget.uid),
                          ),
                        );
                      },
                      title: Text(_groups[index].groupName),
                      trailing: IconButton(
                        onPressed: () {
                          context.read<GroupBloc>().add(
                            DeleteGroupEvent(
                              groupId: _groups[index].uid,
                              adminId: widget.uid,
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
                            adminId: widget.uid,
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
