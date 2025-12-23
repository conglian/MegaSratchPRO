import 'package:audioplayers/audioplayers.dart';

import 'ms_extension_help.dart';

class MSMP3Player {

  static final MSMP3Player _instance = MSMP3Player._internal();

  factory MSMP3Player() {
    return _instance;
  }

  MSMP3Player._internal();

  final AudioPlayer backgroundPlayer = AudioPlayer();
  final AudioPlayer effectPlayer = AudioPlayer();
  final AudioPlayer effect2Player = AudioPlayer();
  final AudioPlayer effect3Player = AudioPlayer();
  final AudioPlayer effect4Player = AudioPlayer();
  final AudioPlayer effect5Player = AudioPlayer();
  final AudioPlayer effect6Player = AudioPlayer();
  final AudioPlayer effect7Player = AudioPlayer();
  final AudioPlayer effect8Player = AudioPlayer();
  final AudioPlayer effect9Player = AudioPlayer();
  final AudioPlayer effect10Player = AudioPlayer();
  final AudioPlayer effect11Player = AudioPlayer();

  // 播放背景音频
  Future<void> playBackground() async {
    String path = "ms_bg".mp3files();
    await backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await backgroundPlayer.play(AssetSource(path));
  }

  // 暂停背景音频
  Future<void> pauseBackground() async {
    await backgroundPlayer.pause();
  }

  // 恢复背景音频
  Future<void> resumeBackground() async {
    await backgroundPlayer.resume();
  }

  // 播放特效音频
  Future<void> playEffect() async {
    String path = "ms_award1".mp3files();
    await effectPlayer.setReleaseMode(ReleaseMode.loop);
    await effectPlayer.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect() async {
    await effectPlayer.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect() async {
    await effectPlayer.resume();
  }

  // 播放特效音频
  Future<void> playEffect2() async {
    String path = "ms_award2".mp3files();
    await effect2Player.setReleaseMode(ReleaseMode.loop);
    await effect2Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect2() async {
    await effect2Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect2() async {
    await effect2Player.resume();
  }

  // 播放特效音频
  Future<void> playEffect3() async {
    String path = "ms_award3".mp3files();
    await effect3Player.setReleaseMode(ReleaseMode.loop);
    await effect3Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect3() async {
    await effect3Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect3() async {
    await effect3Player.resume();
  }

  // 播放特效音频
  Future<void> playEffect4() async {
    String path = "ms_un_award".mp3files();
    await effect4Player.setReleaseMode(ReleaseMode.loop);
    await effect4Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect4() async {
    await effect4Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect4() async {
    await effect4Player.resume();
  }

  // 播放特效音频
  Future<void> playEffect5() async {
    String path = "ms_dolas".mp3files();
    await effect5Player.setReleaseMode(ReleaseMode.loop);
    await effect5Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect5() async {
    await effect5Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect5() async {
    await effect5Player.resume();
  }

  // 播放特效音频
  Future<void> playEffect6() async {
    String path = "".mp3files();
    await effect6Player.setReleaseMode(ReleaseMode.loop);
    await effect6Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect6() async {
    await effect6Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect6() async {
    await effect6Player.resume();
  }

  // 播放特效音频
  Future<void> playEffect7() async {
    String path = "".mp3files();
    await effect7Player.setReleaseMode(ReleaseMode.loop);
    await effect7Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect7() async {
    await effect7Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect7() async {
    await effect7Player.resume();
  }

  // 播放特效音频
  Future<void> playEffect8() async {
    String path = "".mp3files();
    await effect8Player.setReleaseMode(ReleaseMode.loop);
    await effect8Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect8() async {
    await effect8Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect8() async {
    await effect8Player.resume();
  }

  // 播放特效音频 - 抽卡
  Future<void> playEffect9() async {
    String path = "".mp3files();
    await effect9Player.setReleaseMode(ReleaseMode.loop);
    await effect9Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect9() async {
    await effect9Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect9() async {
    await effect9Player.resume();
  }

  // 播放特效音频 - 抽卡
  Future<void> playEffect10() async {
    String path = "ms_award3".mp3files();
    await effect10Player.setReleaseMode(ReleaseMode.loop);
    await effect10Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffect10() async {
    await effect10Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffect10() async {
    await effect10Player.resume();
  }

  // 播放特效音频 - 刮卡
  Future<void> playEffectguaka() async {
    String path = "ms_gua1".mp3files();
    await effect11Player.setReleaseMode(ReleaseMode.loop);
    await effect11Player.play(AssetSource(path));
  }

  // 暂停特效音频
  Future<void> pauseEffectguaka() async {
    await effect11Player.pause();
  }

  // 恢复特效音频
  Future<void> resumeEffectguaka() async {
    await effect11Player.resume();
  }

  // 释放资源
  Future<void> dispose() async {
    await backgroundPlayer.dispose();
    await effectPlayer.dispose();
    await effect2Player.dispose();
    await effect3Player.dispose();
    await effect4Player.dispose();
    await effect5Player.dispose();
    await effect6Player.dispose();
    await effect7Player.dispose();
    await effect8Player.dispose();
    await effect9Player.dispose();
    await effect10Player.dispose();
    await effect11Player.dispose();
  }
}