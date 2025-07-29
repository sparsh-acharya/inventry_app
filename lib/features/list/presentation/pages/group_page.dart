import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventry_app/features/group/domain/entities/group_entity.dart';
import 'package:inventry_app/features/group/presentation/bloc/group_bloc.dart';
import 'package:inventry_app/features/group/presentation/pages/group_info_page.dart';
import 'package:inventry_app/features/list/domain/entities/list_entity.dart';
import 'package:inventry_app/features/list/presentation/bloc/list_bloc.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';

class GroupPage extends StatefulWidget {
  final GroupEntity group;
  final String userId;
  final String userHandle;
  const GroupPage({
    super.key,
    required this.group,
    required this.userId,
    required this.userHandle,
  });

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {
  List<ListEntity>? items = [];
  bool _dontShowAutomationWarning = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _fabController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fabScale = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeInOut));

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListBloc>().add(FetchItemsEvent(groupId: widget.group.uid));
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.8),
              theme.colorScheme.secondary.withOpacity(0.6),
              theme.colorScheme.background,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Premium Header
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildPremiumHeader(theme),
              ),

              // Main Content
              Expanded(
                child: BlocConsumer<ListBloc, ListState>(
                  listener: (context, state) {
                    if (state is ListErrorState) {
                      _showPremiumSnackBar(
                        state.message,
                        theme.colorScheme.error,
                        Icons.error_rounded,
                      );
                    }
                    if (state is ListAddedState) {
                      _showPremiumSnackBar(
                        'Successfully added ${state.name}',
                        theme.colorScheme.tertiary,
                        Icons.check_circle_rounded,
                      );
                    }
                    if (state is ListDeletedState) {
                      _showPremiumSnackBar(
                        'Item successfully deleted',
                        theme.colorScheme.error,
                        Icons.delete_rounded,
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
                      return _buildLoadingState(theme);
                    } else if (state is ListLoadedState) {
                      return ItemListView(
                        items: items,
                        widget: widget,
                        slideAnimation: _slideAnimation,
                        fadeAnimation: _fadeAnimation,
                        onShowAutomationWarning: _showAutomationWarning,
                      );
                    }
                    return ItemListView(
                      items: items,
                      widget: widget,
                      slideAnimation: _slideAnimation,
                      fadeAnimation: _fadeAnimation,
                      onShowAutomationWarning: _showAutomationWarning,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScale,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.tertiary,
                theme.colorScheme.tertiary.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.tertiary.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => _showPremiumAddItemDialog(theme),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add_rounded, size: 32, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        children: [
          // Navigation and Actions Row
          Row(
            children: [
              // Back Button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Group Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Inventory Group",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.group.groupName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              if (widget.group.admin == widget.userId) ...[
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed:
                        () => _showAddUserDialog(
                          context,
                          widget.group.uid,
                          widget.userHandle,
                        ),
                    icon: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white.withOpacity(0.9),
                      size: 20,
                    ),
                  ),
                ),

                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final result = await Navigator.push<String?>(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => GroupInfoPage(
                                group: widget.group,
                                currentUserId: widget.userId,
                              ),
                        ),
                      );

                      // If the group name was updated, refresh the groups list
                      if (result != null && mounted) {
                        context.read<GroupBloc>().add(
                          FetchGroupsEvent(uid: widget.userId),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.edit_rounded,
                      color: Colors.white.withOpacity(0.9),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.inventory_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Loading inventory...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPremiumAddItemDialog(ThemeData theme) {
    final nameController = TextEditingController();
    final countController = TextEditingController(text: '1');
    final unitController = TextEditingController();
    final consumptionRateController = TextEditingController();
    final notificationThresholdController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    bool automationEnabled = false;
    DateTime selectedStartDate = DateTime.now();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 600),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.add_box_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Add New Item',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildPremiumTextField(
                              controller: nameController,
                              label: 'Item Name',
                              hint: 'Enter item name',
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? 'Please enter an item name'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Count',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),

                                      _buildPremiumTextField(
                                        controller: countController,
                                        label: 'Count',
                                        hint: '1',
                                        keyboardType: TextInputType.number,
                                        validator:
                                            (value) =>
                                                value!.isEmpty
                                                    ? 'Please enter a count'
                                                    : null,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Unit',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),

                                      _buildPremiumTextField(
                                        controller: unitController,
                                        maxLength: 7,
                                        label: 'Unit',
                                        hint: 'kg, pcs, etc.',
                                        validator:
                                            (value) =>
                                                value!.isEmpty
                                                    ? 'Please enter a unit'
                                                    : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Automation Toggle
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Smart Automation',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Inventory on autopilot',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: automationEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          automationEnabled = value;
                                        });
                                      },
                                      activeColor: theme.colorScheme.tertiary,
                                      activeTrackColor: theme
                                          .colorScheme
                                          .tertiary
                                          .withOpacity(0.3),
                                      inactiveThumbColor: Colors.white
                                          .withOpacity(0.6),
                                      inactiveTrackColor: Colors.white
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Automation Fields (visible when toggle is on)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: automationEnabled ? null : 0,
                              child:
                                  automationEnabled
                                      ? Column(
                                        children: [
                                          const SizedBox(height: 16),

                                          // Start Date Field
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white.withOpacity(0.2),
                                                  Colors.white.withOpacity(0.1),
                                                ],
                                              ),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.3,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                final date = await showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                      selectedStartDate,
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.now().add(
                                                    const Duration(days: 365),
                                                  ),
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: Theme.of(
                                                        context,
                                                      ).copyWith(
                                                        colorScheme: Theme.of(
                                                          context,
                                                        ).colorScheme.copyWith(
                                                          primary:
                                                              theme
                                                                  .colorScheme
                                                                  .tertiary,
                                                          surface:
                                                              theme
                                                                  .colorScheme
                                                                  .onSurface,
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                );
                                                if (date != null) {
                                                  setState(() {
                                                    selectedStartDate = date;
                                                  });
                                                }
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .calendar_today_rounded,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Start Date',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                    0.8,
                                                                  ),
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            '${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}',
                                                            style:
                                                                const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_drop_down_rounded,
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),

                                          // Consumption Rate Field
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Consumption Rate',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showTooltipOverlay(
                                                        context,
                                                        'consumptionRate: Defines by what amount the item is consumed daily. For example, if set to 2, it means 2 items are used per day.',
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 18,
                                                      height: 18,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                        border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        Icons.question_mark,
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              _buildPremiumTextField(
                                                controller:
                                                    consumptionRateController,
                                                label: 'Consumption Rate',
                                                hint: 'Items per day',
                                                keyboardType:
                                                    TextInputType.number,
                                                validator:
                                                    automationEnabled
                                                        ? (value) =>
                                                            value!.isEmpty ||
                                                                    int.tryParse(
                                                                          value,
                                                                        ) ==
                                                                        null
                                                                ? 'Please enter a valid consumption rate'
                                                                : null
                                                        : null,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Alert Threshold',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showTooltipOverlay(
                                                        context,
                                                        'Alert Threshold: Get notified when item count reaches this level. For example, if set to 5, you\'ll be alerted when only 5 items remain.',
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 18,
                                                      height: 18,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                        border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        Icons.question_mark,
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              _buildPremiumTextField(
                                                controller:
                                                    notificationThresholdController,
                                                label: 'alert threshold',
                                                hint: '',
                                                keyboardType:
                                                    TextInputType.number,
                                                validator:
                                                    automationEnabled
                                                        ? (value) =>
                                                            value!.isEmpty ||
                                                                    int.tryParse(
                                                                          value,
                                                                        ) ==
                                                                        null
                                                                ? 'Please enter a valid threshold value'
                                                                : null
                                                        : null,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                      : const SizedBox.shrink(),
                            ),

                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.tertiary,
                                          theme.colorScheme.tertiary
                                              .withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          Navigator.pop(context);
                                          context.read<ListBloc>().add(
                                            AddItemEvent(
                                              groupId: widget.group.uid,
                                              itemName:
                                                  nameController.text.trim(),
                                              count:
                                                  int.tryParse(
                                                    countController.text,
                                                  ) ??
                                                  1,
                                              unit: unitController.text.trim(),
                                              automationEnabled:
                                                  automationEnabled,
                                              automationStartDate:
                                                  automationEnabled
                                                      ? selectedStartDate
                                                      : null,
                                              consumptionRate:
                                                  automationEnabled
                                                      ? int.tryParse(
                                                            consumptionRateController
                                                                .text,
                                                          ) ??
                                                          0
                                                      : 0,
                                              notificationThreshold:
                                                  automationEnabled
                                                      ? int.tryParse(
                                                            notificationThresholdController
                                                                .text,
                                                          ) ??
                                                          0
                                                      : null,
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Add Item',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          ),
    );
  }

  Widget _buildPremiumTextField({
    required TextEditingController controller,
    int? maxLength,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          counterText: maxLength != null ? '' : null,
          hintText: hint,

          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          errorStyle: TextStyle(
            color: Colors.red.shade200,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.8),
              width: 0.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.8),
              width: 0.2,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 8),
            child: Icon(
              _getFieldIcon(label),
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 20,
          ),
        ),
      ),
    );
  }

  IconData _getFieldIcon(String label) {
    switch (label.toLowerCase()) {
      case 'item name':
        return Icons.inventory_2_rounded;
      case 'count':
        return Icons.numbers_rounded;
      case 'unit':
        return Icons.straighten_rounded;
      case 'consumption rate':
        return Icons.trending_down_rounded;
      case 'alert threshold':
        return Icons.notifications_rounded;
      default:
        return Icons.edit_rounded;
    }
  }

  void _showPremiumSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<bool> _showAutomationWarning(
    BuildContext context,
    ThemeData theme,
  ) async {
    if (_dontShowAutomationWarning) return true;

    bool dontShowAgain = false;

    return await showDialog<bool>(
          context: context,
          builder:
              (context) => StatefulBuilder(
                builder:
                    (context, setState) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.tertiary.withOpacity(0.3),
                                    theme.colorScheme.tertiary.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                color: theme.colorScheme.tertiary,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Manual Override',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'This item has automation enabled. Manual changes may interfere with automated inventory tracking. Are you sure you want to proceed?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),

                            // Don't show again checkbox
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Checkbox(
                                      value: dontShowAgain,
                                      onChanged: (value) {
                                        setState(() {
                                          dontShowAgain = value ?? false;
                                        });
                                      },
                                      activeColor: theme.colorScheme.tertiary,
                                      checkColor: Colors.black,
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(0.6),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Don't show this warning again",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.tertiary,
                                          theme.colorScheme.tertiary
                                              .withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        if (dontShowAgain) {
                                          _dontShowAutomationWarning = true;
                                        }
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text(
                                        'Proceed',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              ),
        ) ??
        false;
  }
}

class ItemListView extends StatelessWidget {
  const ItemListView({
    super.key,
    required this.items,
    required this.widget,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onShowAutomationWarning,
  });

  final List<ListEntity>? items;
  final GroupPage widget;
  final Animation<Offset> slideAnimation;
  final Animation<double> fadeAnimation;
  final Future<bool> Function(BuildContext, ThemeData) onShowAutomationWarning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (items!.isEmpty) {
      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.15),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.tertiary.withOpacity(0.3),
                          theme.colorScheme.tertiary.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.inventory_2_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Items Yet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add your first item to start managing inventory',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.tertiary,
                              theme.colorScheme.tertiary.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Inventory Items',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Text(
                          '${items!.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Items List
                Expanded(
                  child: ListView.builder(
                    itemCount: items!.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = items![index];
                      return _buildPremiumItemCard(item, index, theme, context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildPremiumItemCard(
    ListEntity item,
    int index,
    ThemeData theme,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Dismissible(
          key: Key(item.uid),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              _showEditItemDialog(context, item, widget.group.uid);
              return false;
            } else {
              return await _showDeleteConfirmation(context, item, theme);
            }
          },
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.error,
                  theme.colorScheme.error.withOpacity(0.8),
                ],
              ),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.delete_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          secondaryBackground: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.tertiary,
                  theme.colorScheme.tertiary.withOpacity(0.8),
                ],
              ),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Item Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Unit: ${item.unit}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          // Automation Indicator
                          if (item.automationEnabled) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: theme.colorScheme.tertiary.withOpacity(
                                  0.2,
                                ),
                                border: Border.all(
                                  color: theme.colorScheme.tertiary.withOpacity(
                                    0.4,
                                  ),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    color: theme.colorScheme.tertiary
                                        .withOpacity(0.9),
                                    size: 12,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'AUTO',
                                    style: TextStyle(
                                      color: theme.colorScheme.tertiary
                                          .withOpacity(0.9),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Count Controls
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              item.itemCount > 1
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.1),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed:
                              item.itemCount > 1
                                  ? () async {
                                    if (item.automationEnabled) {
                                      final shouldProceed =
                                          await onShowAutomationWarning(
                                            context,
                                            theme,
                                          );
                                      if (!shouldProceed) return;
                                    }
                                    context.read<ListBloc>().add(
                                      EditItemEvent(
                                        groupId: widget.group.uid,
                                        itemId: item.uid,
                                        itemName: item.name,
                                        count: item.itemCount - 1,
                                        unit: item.unit,
                                        automationEnabled:
                                            item.automationEnabled,
                                        consumptionRate: item.consumptionRate,
                                        automationStartDate:
                                            item.automationStartDate,
                                      ),
                                    );
                                  }
                                  : null,
                          icon: Icon(
                            Icons.remove_rounded,
                            color:
                                item.itemCount > 1
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                            size: 18,
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) =>
                                  ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                          child: Text(
                            '${item.itemCount}',
                            key: ValueKey(item.itemCount),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            if (item.automationEnabled) {
                              final shouldProceed =
                                  await onShowAutomationWarning(context, theme);
                              if (!shouldProceed) return;
                            }
                            context.read<ListBloc>().add(
                              EditItemEvent(
                                groupId: widget.group.uid,
                                itemId: item.uid,
                                itemName: item.name,
                                count: item.itemCount + 1,
                                unit: item.unit,
                                automationEnabled: item.automationEnabled,
                                consumptionRate: item.consumptionRate,
                                automationStartDate: item.automationStartDate,
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    ListEntity item,
    ThemeData theme,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.error,
                        theme.colorScheme.error.withOpacity(0.8),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Delete Item',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Are you sure you want to delete "${item.name}"? This action cannot be undone.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  context.read<ListBloc>().add(
                                    DeleteItemEvent(
                                      groupId: widget.group.uid,
                                      itemId: item.uid,
                                    ),
                                  );
                                  Navigator.pop(context, true);
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ) ??
        false;
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
  final consumptionRateController = TextEditingController(
    text: item.consumptionRate?.toString(),
  );
  final notificationThresholdController = TextEditingController(
    text: item.notificationThreshold?.toString(),
  );
  final formKey = GlobalKey<FormState>();
  final theme = Theme.of(buildContext);

  bool automationEnabled = item.automationEnabled;
  DateTime selectedStartDate = item.automationStartDate ?? DateTime.now();

  showDialog(
    context: buildContext,
    barrierDismissible: true,
    builder:
        (context) => StatefulBuilder(
          builder:
              (context, setState) => Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 600),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Edit ${item.name}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Item Name',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),

                              _buildPremiumEditField(
                                controller: nameController,
                                label: '',
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? 'Please enter a name'
                                            : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Count',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildPremiumEditField(
                                      controller: countController,
                                      label: '',
                                      keyboardType: TextInputType.number,
                                      validator:
                                          (value) =>
                                              value!.isEmpty
                                                  ? 'Please enter a count'
                                                  : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Unit',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildPremiumEditField(
                                      maxLength: 7,
                                      controller: unitController,
                                      label: '',
                                      validator:
                                          (value) =>
                                              value!.isEmpty
                                                  ? 'Please enter a unit'
                                                  : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Automation Toggle
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Smart Automation',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Inventory on autopilot',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: automationEnabled,
                                    onChanged: (value) {
                                      setState(() {
                                        automationEnabled = value;
                                      });
                                    },
                                    activeColor: theme.colorScheme.tertiary,
                                    activeTrackColor: theme.colorScheme.tertiary
                                        .withOpacity(0.3),
                                    inactiveThumbColor: Colors.white
                                        .withOpacity(0.6),
                                    inactiveTrackColor: Colors.white
                                        .withOpacity(0.2),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Automation Fields (visible when toggle is on)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: automationEnabled ? null : 0,
                            child:
                                automationEnabled
                                    ? Column(
                                      children: [
                                        const SizedBox(height: 16),

                                        // Start Date Field
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.1),
                                              ],
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () async {
                                              final date = await showDatePicker(
                                                context: context,
                                                initialDate: selectedStartDate,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.now().add(
                                                  const Duration(days: 365),
                                                ),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(
                                                      context,
                                                    ).copyWith(
                                                      colorScheme: Theme.of(
                                                        context,
                                                      ).colorScheme.copyWith(
                                                        primary:
                                                            theme
                                                                .colorScheme
                                                                .tertiary,
                                                        surface:
                                                            theme
                                                                .colorScheme
                                                                .primary,
                                                      ),
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                              );
                                              if (date != null) {
                                                setState(() {
                                                  selectedStartDate = date;
                                                });
                                              }
                                            },
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .calendar_today_rounded,
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Start Date',
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.8,
                                                                ),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          '${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}',
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_drop_down_rounded,
                                                    color: Colors.white
                                                        .withOpacity(0.6),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Consumption Rate Field
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Consumption Rate',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                GestureDetector(
                                                  onTap: () {
                                                    showTooltipOverlay(
                                                      context,
                                                      'consumptionRate: Defines by what amount the item is consumed daily. For example, if set to 2, it means 2 items are used per day.',
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 18,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.4),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.question_mark,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      size: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            _buildPremiumEditField(
                                              controller:
                                                  consumptionRateController,
                                              label: '',

                                              keyboardType:
                                                  TextInputType.number,
                                              validator:
                                                  automationEnabled
                                                      ? (value) =>
                                                          value!.isEmpty ||
                                                                  int.tryParse(
                                                                        value,
                                                                      ) ==
                                                                      null
                                                              ? 'Please enter a valid consumption rate'
                                                              : null
                                                      : null,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Alert Threshold',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                GestureDetector(
                                                  onTap: () {
                                                    showTooltipOverlay(
                                                      context,
                                                      'Alert Threshold: Get notified when item count reaches this level. For example, if set to 5, you\'ll be alerted when only 5 items remain.',
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 18,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.4),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.question_mark,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      size: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            _buildPremiumEditField(
                                              controller:
                                                  notificationThresholdController,
                                              label: '',

                                              keyboardType:
                                                  TextInputType.number,
                                              validator:
                                                  automationEnabled
                                                      ? (value) =>
                                                          value!.isEmpty ||
                                                                  int.tryParse(
                                                                        value,
                                                                      ) ==
                                                                      null
                                                              ? 'Please enter a valid threshold value'
                                                              : null
                                                      : null,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                    : const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.colorScheme.tertiary,
                                        theme.colorScheme.tertiary.withOpacity(
                                          0.8,
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        buildContext.read<ListBloc>().add(
                                          EditItemEvent(
                                            groupId: groupId,
                                            itemId: item.uid,
                                            itemName:
                                                nameController.text.trim(),
                                            count:
                                                int.tryParse(
                                                  countController.text,
                                                ) ??
                                                0,
                                            unit: unitController.text.trim(),
                                            automationEnabled:
                                                automationEnabled,
                                            automationStartDate:
                                                automationEnabled
                                                    ? selectedStartDate
                                                    : null,
                                            consumptionRate:
                                                automationEnabled
                                                    ? int.tryParse(
                                                          consumptionRateController
                                                              .text,
                                                        ) ??
                                                        0
                                                    : 0,
                                            notificationThreshold:
                                                automationEnabled
                                                    ? int.tryParse(
                                                          notificationThresholdController
                                                              .text,
                                                        ) ??
                                                        0
                                                    : null,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text(
                                      'Update',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ),
  );
}

Widget _buildPremiumEditField({
  required TextEditingController controller,
  required String label,
  int? maxLength,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
      ),
      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
    ),
    child: TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      decoration: InputDecoration(
        counterText: maxLength != null ? '' : null,
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
      ),
    ),
  );
}

void _showAddUserDialog(
  BuildContext buildContext,
  String groupId,
  String handle,
) {
  final handleController = TextEditingController();
  UserEntity? foundUser;
  final theme = Theme.of(buildContext);

  showDialog(
    context: buildContext,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return BlocProvider.value(
            value: BlocProvider.of<GroupBloc>(buildContext),
            child: BlocConsumer<GroupBloc, GroupState>(
              listener: (context, state) {
                if (state is UserFoundState) {
                  setState(() {
                    foundUser = state.user;
                  });
                }
                if (state is UserAddedToGroupState) {
                  ScaffoldMessenger.of(buildContext).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.tertiary,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'User added successfully!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.black87,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                  Navigator.pop(dialogContext);
                }
                if (state is GroupErrorState) {
                  setState(() {
                    foundUser = null;
                  });
                  Navigator.pop(dialogContext);
                }
              },
              builder: (context, state) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.person_add_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Add User to Group',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (foundUser == null)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: handleController,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'User Handle',
                                  labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  prefixText: '@',
                                  prefixStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                  suffixIcon: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.tertiary,
                                          theme.colorScheme.tertiary
                                              .withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.search_rounded,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        if (handleController.text.isNotEmpty &&
                                            handleController.text.trim() !=
                                                handle) {
                                          context.read<GroupBloc>().add(
                                            SearchUserByHandleEvent(
                                              handle:
                                                  handleController.text.trim(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),

                          if (state is GroupSearchLoadingState)
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                    child: const Icon(
                                      Icons.search_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Searching...',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (foundUser != null)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.25),
                                    Colors.white.withOpacity(0.15),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.tertiary
                                              .withOpacity(0.3),
                                          theme.colorScheme.tertiary
                                              .withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                    child: SvgPicture.network(
                                      foundUser!.avatarUrl!,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          foundUser!.displayName ?? 'No Name',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '@${foundUser!.userHandle}',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed:
                                        () => Navigator.pop(dialogContext),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient:
                                        foundUser == null
                                            ? LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.1),
                                              ],
                                            )
                                            : LinearGradient(
                                              colors: [
                                                theme.colorScheme.tertiary,
                                                theme.colorScheme.tertiary
                                                    .withOpacity(0.8),
                                              ],
                                            ),
                                  ),
                                  child: TextButton(
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
                                    child: Text(
                                      'Add User',
                                      style: TextStyle(
                                        color:
                                            foundUser == null
                                                ? Colors.white.withOpacity(0.5)
                                                : Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}

void showTooltipOverlay(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder:
        (context) => Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1E3A5F).withOpacity(0.95),
                            const Color(0xFF2D5A87).withOpacity(0.95),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.withOpacity(0.3),
                                  Colors.blue.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: Colors.white.withOpacity(0.9),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              message,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
  );

  overlay.insert(overlayEntry);

  // Auto-remove after 4 seconds
  Future.delayed(const Duration(seconds: 4), () {
    overlayEntry.remove();
  });
}
