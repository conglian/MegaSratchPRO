import 'package:audioplayers/audioplayers.dart';

import 'ms_LocalProvider.dart';
import 'ms_extension_help.dart';

class MSAudioUtils {
  // 单例实例
  static final MSAudioUtils _instance = MSAudioUtils._internal();

  factory MSAudioUtils() => _instance;

  MSAudioUtils._internal();

  // 背景音乐播放器
  final AudioPlayer _bgmPlayer = AudioPlayer();

  // 音效播放器池，避免音效重叠被打断
  final List<AudioPlayer> playerQueue = [];

  final int _maxSfxPlayers = 1;

  bool _bgmPlaying = false;

  Future<void> initTempQueue() async {
    // 初始化音效播放器池
    if (playerQueue.isEmpty) {
      for (int i = 0; i < _maxSfxPlayers; i++) {
        var audioPlayer = AudioPlayer();
        await audioPlayer.setPlayerMode(PlayerMode.lowLatency);
        await audioPlayer.setReleaseMode(ReleaseMode.stop);
        audioPlayer.setAudioContext(
            AudioContext(
                android: AudioContextAndroid(
                  isSpeakerphoneOn: true,
                  stayAwake: false,
                  contentType: AndroidContentType.music,
                  usageType: AndroidUsageType.game, // 或 media
                  audioFocus: AndroidAudioFocus.none, // ✅ 不抢焦点
                )
            ));
        playerQueue.add(audioPlayer);
      }
    }
  }

  /// 播放背景音乐，循环播放
  Future<void> playBGM({double volume = 0.6}) async {
    if (!MSLocalProvider.instance.ms_bg_music) {
      return;
    }
    if(_bgmPlayer.state == PlayerState.stopped){
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(volume);
      await _bgmPlayer.play(AssetSource("ms_bg".mp3files()));
    }else if(_bgmPlayer.state == PlayerState.paused){
      await _bgmPlayer.resume();
    }
    _bgmPlaying = true;
  }

  /// 暂停背景音乐
  Future<void> pauseBGM() async {
    if (_bgmPlaying) {
      await _bgmPlayer.pause();
      _bgmPlaying = false;
    }
  }

  /// 恢复背景音乐
  Future<void> resumeBGM() async {
    if (!_bgmPlaying) {
      await _bgmPlayer.resume();
      _bgmPlaying = true;
    }
  }

  /// 停止背景音乐
  Future<void> stopBGM() async {
    await _bgmPlayer.stop();
    _bgmPlaying = false;
  }

  Future<void> playAward1Audio()async{
    playTempAudio("ms_award1".mp3files());
  }

  Future<void> playAward2Audio()async{
    playTempAudio("ms_award2".mp3files());
  }

  Future<void> playAward3Audio()async{
    playTempAudio("ms_award3".mp3files());
  }

  Future<void> playUnAwardAudio()async{
    playTempAudio("ms_un_award".mp3files());
  }

  Future<void> playchouAudio()async{
    playTempAudio("".mp3files());
  }

  Future<void> playFaildAudio()async{
    playTempAudio("".mp3files());
  }

  Future<void> playGuakaAudio()async{
    playTempAudio("ms_gua1".mp3files());
  }

  Future<void> playDolasAudio()async{
    playTempAudio("ms_dolas".mp3files());
  }

  Future<void> playShaiziAudio()async{
    playTempAudio("".mp3files());
  }

  Future<void> playTempAudio(String assetPath, {double volume = 1.0}) async {
    if (!MSLocalProvider.instance.ms_sound_music) {
      return;
    }
    for (final player in playerQueue) {
      if (player.state != PlayerState.playing) {
        await _safePlay(player, assetPath, volume);
        return;
      }
    }

    // 都在播放，复用第一个
    await _safePlay(playerQueue.first, assetPath, volume);
  }

  Future<void> _safePlay(AudioPlayer player, String assetPath, double volume) async {
    try {
      // ⭐ 关键点：彻底释放 native 资源
      await player.release();

      // 极小延迟，确保 native 层完成 teardown（可留可不留，Android 上建议保留）
      await Future.delayed(const Duration(milliseconds: 20));

      await player.setVolume(volume);
      await player.play(AssetSource(assetPath));
    } catch (e, st) {
      "playTempAudio play error: $e\n$st".log();
    }
  }

  Future<void> stopAllTempAudio() async {
    for (final player in playerQueue) {
      try {
        await player.release(); // ⭐ 关键
      } catch (_) {}
    }
  }

  /// 释放资源
  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    for (final player in playerQueue) {
      await player.dispose();
    }
  }
  /// 释放资源
  Future<void> disposeBgm() async {
    await _bgmPlayer.dispose();
  }
}