import '../../../shared/models/unit_type.dart';
import '../models/recipe_model.dart';

class RecipeCardService {
  const RecipeCardService();

  String generateCard(RecipeModel recipe, {String? authorName}) {
    final buffer = StringBuffer();

    buffer.writeln('*${recipe.title}*');
    if (authorName != null && authorName.isNotEmpty) {
      buffer.writeln('_$authorName גרסת חתימה_');
    }
    buffer.writeln();

    buffer.writeln('*מצרכים:*');
    for (final ing in recipe.ingredients) {
      final qty = _formatQty(ing.quantity);
      final unit = ing.unit == UnitType.none ? '' : ' ${ing.unit.displayLabel}';
      final prep = ing.prepNote != null ? ' (${ing.prepNote})' : '';
      buffer.writeln('• $qty$unit ${ing.name}$prep');
    }
    buffer.writeln();

    buffer.writeln('*הוראות הכנה:*');
    for (final step in recipe.steps) {
      buffer.writeln('*${step.stepNumber}.* ${step.instruction}');
    }
    buffer.writeln();

    buffer.write('_📱 הוכן עם Smart Chef_');

    return buffer.toString();
  }

  String _formatQty(double qty) {
    if (qty == qty.truncateToDouble()) return qty.toInt().toString();
    return qty.toStringAsFixed(1);
  }
}
