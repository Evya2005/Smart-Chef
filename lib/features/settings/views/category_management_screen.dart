import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../providers/categories_provider.dart';
import '../repositories/categories_repository.dart';

class CategoryManagementScreen extends ConsumerStatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  ConsumerState<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState
    extends ConsumerState<CategoryManagementScreen> {
  List<String>? _categories;
  final _addCtrl = TextEditingController();
  bool _saving = false;
  bool _seeded = false;

  @override
  void dispose() {
    _addCtrl.dispose();
    super.dispose();
  }

  void _seed(List<String> cats) {
    if (_seeded) return;
    _categories = List.from(cats);
    _seeded = true;
  }

  void _addCategory() {
    final name = _addCtrl.text.trim();
    if (name.isEmpty) return;
    if (_categories!.contains(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('קטגוריה זו כבר קיימת')),
      );
      return;
    }
    setState(() {
      _categories!.add(name);
      _addCtrl.clear();
    });
  }

  void _deleteCategory(String cat) {
    setState(() => _categories!.remove(cat));
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(categoriesRepositoryProvider)
          .saveCategories(_categories!);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('שגיאה בשמירה: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final catsAsync = ref.watch(recipeCategoriesProvider);

    return catsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('ניהול קטגוריות')),
        body: Center(child: Text('שגיאה: $e')),
      ),
      data: (cats) {
        _seed(cats);
        final categories = _categories!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('ניהול קטגוריות'),
            actions: [
              if (_saving)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                TextButton(
                  onPressed: _save,
                  child: const Text('שמור',
                      style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: categories.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final item = categories.removeAt(oldIndex);
                      categories.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isDefault = cat == AppConstants.defaultCategory;
                    return ListTile(
                      key: ValueKey(cat),
                      leading: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                      title: Text(cat),
                      trailing: isDefault
                          ? Tooltip(
                              message: 'קטגוריית ברירת מחדל — לא ניתן למחוק',
                              child: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).colorScheme.outline,
                                size: 20,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Theme.of(context).colorScheme.error,
                              tooltip: 'מחק קטגוריה',
                              onPressed: () => _deleteCategory(cat),
                            ),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _addCtrl,
                        decoration: const InputDecoration(
                          labelText: 'קטגוריה חדשה',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addCategory(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.tonal(
                      onPressed: _addCategory,
                      child: const Text('הוסף'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
