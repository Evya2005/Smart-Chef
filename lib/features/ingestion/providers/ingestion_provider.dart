import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/repositories/auth_repository.dart';
import '../../recipes/models/recipe_model.dart';
import '../../recipes/repositories/recipe_repository.dart';
import '../../recipes/services/cloudinary_service.dart';
import '../../settings/providers/user_settings_provider.dart';
import '../services/gemini_service.dart';
import '../services/pdf_processor_service.dart';
import '../services/social_media_service.dart';
import '../services/url_scraper_service.dart';

part 'ingestion_provider.g.dart';

// ─── State ────────────────────────────────────────────────────────────────────

sealed class IngestionState {
  const IngestionState();
}

class IngestionIdle extends IngestionState {
  const IngestionIdle();
}

class IngestionLoading extends IngestionState {
  const IngestionLoading(this.message);
  final String message;
}

class IngestionPreview extends IngestionState {
  const IngestionPreview(this.recipe);
  final RecipeModel recipe;
}

class IngestionSaving extends IngestionState {
  const IngestionSaving();
}

class IngestionDone extends IngestionState {
  const IngestionDone(this.recipeId);
  final String recipeId;
}

class IngestionError extends IngestionState {
  const IngestionError(this.message);
  final String message;
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

@riverpod
class IngestionNotifier extends _$IngestionNotifier {
  @override
  IngestionState build() => const IngestionIdle();

  GeminiService get _gemini {
    final apiKey = ref.read(geminiApiKeyProvider).asData?.value ?? '';
    return GeminiService(apiKey: apiKey);
  }

  PdfProcessorService get _pdf => const PdfProcessorService();
  UrlScraperService get _scraper => const UrlScraperService();
  CloudinaryService get _cloudinary => const CloudinaryService();

  Future<void> parseText(String text) async {
    state = const IngestionLoading('מנתח מתכון עם AI...');
    try {
      final recipe = await _gemini.parseFromText(text);
      state = IngestionPreview(recipe.copyWith(sourceType: 'text'));
    } catch (e) {
      state = IngestionError(e.toString());
    }
  }

  Future<void> parseImage(Uint8List imageBytes) =>
      parseImages([imageBytes]);

  Future<void> parseImages(List<Uint8List> imageBytesList) async {
    state = const IngestionLoading('קורא מתכון מתמונה...');
    try {
      final recipe =
          await _gemini.parseFromMultipleImages(imageBytesList);
      state = IngestionPreview(recipe.copyWith(sourceType: 'image'));
    } catch (e) {
      state = IngestionError(e.toString());
    }
  }

  Future<void> parsePdf(Uint8List pdfBytes) async {
    state = const IngestionLoading('מחלץ טקסט מ-PDF...');
    try {
      final text = await _pdf.extractText(pdfBytes);
      state = const IngestionLoading('מנתח מתכון עם AI...');
      final recipe = await _gemini.parseFromPdf(text);
      state = IngestionPreview(recipe.copyWith(sourceType: 'pdf'));
    } catch (e) {
      state = IngestionError(e.toString());
    }
  }

  Future<void> parseUrl(String url) async {
    state = const IngestionLoading('מאחזר קישור...');
    try {
      // Scrape page text and image URL in one pass.
      final scrapeResult = await _scraper.scrapeWithImage(url);

      state = const IngestionLoading('מנתח מתכון עם AI...');
      var recipe = await _gemini.parseFromText(scrapeResult.text);
      recipe = recipe.copyWith(sourceUrl: url, sourceType: 'url');

      // Attach image: prefer scraped image, fall back to Gemini generation.
      if (scrapeResult.imageUrl != null) {
        state = const IngestionLoading('שומר תמונת מתכון...');
        try {
          final imageBytes = await _downloadImage(scrapeResult.imageUrl!);
          if (imageBytes != null) {
            final cloudinaryUrl =
                await _cloudinary.uploadImageBytes(imageBytes, 'image/jpeg');
            recipe = recipe.copyWith(imageUrl: cloudinaryUrl);
          }
        } catch (_) {
          // Non-fatal — continue without image.
        }
      } else {
        state = const IngestionLoading('מייצר תמונה למתכון...');
        try {
          final ingredientNames =
              recipe.ingredients.map((i) => i.name).toList();
          final generatedBytes = await _gemini.generateRecipeImage(
              recipe.title, ingredientNames);
          if (generatedBytes != null) {
            final cloudinaryUrl = await _cloudinary.uploadImageBytes(
                generatedBytes, 'image/jpeg');
            recipe = recipe.copyWith(imageUrl: cloudinaryUrl);
          }
        } catch (_) {
          // Non-fatal — continue without image.
        }
      }

      state = IngestionPreview(recipe);
    } catch (e) {
      state = IngestionError(e.toString());
    }
  }

  /// Downloads image bytes from [url]. Returns null on any failure.
  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) return response.bodyBytes;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> parseSocialUrl(String url, String accessToken) async {
    state = const IngestionLoading('מאחזר פוסט מרשת חברתית...');
    try {
      final text =
          await const SocialMediaService().fetchPostText(url, accessToken);
      final recipe = await _gemini.parseFromText(text);
      state = IngestionPreview(recipe.copyWith(sourceType: 'social'));
    } catch (e) {
      state = IngestionError(e.toString());
    }
  }

  void updatePreview(RecipeModel updated) {
    if (state is IngestionPreview) {
      state = IngestionPreview(updated);
    }
  }

  Future<void> confirmSave() async {
    final preview = state;
    if (preview is! IngestionPreview) return;

    state = const IngestionSaving();
    try {
      final uid = ref.read(authRepositoryProvider).currentUser?.uid;
      if (uid == null) throw Exception('המשתמש אינו מחובר.');

      final recipe = preview.recipe.copyWith(userId: uid);
      final id =
          await ref.read(recipeRepositoryProvider).saveRecipe(recipe);
      state = IngestionDone(id);
    } catch (e) {
      state = IngestionError(e.toString());
    }
  }

  void reset() => state = const IngestionIdle();
}
