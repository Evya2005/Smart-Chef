import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/share_intent_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/ai_guard.dart';
import '../../../features/settings/providers/user_settings_provider.dart';
import '../../../shared/widgets/error_card.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../providers/ingestion_provider.dart';
import '../services/url_scraper_service.dart';
import 'widgets/ingestion_preview_card.dart';
import 'widgets/input_source_picker.dart';

class IngestionScreen extends ConsumerStatefulWidget {
  const IngestionScreen({super.key});

  @override
  ConsumerState<IngestionScreen> createState() => _IngestionScreenState();
}

class _IngestionScreenState extends ConsumerState<IngestionScreen> {
  InputSource _source = InputSource.url;
  final _textCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  final List<Uint8List> _images = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _handleSharedIntent());
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSharedIntent() async {
    final payload = ref.read(shareIntentProvider);
    if (payload == null) return;
    ref.read(shareIntentProvider.notifier).consume();

    switch (payload) {
      case SharedText(:final value):
        final url = _extractUrl(value);
        if (url != null) {
          setState(() {
            _source = InputSource.url;
            _urlCtrl.text = url;
          });
        } else if (Uri.tryParse(value)?.hasScheme == true) {
          setState(() {
            _source = InputSource.url;
            _urlCtrl.text = value;
          });
        } else {
          setState(() {
            _source = InputSource.text;
            _textCtrl.text = value;
          });
        }
        await _parse();

      case SharedImages(:final bytes):
        _images.clear();
        _images.addAll(bytes);
        setState(() => _source = InputSource.image);
        await _parse();
    }
  }

  String? _extractUrl(String text) =>
      RegExp(r'https?://[^\s]+').firstMatch(text)?.group(0);

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;
    final bytes = await Future.wait(picked.map((f) => f.readAsBytes()));
    setState(() => _images.addAll(bytes));
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _images.add(bytes));
  }

  void _removeImage(int index) => setState(() => _images.removeAt(index));

  Future<void> _parse() async {
    if (!await requireAiKey(context, ref)) return;
    final notifier = ref.read(ingestionProvider.notifier);

    switch (_source) {
      case InputSource.text:
        if (_textCtrl.text.trim().isEmpty) {
          _showSnack('יש להדביק טקסט מתכון תחילה.');
          return;
        }
        await notifier.parseText(_textCtrl.text.trim());

      case InputSource.image:
        if (_images.isEmpty) {
          _showSnack('יש לבחור לפחות תמונה אחת.');
          return;
        }
        await notifier.parseImages(_images);

      case InputSource.pdf:
        final result = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          withData: true,
        );
        if (result == null || result.files.single.bytes == null) return;
        await notifier.parsePdf(result.files.single.bytes!);

      case InputSource.url:
        final rawUrl = _extractUrl(_urlCtrl.text.trim());
        if (rawUrl == null) {
          _showSnack('יש להזין קישור תחילה.');
          return;
        }
        if (UrlScraperService.isSupportedSocialMediaUrl(rawUrl)) {
          await _handleSocialUrl(rawUrl);
          return;
        }
        await notifier.parseUrl(rawUrl);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _handleSocialUrl(String url) async {
    final hasApify = ref.read(hasApifyApiKeyProvider);
    if (!hasApify) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
            'להוסיף מתכון מרשתות חברתיות, הגדר מפתח Apify בהגדרות.'),
        action: SnackBarAction(
          label: 'הגדרות',
          onPressed: () => context.push('/settings'),
        ),
      ));
      return;
    }
    await ref.read(ingestionProvider.notifier).parseSocialWithApify(url);
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
                            border:
                                Border.all(color: AppColors.line),
                          ),
                          child: const Icon(Icons.close,
                              size: 18, color: AppColors.ink),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'מתכון חדש',
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

                // ── Hero section ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + AI badge on the same row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'איך נוסיף את\nהמתכון?',
                              style: GoogleFonts.sourceSerif4(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ink,
                                height: 1.1,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                          const Gap(12),
                          // AI badge
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
                                  'AI מזהה מתכון אוטומטית',
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
                        'צלם תמונה של דף ספר, הדבק קישור או טקסט — נחלץ הכל בעצמנו.',
                        style: GoogleFonts.assistant(
                          fontSize: 15,
                          color: AppColors.ink2,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Source grid (2×2) ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.35,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _SourceCard(
                        id: InputSource.url,
                        label: 'קישור',
                        sub: 'אתר, רשת חברתית',
                        icon: Icons.link,
                        selected: _source == InputSource.url,
                        onTap: () => _selectSource(InputSource.url),
                      ),
                      _SourceCard(
                        id: InputSource.image,
                        label: 'תמונה',
                        sub: 'מצלמה או גלריה',
                        icon: Icons.camera_alt_outlined,
                        selected: _source == InputSource.image,
                        onTap: () => _selectSource(InputSource.image),
                      ),
                      _SourceCard(
                        id: InputSource.pdf,
                        label: 'PDF',
                        sub: 'ספר בישול סרוק',
                        icon: Icons.picture_as_pdf_outlined,
                        selected: _source == InputSource.pdf,
                        onTap: () => _selectSource(InputSource.pdf),
                      ),
                      _SourceCard(
                        id: InputSource.text,
                        label: 'טקסט',
                        sub: 'הדבק מתכון',
                        icon: Icons.text_snippet_outlined,
                        selected: _source == InputSource.text,
                        onTap: () => _selectSource(InputSource.text),
                      ),
                    ],
                  ),
                ),

                // ── Generate from ingredients banner ─────────────────
                const Gap(12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _GenerateBannerCard(),
                ),

                // ── Input area ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: _buildInputArea(),
                ),

                // ── Error ─────────────────────────────────────────────
                if (isError) ...[
                  const Gap(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ErrorCard(
                      message: ingestionState.message,
                      onRetry: _parse,
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
                          .updatePreview(ingestionState.recipe
                              .copyWith(title: title)),
                      onTagsChanged: (tags) => ref
                          .read(ingestionProvider.notifier)
                          .updatePreview(ingestionState.recipe
                              .copyWith(tags: tags)),
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
                      onPressed: _parse,
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text('חלץ מתכון'),
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

  void _selectSource(InputSource source) {
    setState(() {
      _source = source;
      if (source != InputSource.image) _images.clear();
    });
    ref.read(ingestionProvider.notifier).reset();
  }

  Widget _buildInputArea() {
    switch (_source) {
      case InputSource.url:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'הדבק קישור',
              style: GoogleFonts.assistant(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.ink2,
              ),
            ),
            const Gap(8),
            TextField(
              controller: _urlCtrl,
              keyboardType: TextInputType.url,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                hintText: 'https://recipe.com/...',
                prefixIcon:
                    const Icon(Icons.link, color: AppColors.ink2),
                hintStyle: GoogleFonts.assistant(
                  color: AppColors.ink3,
                  fontSize: 14,
                ),
              ),
            ),
            const Gap(8),
            ref.watch(hasApifyApiKeyProvider)
                ? Text(
                    'פוסטים ציבוריים מפייסבוק/אינסטגרם נתמכים',
                    style: GoogleFonts.assistant(
                      fontSize: 12,
                      color: AppColors.sage,
                    ),
                  )
                : GestureDetector(
                    onTap: () => context.push('/settings'),
                    child: Text(
                      'פוסטים מפייסבוק/אינסטגרם דורשים מפתח Apify ← הגדרות',
                      style: GoogleFonts.assistant(
                        fontSize: 12,
                        color: AppColors.terracotta,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
          ],
        );

      case InputSource.text:
        return TextField(
          controller: _textCtrl,
          maxLines: 8,
          decoration: InputDecoration(
            labelText: 'הדבק כאן טקסט מתכון',
            alignLabelWithHint: true,
          ),
        );

      case InputSource.image:
        return _ImagePickerArea(
          images: _images,
          onPickGallery: _pickFromGallery,
          onPickCamera: _pickFromCamera,
          onRemove: _removeImage,
        );

      case InputSource.pdf:
        return _PickerButton(
          icon: Icons.picture_as_pdf_outlined,
          label: 'בחר קובץ PDF',
          onTap: _parse,
        );
    }
  }
}

// ─── Source card ──────────────────────────────────────────────────────────────

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.id,
    required this.label,
    required this.sub,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final InputSource id;
  final String label;
  final String sub;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border:
              selected ? null : Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withAlpha(25)
                    : AppColors.sand,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : AppColors.ink,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: selected ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: GoogleFonts.assistant(
                    fontSize: 12,
                    color: selected
                        ? Colors.white.withAlpha(153)
                        : AppColors.ink3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Image picker area ────────────────────────────────────────────────────────

class _ImagePickerArea extends StatelessWidget {
  const _ImagePickerArea({
    required this.images,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onRemove,
  });

  final List<Uint8List> images;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('מצלמה'),
                onPressed: onPickCamera,
              ),
            ),
            const Gap(10),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('גלריה'),
                onPressed: onPickGallery,
              ),
            ),
          ],
        ),
        if (images.isNotEmpty) ...[
          const Gap(12),
          Text(
            '${images.length} ${images.length == 1 ? 'תמונה נבחרה' : 'תמונות נבחרו'}',
            style: GoogleFonts.assistant(
                fontSize: 13, color: AppColors.ink2),
          ),
          const Gap(8),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, _) => const Gap(8),
              itemBuilder: (context, i) => _ImageThumb(
                bytes: images[i],
                onRemove: () => onRemove(i),
              ),
            ),
          ),
        ] else ...[
          const Gap(12),
          Container(
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.lineStrong,
                  width: 1.5,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'לא נבחרו תמונות',
              style: GoogleFonts.assistant(
                  fontSize: 14, color: AppColors.ink3),
            ),
          ),
        ],
      ],
    );
  }
}

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({required this.bytes, required this.onRemove});

  final Uint8List bytes;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(bytes,
              width: 100, height: 110, fit: BoxFit.cover),
        ),
        Positioned(
          top: 2,
          left: 2,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _PickerButton extends StatelessWidget {
  const _PickerButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lineStrong, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.terracotta),
            const Gap(8),
            Text(label,
                style: GoogleFonts.assistant(
                    fontSize: 14, color: AppColors.ink)),
          ],
        ),
      ),
    );
  }
}

// ─── Generate banner card ──────────────────────────────────────────────────────

class _GenerateBannerCard extends StatelessWidget {
  const _GenerateBannerCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/generate-recipe'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.terracotta.withAlpha(77)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.terracottaSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 18, color: AppColors.terracotta),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'צור מתכון מרכיבים',
                    style: GoogleFonts.sourceSerif4(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    'AI יבנה מתכון בשבילך',
                    style: GoogleFonts.assistant(
                      fontSize: 12,
                      color: AppColors.ink3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.ink3),
          ],
        ),
      ),
    );
  }
}
