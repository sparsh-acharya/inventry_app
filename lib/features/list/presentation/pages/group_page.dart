import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventry_app/features/group/domain/entities/group_entity.dart';
import 'package:inventry_app/features/group/presentation/bloc/group_bloc.dart';
import 'package:inventry_app/features/list/domain/entities/list_entity.dart';
import 'package:inventry_app/features/list/presentation/bloc/list_bloc.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';

class GroupPage extends StatefulWidget {
  final GroupEntity group;
  final String userId;
  const GroupPage({super.key, required this.group, required this.userId});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<ListEntity>? items = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListBloc>().add(FetchItemsEvent(groupId: widget.group.uid));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.groupName),
        actions: [
          if (widget.group.admin == widget.userId)
            IconButton(
              onPressed: () => _showAddUserDialog(context, widget.group.uid),
              icon: const Icon(Icons.person_add_alt_1),
            ),
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        ],
      ),
      body: BlocConsumer<ListBloc, ListState>(
        listener: (context, state) {
          if (state is ListErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is ListAddedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('successfully added ${state.name}')),
            );
          }
          if (state is ListDeletedState) {
            // Add this listener
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item successfully deleted')),
            );
          }
          if (state is ListLoadedState) {
            setState(() {
              items = state.items;
            });
          }
        },
        builder: (context, state) {
          if (state is ListLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ListLoadedState) {
            return ItemListView(items: items, widget: widget);
          }
          return ItemListView(items: items, widget: widget);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ListBloc>().add(
            AddItemEvent(
              groupId: widget.group.uid,
              itemName: 'test',
              count: 3,
              unit: 'kg',
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ItemListView extends StatelessWidget {
  const ItemListView({super.key, required this.items, required this.widget});

  final List<ListEntity>? items;
  final GroupPage widget;

  @override
  Widget build(BuildContext context) {
    if (items!.isEmpty) {
      return Center(child: Text('no item yet, try adding one'));
    } else {
      return ListView.builder(
        itemCount: items!.length,
        itemBuilder: (context, index) {
          final item = items![index];
          return Dismissible(
            key: Key(items![index].uid),

            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                _showEditItemDialog(
                  context,
                  item,
                  widget.group.uid,
                ); // Trigger edit dialog
                return false;
                // Left swipe
                // Don't dismiss, let the stream rebuild
              } else {
                context.read<ListBloc>().add(
                  DeleteItemEvent(groupId: widget.group.uid, itemId: item.uid),
                );
                return false;
                // Right swipe
                // Don't dismiss
              }
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.blue,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            child: ListTile(
              title: Text(item.name),
              subtitle: Text(
                'Unit: ${item.unit}',
              ), // Subtitle can just show the unit now
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      // Prevent count from going below 1
                      if (item.itemCount > 1) {
                        context.read<ListBloc>().add(
                          EditItemEvent(
                            groupId: widget.group.uid,
                            itemId: item.uid,
                            itemName: item.name,
                            count: item.itemCount - 1, // Decrement
                            unit: item.unit,
                          ),
                        );
                      }
                    },
                  ),
                  Text(
                    '${item.itemCount}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      context.read<ListBloc>().add(
                        EditItemEvent(
                          groupId: widget.group.uid,
                          itemId: item.uid,
                          itemName: item.name,
                          count: item.itemCount + 1, // Increment
                          unit: item.unit,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}

void _showEditItemDialog(
  BuildContext buildContext,
  ListEntity item,
  String groupId,
) {
  final nameController = TextEditingController(text: item.name);
  final countController = TextEditingController(
    text: item.itemCount.toString(),
  );
  final unitController = TextEditingController(text: item.unit);
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: buildContext,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit ${item.name}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator:
                    (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: countController,
                decoration: const InputDecoration(labelText: 'Count'),
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? 'Please enter a count' : null,
              ),
              TextFormField(
                controller: unitController,
                decoration: const InputDecoration(
                  labelText: 'Unit (e.g., kg, pcs)',
                ),
                validator:
                    (value) => value!.isEmpty ? 'Please enter a unit' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Dispatch the EditItemEvent
                buildContext.read<ListBloc>().add(
                  EditItemEvent(
                    groupId: groupId,
                    itemId: item.uid,
                    itemName: nameController.text,
                    count: int.tryParse(countController.text) ?? 0,
                    unit: unitController.text,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );
}

void _showAddUserDialog(BuildContext buildContext, String groupId) {
  final handleController = TextEditingController();
  UserEntity? foundUser; // <<-- MOVE THE VARIABLE HERE

  showDialog(
    context: buildContext,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          // The 'foundUser' variable is no longer declared here

          return BlocProvider.value(
            value: BlocProvider.of<GroupBloc>(buildContext),
            child: BlocConsumer<GroupBloc, GroupState>(
              listener: (context, state) {
                if (state is UserFoundState) {
                  // Update the 'foundUser' variable that exists outside this builder
                  setState(() {
                    foundUser = state.user;
                  });
                }
                if (state is UserAddedToGroupState) {
                  ScaffoldMessenger.of(buildContext).showSnackBar(
                    const SnackBar(content: Text('User added successfully!')),
                  );
                  Navigator.pop(dialogContext);
                }
                if (state is GroupErrorState) {
                  setState(() {
                    foundUser = null;
                  });
                }
              },
              builder: (context, state) {
                return AlertDialog(
                  title: const Text('Add User to Group'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: handleController,
                        decoration: InputDecoration(
                          labelText: 'User Handle',
                          prefixText: '@',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              if (handleController.text.isNotEmpty) {
                                context.read<GroupBloc>().add(
                                  SearchUserByHandleEvent(
                                    handle: handleController.text.trim(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // This part will now work correctly
                      if (state is GroupSearchLoadingState)
                        const CircularProgressIndicator(),
                      if (state is GroupErrorState)
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      if (foundUser != null)
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(foundUser!.displayName ?? 'No Name'),
                          subtitle: Text('@${foundUser!.userHandle}'),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      // This will now enable correctly
                      onPressed:
                          foundUser == null
                              ? null
                              : () {
                                context.read<GroupBloc>().add(
                                  AddUserToGroupEvent(
                                    groupId: groupId,
                                    userId: foundUser!.uid,
                                  ),
                                );
                              },
                      child: const Text('Add User'),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    },
  );
}
