import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/share_intent_service.dart';
import '../../../core/utils/ai_guard.dart';
import '../../../shared/widgets/error_card.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../providers/ingestion_provider.dart';
import '../providers/social_connection_provider.dart';
import '../services/url_scraper_service.dart';
import 'widgets/ingestion_preview_card.dart';
import 'widgets/input_source_picker.dart';

class IngestionScreen extends ConsumerStatefulWidget {
  const IngestionScreen({super.key});

  @override
  ConsumerState<IngestionScreen> createState() => _IngestionScreenState();
}

class _IngestionScreenState extends ConsumerState<IngestionScreen> {
  InputSource _source = InputSource.text;
  final _textCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();

  // Picked images for the image source.
  final List<Uint8List> _images = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleSharedIntent());
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

  // ─── Image helpers ─────────────────────────────────────────────────────────

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;
    final bytes = await Future.wait(picked.map((f) => f.readAsBytes()));
    setState(() => _images.addAll(bytes));
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 85);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _images.add(bytes));
  }

  void _removeImage(int index) => setState(() => _images.removeAt(index));

  // ─── Parse dispatch ────────────────────────────────────────────────────────

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
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          withData: true,
        );
        if (result == null || result.files.single.bytes == null) return;
        await notifier.parsePdf(result.files.single.bytes!);

      case InputSource.url:
        // Extract the first http(s) URL from whatever was pasted — handles
        // copy artifacts like "url=https://..." or leading garbage text.
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
    final status = ref.read(socialConnectionProvider);
    if (!status.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('יש להתחבר תחילה לפייסבוק כדי לייבא פוסטים.'),
        action: SnackBarAction(
          label: 'התחבר',
          onPressed: () => context.push('/social-accounts'),
        ),
      ));
      return;
    }
    await ref
        .read(ingestionProvider.notifier)
        .parseSocialUrl(url, status.facebookAccessToken!);
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final ingestionState = ref.watch(ingestionProvider);

    ref.listen(ingestionProvider, (_, next) {
      if (next is IngestionDone) {
        ref.read(ingestionProvider.notifier).reset();
        context.go('/recipes/${next.recipeId}');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('הוסף מתכון')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              InputSourcePicker(
                selected: _source,
                onChanged: (s) {
                  setState(() {
                    _source = s;
                    _images.clear();
                  });
                  ref.read(ingestionProvider.notifier).reset();
                },
              ),
              const Gap(20),
              _buildInputArea(),
              const Gap(16),
              if (ingestionState is IngestionIdle ||
                  ingestionState is IngestionError)
                FilledButton.icon(
                  onPressed: _parse,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('נתח עם AI'),
                ),
              if (ingestionState is IngestionError) ...[
                const Gap(12),
                ErrorCard(
                  message: ingestionState.message,
                  onRetry: _parse,
                ),
              ],
              if (ingestionState is IngestionPreview) ...[
                const Gap(20),
                IngestionPreviewCard(
                  recipe: ingestionState.recipe,
                  onTitleChanged: (title) {
                    ref
                        .read(ingestionProvider.notifier)
                        .updatePreview(ingestionState.recipe
                            .copyWith(title: title));
                  },
                  onTagsChanged: (tags) {
                    ref
                        .read(ingestionProvider.notifier)
                        .updatePreview(ingestionState.recipe
                            .copyWith(tags: tags));
                  },
                  onConfirm: () =>
                      ref.read(ingestionProvider.notifier).confirmSave(),
                  onDiscard: () =>
                      ref.read(ingestionProvider.notifier).reset(),
                ),
              ],
              const Gap(40),
            ],
          ),
          if (ingestionState is IngestionLoading)
            LoadingOverlay(message: ingestionState.message),
          if (ingestionState is IngestionSaving)
            const LoadingOverlay(message: 'שומר מתכון...'),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    switch (_source) {
      case InputSource.text:
        return TextField(
          controller: _textCtrl,
          maxLines: 10,
          decoration: const InputDecoration(
            labelText: 'הדבק כאן טקסט מתכון',
            alignLabelWithHint: true,
          ),
        );

      case InputSource.url:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlCtrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'קישור למתכון',
                hintText: 'https://example.com/recipe',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.manage_accounts_outlined, size: 16),
                label: const Text(
                  'ניהול חיבורים לפייסבוק / אינסטגרם',
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: () => context.push('/social-accounts'),
              ),
            ),
          ],
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
        // Add buttons.
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
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Gap(8),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const Gap(8),
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
                  color: Theme.of(context).colorScheme.outline,
                  width: 1.5,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'לא נבחרו תמונות',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
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
          child: Image.memory(
            bytes,
            width: 100,
            height: 110,
            fit: BoxFit.cover,
          ),
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

// ─── Generic picker button (PDF) ──────────────────────────────────────────────

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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.outline, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary),
            const Gap(8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
