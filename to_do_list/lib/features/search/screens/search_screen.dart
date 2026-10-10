import 'package:flutter/material.dart';
import '../../../core/mock/mock_tasks.dart';
import '../../../core/models/task_category.dart';
import '../../../core/models/task_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/category_badge.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/filter_tabs.dart';
import '../../../core/widgets/floating_bottom_navigation.dart';
import '../../../core/widgets/sticker_search_bar.dart';
import '../../../core/widgets/task_card.dart';

enum SearchStateVariant {
  initial,
  results,
  empty,
}

class SearchScreen extends StatefulWidget {
  final SearchStateVariant initialVariant;
  final VoidCallback? onCancel;
  final ValueChanged<TaskModel>? onTaskTap;
  final ValueChanged<NavigationTab>? onNavTabChanged;

  const SearchScreen({
    super.key,
    this.initialVariant = SearchStateVariant.results,
    this.onCancel,
    this.onTaskTap,
    this.onNavTabChanged,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late TaskFilterTab _selectedScope;
  TaskCategory _selectedCategory = TaskCategory.study;
  late SearchStateVariant _currentVariant;

  @override
  void initState() {
    super.initState();
    _currentVariant = widget.initialVariant;
    _selectedScope = TaskFilterTab.all;

    String initialQuery = '';
    if (_currentVariant == SearchStateVariant.results) {
      initialQuery = 'Flutter';
    } else if (_currentVariant == SearchStateVariant.empty) {
      initialQuery = 'cactus';
    }

    _searchController = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onClear() {
    _searchController.clear();
    setState(() {
      _currentVariant = SearchStateVariant.initial;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                slivers: [
                  // Top Header & Controls
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageInset,
                        AppSpacing.s16,
                        AppSpacing.pageInset,
                        AppSpacing.s12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Search Title + Cancel
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('Search', style: AppTypography.h1)),
                              GestureDetector(
                                onTap: widget.onCancel,
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  'Cancel',
                                  style: AppTypography.h3.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          // Search Input Field
                          StickerSearchBar(
                            controller: _searchController,
                            hintText: 'Search your tasks',
                            onClear: _onClear,
                            onChanged: (val) {
                              setState(() {
                                if (val.isEmpty) {
                                  _currentVariant = SearchStateVariant.initial;
                                } else if (val.toLowerCase().contains('cactus')) {
                                  _currentVariant = SearchStateVariant.empty;
                                } else {
                                  _currentVariant = SearchStateVariant.results;
                                }
                              });
                            },
                          ),
                          const SizedBox(height: AppSpacing.s12),
                          // Scope Filter Tabs (All / Today / Upcoming)
                          FilterTabs(
                            selectedTab: _selectedScope,
                            onTabSelected: (tab) {
                              setState(() => _selectedScope = tab);
                            },
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          // Category Filter Line
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: AppSpacing.s8,
                            runSpacing: AppSpacing.s8,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Within category', style: AppTypography.body),
                                  const SizedBox(width: AppSpacing.s8),
                                  CategoryBadge(
                                    category: _selectedCategory,
                                    isSelected: true,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Cycle category for demo
                                    final cats = [TaskCategory.study, TaskCategory.work, TaskCategory.personal, TaskCategory.health];
                                    final nextIdx = (cats.indexOf(_selectedCategory) + 1) % cats.length;
                                    _selectedCategory = cats[nextIdx];
                                  });
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  'Change',
                                  style: AppTypography.h3.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          // Matches Counter (if results active)
                          if (_currentVariant == SearchStateVariant.results)
                            Text(
                              _selectedScope == TaskFilterTab.upcoming
                                  ? '1 match · Upcoming · ${_selectedCategory.label}'
                                  : '3 matches · ${_selectedScope.title} · ${_selectedCategory.label}',
                              style: AppTypography.metadata,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Results / Empty State / Initial
                  _buildResultsSliver(),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 120),
                  ),
                ],
              ),
            ),

            // Fixed Bottom Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingBottomNavigation(
                currentTab: NavigationTab.tasks,
                onTabChanged: (tab) => widget.onNavTabChanged?.call(tab),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSliver() {
    if (_currentVariant == SearchStateVariant.empty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s24),
          child: EmptyState(
            title: 'No little things found.',
            description:
                'No ${_selectedCategory.label} task in ${_selectedScope.title} matches "${_searchController.text}". Try another word or change your scope.',
            buttonLabel: 'Clear search',
            onButtonPressed: _onClear,
          ),
        ),
      );
    }

    if (_currentVariant == SearchStateVariant.initial) {
      return const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      );
    }

    // Results variant
    final List<TaskModel> matches = _selectedScope == TaskFilterTab.upcoming
        ? [MockTasks.taskBuildUI]
        : [
            MockTasks.taskFinishFlutter,
            MockTasks.taskReadDocs,
            MockTasks.taskBuildUI,
          ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageInset),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final task = matches[index];
            return TaskCard(
              task: task,
              onTap: () => widget.onTaskTap?.call(task),
            );
          },
          childCount: matches.length,
        ),
      ),
    );
  }
}
