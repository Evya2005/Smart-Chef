import 'package:speech_to_text/speech_to_text.dart';

enum VoiceCommand { next, previous, repeat, stop, timer, switchRecipe, unknown }

class VoiceCommandService {
  VoiceCommandService() : _stt = SpeechToText();

  final SpeechToText _stt;
  bool _isInitialized = false;

  Future<bool> initialize() async {
    _isInitialized = await _stt.initialize(
      onError: (error) {},
      onStatus: (_) {},
    );
    return _isInitialized;
  }

  bool get isAvailable => _isInitialized && _stt.isAvailable;
  bool get isListening => _stt.isListening;

  Future<void> startListening(void Function(VoiceCommand) onCommand) async {
    if (!_isInitialized) return;
    await _stt.listen(
      localeId: 'he_IL',
      onResult: (result) {
        if (result.finalResult) {
          final cmd = _parse(result.recognizedWords);
          onCommand(cmd);
        }
      },
    );
  }

  Future<void> stopListening() => _stt.stop();

  void dispose() => _stt.cancel();

  static VoiceCommand _parse(String text) {
    final t = text.trim().toLowerCase();
    if (t.contains('הבא') || t.contains('קדימה') || t.contains('next')) {
      return VoiceCommand.next;
    }
    if (t.contains('קודם') || t.contains('אחורה') || t.contains('back')) {
      return VoiceCommand.previous;
    }
    if (t.contains('חזור') || t.contains('שוב') || t.contains('repeat')) {
      return VoiceCommand.repeat;
    }
    if (t.contains('עצור') || t.contains('סיים') || t.contains('stop')) {
      return VoiceCommand.stop;
    }
    if (t.contains('טיימר') || t.contains('timer')) {
      return VoiceCommand.timer;
    }
    if (t.contains('עבור') || t.contains('switch') || t.contains('מתכון')) {
      return VoiceCommand.switchRecipe;
    }
    return VoiceCommand.unknown;
  }
}
