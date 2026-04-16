import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/models/cook_step_model.dart';
import '../../../shared/models/ingredient_model.dart';
import '../../../shared/models/unit_type.dart';
import '../../../shared/widgets/error_card.dart';
import '../providers/recipe_detail_provider.dart';
import '../providers/recipe_filter_provider.dart';
import '../repositories/recipe_repository.dart';
import '../services/cloudinary_service.dart';
import '../services/recipe_categorizer_service.dart';
import '../../settings/providers/categories_provider.dart';
import '../../settings/providers/user_settings_provider.dart';

class RecipeEditScreen extends ConsumerStatefulWidget {
  const RecipeEditScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends ConsumerState<RecipeEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _activeTimeCtrl;
  late TextEditingController _totalTimeCtrl;
  late TextEditingController _servingsCtrl;
  late Set<String> _selectedTags;

  late List<IngredientModel> _ingredients;
  late List<CookStepModel> _steps;

  String _selectedCategory = AppConstants.defaultCategory;
  bool _autoCategorizingInEdit = false;

  String? _imageUrl;
  XFile? _pickedImage;
  bool _uploadingImage = false;
  final _cloudinary = const CloudinaryService();
  final _imagePicker = ImagePicker();

  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _notesCtrl.dispose();
    _activeTimeCtrl.dispose();
    _totalTimeCtrl.dispose();
    _servingsCtrl.dispose();
    super.dispose();
  }

  void _initialize(dynamic recipe) {
    if (_initialized) return;
    _titleCtrl = TextEditingController(text: recipe.title);
    _descCtrl = TextEditingController(text: recipe.description ?? '');
    _notesCtrl = TextEditingController(text: recipe.notes ?? '');
    _activeTimeCtrl =
        TextEditingController(text: recipe.activeTimeMinutes.toString());
    _totalTimeCtrl =
        TextEditingController(text: recipe.totalTimeMinutes.toString());
    _servingsCtrl =
        TextEditingController(text: recipe.defaultServings.toString());
    _selectedTags = recipe.tags.toSet();
    _selectedCategory = recipe.category; // String, never null
    _ingredients = List.from(recipe.ingredients);
    _steps = List.from(recipe.steps);
    _imageUrl = recipe.imageUrl;
    _initialized = true;
  }

  Future<void> _save(dynamic recipe) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final updated = recipe.copyWith(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        activeTimeMinutes: int.tryParse(_activeTimeCtrl.text) ?? 0,
        totalTimeMinutes: int.tryParse(_totalTimeCtrl.text) ?? 0,
        defaultServings: int.tryParse(_servingsCtrl.text) ?? 1,
        tags: _selectedTags.toList(),
        category: _selectedCategory,
        ingredients: _ingredients,
        steps: _steps,
        imageUrl: _imageUrl,
        updatedAt: DateTime.now(),
      );

      await ref.read(recipeRepositoryProvider).updateRecipe(updated);

      if (mounted) {
        ref.invalidate(recipeDetailProvider(widget.recipeId));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('שגיאה בשמירה: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickAndUpload() async {
    final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    setState(() {
      _pickedImage = picked;
      _uploadingImage = true;
    });
    try {
      final url = await _cloudinary.uploadImage(picked);
      setState(() => _imageUrl = url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('שגיאה בהעלאת תמונה: $e')));
      }
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  Future<void> _autoCategorize(dynamic recipe) async {
    setState(() => _autoCategorizingInEdit = true);
    try {
      final apiKey = ref.read(geminiApiKeyProvider).asData?.value ?? '';
      final cats = ref.read(recipeCategoriesProvider).asData?.value
          ?? AppConstants.kRecipeCategories;
      final cat = await RecipeCategorizerService(apiKey: apiKey, categories: cats)
          .categorize(recipe);
      if (mounted) setState(() => _selectedCategory = cat);
    } catch (_) {
      // silently ignore — user can pick manually
    } finally {
      if (mounted) setState(() => _autoCategorizingInEdit = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeDetailProvider(widget.recipeId));

    return recipeAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('עריכת מתכון')),
        body: Center(child: ErrorCard(message: e.toString())),
      ),
      data: (recipe) {
        _initialize(recipe);
        final dynamicCategories = ref.watch(recipeCategoriesProvider)
            .asData?.value ?? AppConstants.kRecipeCategories;
        return Scaffold(
          appBar: AppBar(
            title: const Text('עריכת מתכון'),
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
                  onPressed: () => _save(recipe),
                  child: const Text('שמור',
                      style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ImagePickerSection(
                  imageUrl: _imageUrl,
                  pickedImage: _pickedImage,
                  uploading: _uploadingImage,
                  onPick: _pickAndUpload,
                  onRemove: () => setState(() {
                    _imageUrl = null;
                    _pickedImage = null;
                  }),
                ),
                const Gap(12),
                TextFormField(
                  controller: _titleCtrl,
                  decoration:
                      const InputDecoration(labelText: 'שם המתכון *'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'שדה חובה' : null,
                ),
                const Gap(12),
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(labelText: 'תיאור'),
                  maxLines: 3,
                ),
                const Gap(12),
                TextFormField(
                  controller: _notesCtrl,
                  decoration: const InputDecoration(labelText: 'הערות'),
                  maxLines: 4,
                ),
                const Gap(12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _activeTimeCtrl,
                        decoration: const InputDecoration(
                            labelText: 'זמן פעיל (דקות)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: TextFormField(
                        controller: _totalTimeCtrl,
                        decoration: const InputDecoration(
                            labelText: 'זמן כולל (דקות)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                TextFormField(
                  controller: _servingsCtrl,
                  decoration: const InputDecoration(
                      labelText: 'מספר מנות ברירת מחדל'),
                  keyboardType: TextInputType.number,
                ),
                const Gap(12),
                Text(
                  'תגיות',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Gap(6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: kAllTags.map((tag) {
                    final selected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tagLabel(tag)),
                      selected: selected,
                      onSelected: (_) => setState(() {
                        if (selected) {
                          _selectedTags.remove(tag);
                        } else {
                          _selectedTags.add(tag);
                        }
                      }),
                    );
                  }).toList(),
                ),
                const Gap(16),
                Row(
                  children: [
                    Text(
                      'קטגוריה',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Spacer(),
                    if (_autoCategorizingInEdit)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      TextButton.icon(
                        onPressed: () => _autoCategorize(recipe),
                        icon: const Icon(Icons.auto_awesome, size: 16),
                        label: const Text('סיווג אוטומטי'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: const TextStyle(fontSize: 13),
                        ),
                      ),
                  ],
                ),
                const Gap(6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: dynamicCategories.map((cat) {
                    final selected = _selectedCategory == cat;
                    return FilterChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (_) => setState(() {
                        _selectedCategory = cat;
                      }),
                    );
                  }).toList(),
                ),
                const Gap(24),
                _SectionHeader(
                  title: 'מצרכים',
                  onAdd: () => setState(() {
                    _ingredients.add(const IngredientModel(
                      name: '',
                      quantity: 1,
                      unit: UnitType.none,
                    ));
                  }),
                ),
                const Gap(8),
                ..._ingredients.asMap().entries.map(
                  (entry) => _IngredientRow(
                    key: ValueKey('ingredient_${entry.key}'),
                    ingredient: entry.value,
                    onChanged: (updated) => setState(
                        () => _ingredients[entry.key] = updated),
                    onRemove: () =>
                        setState(() => _ingredients.removeAt(entry.key)),
                  ),
                ),
                const Gap(24),
                _SectionHeader(
                  title: 'שלבי הכנה',
                  onAdd: () => setState(() {
                    _steps.add(CookStepModel(
                      stepNumber: _steps.length + 1,
                      instruction: '',
                    ));
                  }),
                ),
                const Gap(8),
                ..._steps.asMap().entries.map(
                  (entry) => _StepRow(
                    key: ValueKey('step_${entry.key}'),
                    step: entry.value,
                    onChanged: (updated) =>
                        setState(() => _steps[entry.key] = updated),
                    onRemove: () => setState(() {
                      _steps.removeAt(entry.key);
                      for (var i = 0; i < _steps.length; i++) {
                        _steps[i] =
                            _steps[i].copyWith(stepNumber: i + 1);
                      }
                    }),
                  ),
                ),
                const Gap(40),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ImagePickerSection extends StatelessWidget {
  const _ImagePickerSection({
    required this.imageUrl,
    required this.pickedImage,
    required this.uploading,
    required this.onPick,
    required this.onRemove,
  });

  final String? imageUrl;
  final XFile? pickedImage;
  final bool uploading;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (uploading) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final hasImage = pickedImage != null || imageUrl != null;

    if (hasImage) {
      final imageWidget = pickedImage != null
          ? Image.file(File(pickedImage!.path),
              height: 200, width: double.infinity, fit: BoxFit.cover)
          : Image.network(imageUrl!,
              height: 200, width: double.infinity, fit: BoxFit.cover);

      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageWidget,
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: onPick,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('שנה תמונה'),
              ),
              const Gap(8),
              OutlinedButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('הסר'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined,
                size: 40, color: Theme.of(context).colorScheme.outline),
            const Gap(8),
            TextButton(
              onPressed: onPick,
              child: const Text('הוסף תמונה'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onAdd});
  final String title;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('הוסף'),
        ),
      ],
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    super.key,
    required this.ingredient,
    required this.onChanged,
    required this.onRemove,
  });

  final IngredientModel ingredient;
  final ValueChanged<IngredientModel> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: ingredient.name,
                    decoration: const InputDecoration(
                        labelText: 'שם', isDense: true),
                    onChanged: (v) =>
                        onChanged(ingredient.copyWith(name: v)),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: TextFormField(
                    initialValue: ingredient.quantity == 0
                        ? ''
                        : ingredient.quantity.toString(),
                    decoration: const InputDecoration(
                        labelText: 'כמות', isDense: true),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => onChanged(
                        ingredient.copyWith(
                            quantity: double.tryParse(v) ?? 0)),
                  ),
                ),
                const Gap(8),
                DropdownButton<UnitType>(
                  value: ingredient.unit,
                  underline: const SizedBox.shrink(),
                  isDense: true,
                  items: UnitType.values
                      .map((u) => DropdownMenuItem(
                            value: u,
                            child: Text(u.displayLabel.isEmpty
                                ? '—'
                                : u.displayLabel),
                          ))
                      .toList(),
                  onChanged: (u) =>
                      onChanged(ingredient.copyWith(unit: u!)),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatefulWidget {
  const _StepRow({
    super.key,
    required this.step,
    required this.onChanged,
    required this.onRemove,
  });

  final CookStepModel step;
  final ValueChanged<CookStepModel> onChanged;
  final VoidCallback onRemove;

  @override
  State<_StepRow> createState() => _StepRowState();
}

class _StepRowState extends State<_StepRow> {
  late bool _showTimer;

  @override
  void initState() {
    super.initState();
    _showTimer = widget.step.timerSeconds != null;
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  child: Text('${step.stepNumber}',
                      style: const TextStyle(fontSize: 12)),
                ),
                const Gap(8),
                Expanded(
                  child: TextFormField(
                    initialValue: step.instruction,
                    decoration: const InputDecoration(
                      labelText: 'הוראה',
                      isDense: true,
                    ),
                    maxLines: 3,
                    onChanged: (v) =>
                        widget.onChanged(step.copyWith(instruction: v)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            const Gap(4),
            if (!_showTimer)
              TextButton.icon(
                onPressed: () {
                  setState(() => _showTimer = true);
                  widget.onChanged(step.copyWith(timerSeconds: 0));
                },
                icon: const Icon(Icons.timer_outlined, size: 16),
                label: const Text('הוסף טיימר'),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(fontSize: 13),
                ),
              )
            else
              _TimerEditor(
                timerSeconds: step.timerSeconds ?? 0,
                timerLabel: step.timerLabel,
                onChanged: (seconds, label) {
                  widget.onChanged(
                      step.copyWith(timerSeconds: seconds, timerLabel: label));
                },
                onRemove: () {
                  setState(() => _showTimer = false);
                  widget.onChanged(
                      step.copyWith(timerSeconds: null, timerLabel: null));
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _TimerEditor extends StatefulWidget {
  const _TimerEditor({
    required this.timerSeconds,
    required this.timerLabel,
    required this.onChanged,
    required this.onRemove,
  });

  final int timerSeconds;
  final String? timerLabel;
  final void Function(int seconds, String? label) onChanged;
  final VoidCallback onRemove;

  @override
  State<_TimerEditor> createState() => _TimerEditorState();
}

class _TimerEditorState extends State<_TimerEditor> {
  late final TextEditingController _minutesCtrl;
  late final TextEditingController _secondsCtrl;
  late final TextEditingController _labelCtrl;

  @override
  void initState() {
    super.initState();
    final mins = widget.timerSeconds ~/ 60;
    final secs = widget.timerSeconds % 60;
    _minutesCtrl = TextEditingController(text: mins > 0 ? '$mins' : '');
    _secondsCtrl = TextEditingController(text: secs > 0 ? '$secs' : '');
    _labelCtrl = TextEditingController(text: widget.timerLabel ?? '');
  }

  @override
  void dispose() {
    _minutesCtrl.dispose();
    _secondsCtrl.dispose();
    _labelCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    final mins = int.tryParse(_minutesCtrl.text) ?? 0;
    final secs = int.tryParse(_secondsCtrl.text) ?? 0;
    final label = _labelCtrl.text.trim().isEmpty ? null : _labelCtrl.text.trim();
    widget.onChanged(mins * 60 + secs, label);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer, size: 16, color: colorScheme.secondary),
              const Gap(4),
              Text('טיימר',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary)),
              const Spacer(),
              GestureDetector(
                onTap: widget.onRemove,
                child: Icon(Icons.close, size: 16, color: colorScheme.outline),
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              SizedBox(
                width: 64,
                child: TextFormField(
                  controller: _minutesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'דקות',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => _notify(),
                ),
              ),
              const Gap(8),
              SizedBox(
                width: 64,
                child: TextFormField(
                  controller: _secondsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'שניות',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => _notify(),
                ),
              ),
              const Gap(8),
              Expanded(
                child: TextFormField(
                  controller: _labelCtrl,
                  decoration: const InputDecoration(
                    labelText: 'תיאור (אופציונלי)',
                    isDense: true,
                  ),
                  onChanged: (_) => _notify(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
