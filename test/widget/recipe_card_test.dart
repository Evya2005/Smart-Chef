import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_chef/features/recipes/models/recipe_model.dart';
import 'package:smart_chef/features/recipes/views/widgets/recipe_card.dart';

RecipeModel _makeRecipe({
  String title = 'Spaghetti Bolognese',
  List<String> tags = const ['dinner'],
  int activeTime = 20,
  int totalTime = 60,
}) =>
    RecipeModel(
      id: 'test-id',
      userId: 'user-1',
      title: title,
      tags: tags,
      activeTimeMinutes: activeTime,
      totalTimeMinutes: totalTime,
      defaultServings: 4,
      ingredients: const [],
      steps: const [],
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

void main() {
  testWidgets('RecipeCard displays title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipeCard(recipe: _makeRecipe()),
        ),
      ),
    );
    expect(find.text('Spaghetti Bolognese'), findsOneWidget);
  });

  testWidgets('RecipeCard displays active and total time', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipeCard(recipe: _makeRecipe()),
        ),
      ),
    );
    expect(find.textContaining("20 ד׳ פעיל"), findsOneWidget);
    expect(find.textContaining("60 ד׳ סה״כ"), findsOneWidget);
  });

  testWidgets('RecipeCard displays tags as chips', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipeCard(recipe: _makeRecipe(tags: ['vegan', 'quick'])),
        ),
      ),
    );
    expect(find.text('vegan'), findsOneWidget);
    expect(find.text('quick'), findsOneWidget);
  });

  testWidgets('RecipeCard calls onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipeCard(
            recipe: _makeRecipe(),
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(InkWell).first);
    expect(tapped, isTrue);
  });
}
