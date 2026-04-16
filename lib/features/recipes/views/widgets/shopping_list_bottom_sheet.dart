import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../shared/models/ingredient_model.dart';
import '../../models/recipe_model.dart';
import '../../services/shopping_list_service.dart';

// ─── Keep export helper ───────────────────────────────────────────────────────

const _keepChannel = MethodChannel('com.smartchef/keep');

Future<void> _exportToKeep(
  String title,
  List<String> items,
  String fallbackText,
) async {
  if (Platform.isAndroid) {
    try {
      final launched = await _keepChannel.invokeMethod<bool>(
        'createChecklist',
        {'title': title, 'items': items},
      );
      if (launched == true) return;
    } catch (_) {
      // Keep not installed or intent failed — fall through.
    }
  }
  await Share.share(fallbackText, subject: title);
}

// ─── Single-recipe sheet ──────────────────────────────────────────────────────

class ShoppingListBottomSheet extends StatelessWidget {
  const ShoppingListBottomSheet({
    super.key,
    required this.ingredients,
    required this.servings,
    required this.recipeTitle,
  });

  final List<IngredientModel> ingredients;
  final int servings;
  final String recipeTitle;

  static Future<void> show(
    BuildContext context, {
    required List<IngredientModel> ingredients,
    required int servings,
    required String recipeTitle,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ShoppingListBottomSheet(
        ingredients: ingredients,
        servings: servings,
        recipeTitle: recipeTitle,
      ),
    );
  }

  static Future<void> showForPlan(
    BuildContext context, {
    required List<({RecipeModel recipe, int servings})> entries,
    required String planTitle,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          _PlanShoppingListSheet(entries: entries, planTitle: planTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    const service = ShoppingListService();
    final text = service.generate(ingredients, servings, recipeTitle);
    final items = service.generateItemList(ingredients);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Text(
                    'רשימת קניות',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFBBC04),
                      foregroundColor: Colors.black87,
                    ),
                    icon: const Icon(Icons.checklist),
                    label: const Text('Google Keep'),
                    onPressed: () => _exportToKeep(
                      'קניות — $recipeTitle',
                      items,
                      text,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: _PreviewCard(text: text),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Multi-recipe (plan) sheet ────────────────────────────────────────────────

class _PlanShoppingListSheet extends StatelessWidget {
  const _PlanShoppingListSheet({
    required this.entries,
    required this.planTitle,
  });

  final List<({RecipeModel recipe, int servings})> entries;
  final String planTitle;

  @override
  Widget build(BuildContext context) {
    const service = ShoppingListService();
    final text = service.generateForPlan(entries, planTitle);
    final items = service.generateItemListForPlan(entries);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.shopping_cart_outlined),
                  const Gap(8),
                  Text(
                    'רשימת קניות לארוחה',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFBBC04),
                      foregroundColor: Colors.black87,
                    ),
                    icon: const Icon(Icons.checklist),
                    label: const Text('Google Keep'),
                    onPressed: () => _exportToKeep(
                      'קניות — $planTitle',
                      items,
                      text,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: _PreviewCard(text: text),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Shared preview widget ────────────────────────────────────────────────────

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
