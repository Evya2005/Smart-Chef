import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/ai_guard.dart';
import '../../../features/ingestion/views/widgets/ingestion_preview_card.dart';
import '../providers/discovery_provider.dart';

class DiscoveryBasketScreen extends ConsumerStatefulWidget {
  const DiscoveryBasketScreen({super.key});

  @override
  ConsumerState<DiscoveryBasketScreen> createState() =>
      _DiscoveryBasketScreenState();
}

class _DiscoveryBasketScreenState
    extends ConsumerState<DiscoveryBasketScreen> {
  final _ingredientController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(discoveryProvider.notifier).startBuilding();
    });
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<DiscoveryState>(discoveryProvider, (_, next) {
      if (next is DiscoveryDone) {
        final recipeId = next.recipeId;
        ref.read(discoveryProvider.notifier).reset();
        context.go('/recipes/$recipeId');
      }
    });

    final discoveryState = ref.watch(discoveryProvider);
    final notifier = ref.read(discoveryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('סל גילוי'),
      ),
      body: _buildBody(context, discoveryState, notifier),
    );
  }

  Widget _buildBody(
    BuildContext context,
    DiscoveryState discoveryState,
    DiscoveryNotifier notifier,
  ) {
    if (discoveryState is DiscoveryBuilding) {
      return _BuildingView(
        state: discoveryState,
        controller: _ingredientController,
        notifier: notifier,
        onGenerate: () async {
          if (!await requireAiKey(context, ref)) return;
          notifier.generate();
        },
      );
    }

    if (discoveryState is DiscoveryGenerating) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            Gap(16),
            Text(
              'יוצר מתכון מפתיע...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (discoveryState is DiscoveryPreview) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: IngestionPreviewCard(
          recipe: discoveryState.recipe,
          onTitleChanged: (title) => notifier.updatePreview(
            discoveryState.recipe.copyWith(title: title),
          ),
          onTagsChanged: (tags) => notifier.updatePreview(
            discoveryState.recipe.copyWith(tags: tags),
          ),
          onConfirm: notifier.confirmSave,
          onDiscard: () {
            notifier.startBuilding();
          },
        ),
      );
    }

    if (discoveryState is DiscoverySaving) {
      return const Center(child: CircularProgressIndicator());
    }

    if (discoveryState is DiscoveryError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 48,
              ),
              const Gap(16),
              Text(
                discoveryState.message,
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              FilledButton.icon(
                onPressed: notifier.startBuilding,
                icon: const Icon(Icons.refresh),
                label: const Text('נסה שוב'),
              ),
            ],
          ),
        ),
      );
    }

    // Idle — initState will trigger startBuilding shortly
    return const SizedBox.shrink();
  }
}

class _BuildingView extends StatelessWidget {
  const _BuildingView({
    required this.state,
    required this.controller,
    required this.notifier,
    required this.onGenerate,
  });

  final DiscoveryBuilding state;
  final TextEditingController controller;
  final DiscoveryNotifier notifier;
  final VoidCallback onGenerate;

  static const _maxIngredients = 5;

  void _addIngredient() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    notifier.addIngredient(text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final count = state.ingredients.length;
    final canAdd = count < _maxIngredients;
    final canGenerate = count >= 3;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'הוסף מצרכים לסל',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Gap(8),
          Text(
            'בחר 3-5 מצרכים ו-AI יצור עבורך מתכון מפתיע',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: canAdd,
                  decoration: InputDecoration(
                    hintText: canAdd ? 'שם מצרך...' : 'הגעת למקסימום',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: canAdd ? (_) => _addIngredient() : null,
                ),
              ),
              const Gap(8),
              FilledButton(
                onPressed: canAdd ? _addIngredient : null,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const Gap(12),
          if (state.ingredients.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: state.ingredients.asMap().entries.map((e) {
                return Chip(
                  label: Text(e.value),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => notifier.removeIngredient(e.key),
                );
              }).toList(),
            ),
            const Gap(8),
          ],
          Text(
            '$count/$_maxIngredients מצרכים',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          if (!canGenerate && count > 0) ...[
            const Gap(4),
            Text(
              'הוסף לפחות ${3 - count} מצרכים נוספים',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: canGenerate ? onGenerate : null,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('צור מתכון'),
            ),
          ),
        ],
      ),
    );
  }
}
