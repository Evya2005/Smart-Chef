import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/ai_guard.dart';
import '../../../shared/widgets/error_card.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../providers/ingestion_provider.dart';
import 'widgets/ingestion_preview_card.dart';

class GenerateRecipeScreen extends ConsumerStatefulWidget {
  const GenerateRecipeScreen({super.key});

  @override
  ConsumerState<GenerateRecipeScreen> createState() =>
      _GenerateRecipeScreenState();
}

class _GenerateRecipeScreenState extends ConsumerState<GenerateRecipeScreen> {
  final _ingredientCtrl = TextEditingController();
  final List<String> _chips = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ingestionProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _ingredientCtrl.dispose();
    super.dispose();
  }

  void _addIngredients(String text) {
    final parts = text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);
    setState(() {
      for (final part in parts) {
        if (!_chips.contains(part)) _chips.add(part);
      }
    });
    _ingredientCtrl.clear();
  }

  void _removeChip(int index) => setState(() => _chips.removeAt(index));

  Future<void> _generate() async {
    if (!await requireAiKey(context, ref)) return;
    if (!mounted) return;
    if (_chips.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('יש להוסיף לפחות רכיב אחד.')),
      );
      return;
    }
    await ref.read(ingestionProvider.notifier).generateFromIngredients(_chips);
  }

  @override
  Widget build(BuildContext context) {
    final ingestionState = ref.watch(ingestionProvider);

    ref.listen(ingestionProvider, (_, next) {
      if (next is IngestionDone) {
        ref.read(ingestionProvider.notifier).reset();
        context.go('/recipes/${next.recipeId}');
      }
    });

    final isIdle = ingestionState is IngestionIdle;
    final isError = ingestionState is IngestionError;
    final isPreview = ingestionState is IngestionPreview;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // ── Top bar ──────────────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.line),
                          ),
                          child: const Icon(Icons.close,
                              size: 18, color: AppColors.ink),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'צור מתכון',
                            style: GoogleFonts.assistant(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ink2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                // ── Hero section ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'מה יש לך\nבמטבח?',
                              style: GoogleFonts.sourceSerif4(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ink,
                                height: 1.1,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                          const Gap(10),
                          // AI badge pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 11, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.terracottaSoft,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_awesome,
                                    size: 12, color: AppColors.terracotta),
                                const SizedBox(width: 5),
                                Text(
                                  'AI יוצר מתכון',
                                  style: GoogleFonts.assistant(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                    color: AppColors.terracotta,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(6),
                      Text(
                        'הזן רכיבים ו-AI יבנה מתכון מושלם בשבילך',
                        style: GoogleFonts.assistant(
                          fontSize: 15,
                          color: AppColors.ink2,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Ingredient input section ──────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'הרכיבים שלך',
                        style: GoogleFonts.assistant(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink2,
                        ),
                      ),
                      const Gap(8),
                      TextField(
                        controller: _ingredientCtrl,
                        textInputAction: TextInputAction.done,
                        onSubmitted: _addIngredients,
                        decoration: InputDecoration(
                          hintText: 'הוסף רכיב ולחץ Enter',
                          hintStyle: GoogleFonts.assistant(
                            color: AppColors.ink3,
                            fontSize: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add,
                                color: AppColors.terracotta),
                            onPressed: () =>
                                _addIngredients(_ingredientCtrl.text),
                          ),
                        ),
                      ),
                      if (_chips.isNotEmpty) ...[
                        const Gap(12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: List.generate(_chips.length, (i) {
                            return Chip(
                              label: Text(
                                _chips[i],
                                style: GoogleFonts.assistant(
                                  fontSize: 13,
                                  color: AppColors.terracotta,
                                ),
                              ),
                              backgroundColor: AppColors.terracottaSoft,
                              deleteIconColor: AppColors.terracotta,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              side: BorderSide.none,
                              onDeleted: () => _removeChip(i),
                            );
                          }),
                        ),
                      ],
                    ],
                  ),
                ),

                // ── Error ─────────────────────────────────────────────
                if (isError) ...[
                  const Gap(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ErrorCard(
                      message: ingestionState.message,
                      onRetry: _generate,
                    ),
                  ),
                ],

                // ── Preview card ──────────────────────────────────────
                if (isPreview) ...[
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: IngestionPreviewCard(
                      recipe: ingestionState.recipe,
                      onTitleChanged: (title) => ref
                          .read(ingestionProvider.notifier)
                          .updatePreview(
                              ingestionState.recipe.copyWith(title: title)),
                      onTagsChanged: (tags) => ref
                          .read(ingestionProvider.notifier)
                          .updatePreview(
                              ingestionState.recipe.copyWith(tags: tags)),
                      onConfirm: () =>
                          ref.read(ingestionProvider.notifier).confirmSave(),
                      onDiscard: () =>
                          ref.read(ingestionProvider.notifier).reset(),
                    ),
                  ),
                ],

                // ── CTA ───────────────────────────────────────────────
                if (isIdle || isError)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
                    child: FilledButton.icon(
                      onPressed: _generate,
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text('צור מתכון'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  )
                else
                  const Gap(40),
              ],
            ),
          ),
          if (ingestionState is IngestionLoading)
            LoadingOverlay(message: ingestionState.message),
          if (ingestionState is IngestionSaving)
            const LoadingOverlay(message: 'שומר מתכון...'),
        ],
      ),
    );
  }
}
