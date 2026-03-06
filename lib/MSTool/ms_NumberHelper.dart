import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:megascratch/MSTool/ms_LocalProvider.dart';
import '../MSModel/MSCardNumberModel.dart';
import '../MSModel/MSIntRatioModel.dart';
import '../MSModel/MSProbabilityModel.dart';
import 'ms_extension_help.dart';

class MSNumberAHelper {

  static final MSNumberAHelper _instance = MSNumberAHelper._internal();

  factory MSNumberAHelper() => _instance;

  MSNumberAHelper._internal();

  MSRewardData numberAEntry = MSRewardData();

  MSCardNumberModel numberBEntry = MSCardNumberModel();

  Future<void> init() async {
    await _loadNumberDataFromLocate();
    await _loadNumberBFromLocate();
  }

  Future<void> _loadNumberDataFromLocate() async {
    String jsonString = await rootBundle.loadString("mega_number".jsons());
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    numberAEntry = MSRewardData.fromJson(jsonMap);
    '${numberAEntry.luckyNumbers.first.Probability}'.log();
  }

  Future<void> _loadNumberBFromLocate() async {
    String jsonString = await rootBundle.loadString("mega_game_number".jsons());
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    'number=${jsonMap['card_77earn']['point_7']}'.log();
    numberBEntry = MSCardNumberModel.fromJson(jsonMap);
    'winup_number=${numberBEntry.luckyNumber.winupNumber}'.log();
  }

  int getAwardPoolNumber(){
    int minBonus = 5;
    int maxBonus = 15;
    int balance = MSLocalProvider.instance.ms_dolas_number.toInt();
    // 根据余额判断奖金范围
    if (balance >= 0 && balance <= 300) {
      minBonus = 30;
      maxBonus = 50;
    } else if (balance > 300 && balance <= 500) {
      minBonus = 20;
      maxBonus = 30;
    } else if (balance > 500 && balance <= 1000) {
      minBonus = 15;
      maxBonus = 20;
    } else if (balance > 1000) {
      minBonus = 5;
      maxBonus = 15;
    }
    // 在最小和最大奖金范围内生成一个随机数
    Random random = Random();
    return random.nextInt(maxBonus - minBonus + 1) + minBonus;
  }

  // 获取当前范围的奖金
  List<int> getDiceValueByBalance(List<MSPrize> models) {
    for (var item in models) {
      int start = item.firstNumber;
      int end = item.endNumber;
      if (MSLocalProvider.instance.ms_dolas_number >= start && MSLocalProvider.instance.ms_dolas_number < end) {
        return item.prize;
      }
    }
    /// 如果超出所有区间，取最后一个区间
    var last = models.last;
    return last.prize;
  }

  // 生成[min, max]之间随机整数（兼容 double）
  int _randomBetween(double min, double max) {
    final r = Random();
    return min.toInt() + r.nextInt(max.toInt() - min.toInt() + 1);
  }

  /// 🎲 生成 lucku_moment 模式结果
  MSPlayJoyResult generatelucku_Numbers({ bool forceWin = false , bool keyHit = false}) {
    final _rand = Random();
    MSLuckyNumber mode = numberBEntry.luckyNumber;

    // 1️⃣ 生成3个不重复的中奖数字 (10~99)
    List<int> allNumbers = List.generate(90, (i) => i + 10);
    allNumbers.shuffle(_rand);
    List<int> winNumbers = allNumbers.take(3).toList();

    // 2️⃣ 生成15个显示数字，确保未中奖时不包含 winNumbers
    List<int> displayNumbers = [];
    while (displayNumbers.length < 15) {
      int n = _rand.nextInt(90) + 10;
      if (!winNumbers.contains(n)) {
        displayNumbers.add(n);
      }
    }
    // 生成一个 0 到 1 之间的随机数，用于判断是否中奖
    double randomProbability = _rand.nextDouble(); // 获取一个 [0.0, 1.0) 之间的随机数
    int multiplier = 0;
    int coins = 100;
    // 遍历 luckyNumbers，检查中奖规则
    if (mode.point >= randomProbability) {
        multiplier = 1;
    }
    if (forceWin){
      multiplier = 1;
    }
    List<int> fan = getDiceValueByBalance(mode.prizes);

    // 3️⃣ 每个显示数字对应的中奖值
    List<int> winMatchNumbers = List.generate(
        15, (_) => _randomBetween(fan.first.toDouble(), fan.last.toDouble()));

    // 4️⃣ 判断是否中奖
    bool isWin = forceWin || multiplier > 0;
    List<int> usedIndices = []; // 记录已替换的索引，避免重复
    int totalNumber = 0;
    // 5️⃣ 若中奖，替换 multiplier 个位置为 winNumbers 中的一个
    if (isWin) {
      int replacements = multiplier; // 替换数量由 multiplier 确定

      // 根据 multiplier 替换 displayNumbers 中的相应数量的元素
      while (usedIndices.length < replacements) {
        int winIndex = _rand.nextInt(displayNumbers.length); // 随机选择一个索引
        if (!usedIndices.contains(winIndex)) { // 确保该位置没有被替换过
          usedIndices.add(winIndex);
          int winNumber = winNumbers[_rand.nextInt(winNumbers.length)];
          displayNumbers[winIndex] = winNumber; // 替换显示数字
          totalNumber += winMatchNumbers[winIndex];
        }
      }
    }

    // 6️⃣ 骰子命中逻辑（可以按需求启用）
    bool diceHit = keyHit;
    if (diceHit) {
      // 找到未中奖的位置
      List<int> nonWinningIndices = [];

      // 查找所有没有中奖的索引
      for (int i = 0; i < displayNumbers.length; i++) {
        if (!winNumbers.contains(displayNumbers[i])) {
          nonWinningIndices.add(i);
        }
      }

      // 如果有未中奖的位置，替换其中一个
      if (nonWinningIndices.isNotEmpty) {
        int diceIdx = nonWinningIndices[_rand.nextInt(nonWinningIndices.length)];
        displayNumbers[diceIdx] = -2; // 替换为骰子命中的值
      }
    }

    // ✅ 7️⃣ 封装结果返回
    return MSPlayJoyResult(
      winNumbers: winNumbers,
      displayNumbers: displayNumbers,
      winMatchNumbers: winMatchNumbers,
      isWin: isWin,
      diceHit: diceHit,
      winIndex: usedIndices,
        totalNumber:totalNumber
    );
  }

  MSPlayJoyResult generatelucku_diamonds({ bool forceWin = false , bool keyHit = false}) {
    final _rand = Random();

    MSCardDiamonds mode = numberBEntry.cardDiamonds;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    'randomProbability=${mode.diamonds0} ${mode.diamonds3} ${mode.diamonds5} ${mode.diamonds7} ${mode.diamonds8}'.log();
    'randomProbability=$randomProbability'.log();
    int multiplier = 0;
    if (randomProbability >= mode.diamonds3) {
      multiplier = 3;
    } else if (randomProbability >= mode.diamonds4) {
      multiplier = 4;
    } else if (randomProbability >= mode.diamonds5) {
      multiplier = 5;
    } else if (randomProbability >= mode.diamonds6) {
      multiplier = 6;
    } else if (randomProbability >= mode.diamonds7) {
      multiplier = 7;
    } else if (randomProbability >= mode.diamonds8) {
      multiplier = 8;
    } else if (randomProbability >= mode.diamonds0) {
      multiplier = 0;
    }
    if (forceWin){
      multiplier = 3;
    }
    'multiplier=$multiplier'.log();
    // 2️⃣ 是否中奖
    bool isWin = forceWin || multiplier > 0;

    // ==============================
    // 3️⃣ 生成 12 个显示数字（范围 1 或 2）
    // ==============================
    List<int> displayNumbers = List.generate(12, (_) => _rand.nextInt(2) + 1);  // 每个数字为1或2

    // ==============================
    // 4️⃣ 生成 12 个奖励数值 (10~99)
    // ==============================
    List<int> fan = getDiceValueByBalance(mode.prizes);
    // 3️⃣ 每个显示数字对应的中奖值
    List<int> rewardValues = List.generate(
        12, (_) => _randomBetween(fan.first.toDouble(), fan.last.toDouble()));

    List<int> winIndices = [];

    int totalReward = 0;

    // ==============================
    // 5️⃣ 中奖替换 & 奖励计算（乘上 multiplier）
    // ==============================
    if (isWin) {
      int replaceCount = multiplier.clamp(0, 12);  // 根据 multiplier 替换数量
      Set<int> usedIndices = {};
      // 确保根据 multiplier 替换相应数量的位置
      while (usedIndices.length < replaceCount) {
        int index = _rand.nextInt(12);
        if (usedIndices.add(index)) {
          // 替换为 0
          displayNumbers[index] = 0;
          winIndices.add(index);
          // 累加奖励数值
          totalReward += rewardValues[index];
        }
      }

      // 奖励总和乘以 multiplier
      totalReward *= (multiplier - 2);
    }

    'isWin=$isWin'.log();

    // 6️⃣ 骰子逻辑（未启用）
    bool diceHit = keyHit;
    if (diceHit) {
      // 找到未中奖的位置
      List<int> nonWinningIndices = [];

      // 查找所有没有中奖的索引（即没有被替换为 0 的位置）
      for (int i = 0; i < displayNumbers.length; i++) {
        if (displayNumbers[i] != 0) {  // 如果该位置不是中奖的 0
          nonWinningIndices.add(i);    // 将其添加到未中奖的位置列表中
        }
      }

      // 如果有未中奖的位置，替换其中一个
      if (nonWinningIndices.isNotEmpty) {
        int diceIdx = nonWinningIndices[_rand.nextInt(nonWinningIndices.length)];
        displayNumbers[diceIdx] = -2; // 替换为骰子命中的值
      }
    }

    // 7️⃣ 返回结果
    return MSPlayJoyResult(
      displayNumbers: displayNumbers, // 12 个数字（0 或 1/2）
      winMatchNumbers: rewardValues,  // 12 个奖励数值
      isWin: isWin,
      diceHit: diceHit,
      winIndex: winIndices,           // 被替换为 0 的下标
      totalNumber: totalReward,       // 奖励总和 * multiplier
      winNumbers: [],
    );
  }


  MSPlayJoyResult generatelucku_partpay({ bool forceWin = false , bool keyHit = false}) {

    final _rand = Random();

    MSCardFruit mode = numberBEntry.cardFruit;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    int multiplier = 0;
    'randomProbability=$randomProbability pointFace = ${mode.pointFace}'.log();
    if (mode.pointFace >= randomProbability) {
      multiplier = 1;
    }
    if (forceWin){
      multiplier = 1;
    }

    // 2️⃣ 是否中奖
    bool isWin = forceWin || multiplier > 0;

    // ==============================
    // 3️⃣ 九宫格数值（0 / 1 / 2）
    // ==============================
    List<int> displayNumbers = List.filled(9, 0);

    // ==============================
    // 4️⃣ 生成 9 个奖励数值
    // ==============================
    List<int> fan = getDiceValueByBalance(mode.prizes);
    // 3️⃣ 每个显示数字对应的中奖值
    List<int> rewardValues = List.generate(
        9, (_) => _randomBetween(fan.first.toDouble(), fan.last.toDouble()));

    List<int> winIndices = [];
    int totalReward = 0;

    if (isWin) {
      /// ✅ 中奖：随机一整排为 0
      int zeroRow = _rand.nextInt(3); // 0,1,2

      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          int index = row * 3 + col;

          if (row == zeroRow) {
            displayNumbers[index] = 0;
            winIndices.add(index);
            totalReward += rewardValues[index];
          } else {
            displayNumbers[index] = _rand.nextBool() ? 1 : 2;
          }
        }
      }
    } else {
      /// ❌ 未中奖：不能出现整排 0
      bool valid = false;

      while (!valid) {
        for (int i = 0; i < 9; i++) {
          displayNumbers[i] = _rand.nextInt(3); // 0 / 1 / 2
        }

        bool hasZeroRow = false;
        for (int row = 0; row < 3; row++) {
          int base = row * 3;
          if (displayNumbers[base] == 0 &&
              displayNumbers[base + 1] == 0 &&
              displayNumbers[base + 2] == 0) {
            hasZeroRow = true;
            break;
          }
        }

        valid = !hasZeroRow;
      }
    }

    // 5️⃣ 骰子逻辑（未启用）
    bool diceHit = keyHit;  // 判断是否启用骰子逻辑
    if (diceHit) {
      // 找到未中奖的位置
      List<int> nonWinningIndices = [];

      // 查找所有没有中奖的索引（即没有被替换为 0 的位置）
      for (int i = 0; i < displayNumbers.length; i++) {
        if (displayNumbers[i] != 0) {  // 如果该位置不是中奖的 0
          nonWinningIndices.add(i);    // 将其添加到未中奖的位置列表中
        }
      }

      // 如果有未中奖的位置，替换其中一个
      if (nonWinningIndices.isNotEmpty) {
        int diceIdx = nonWinningIndices[_rand.nextInt(nonWinningIndices.length)];
        displayNumbers[diceIdx] = -2; // 替换为骰子命中的值
      }
    }

    // 6️⃣ 返回结果
    return MSPlayJoyResult(
      displayNumbers: displayNumbers, // 九宫格 0/1/2
      winMatchNumbers: rewardValues,  // 9 个奖励数值
      isWin: isWin,
      diceHit: diceHit,
      winIndex: winIndices,           // 中奖那一排的索引
      totalNumber: totalReward,
      winNumbers: [],       // 奖励总和
    );
  }

  MSPlayJoyResult generatelucku_emojifun({ bool forceWin = false , bool keyHit = false}) {
    final _rand = Random();
    MSCardEmoji mode = numberBEntry.cardEmoji;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    int multiplier = 0;
    if (mode.point >= randomProbability) {
      multiplier = 1;
    }
    if (forceWin){
      multiplier = 1;
    }

    // 2️⃣ 是否中奖
    bool isWin = forceWin || multiplier > 0;

    // ==============================
    // 3️⃣ 九宫格数值（0 / 1 / 2）
    // ==============================
    List<int> displayNumbers = List.filled(9, 0);

    // ==============================
    // 4️⃣ 生成 9 个奖励数值
    // ==============================
    List<int> fan = getDiceValueByBalance(mode.prizes);
    // 3️⃣ 每个显示数字对应的中奖值
    List<int> rewardValues = List.generate(
        9, (_) => _randomBetween(fan.first.toDouble(), fan.last.toDouble()));

    List<int> winIndices = [];
    int totalReward = 0;

    if (isWin) {
      /// ✅ 中奖：随机一整排为 0
      int zeroRow = _rand.nextInt(3); // 0,1,2
      totalReward += rewardValues[zeroRow];
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          int index = row * 3 + col;

          if (row == zeroRow) {
            displayNumbers[index] = 0;
            winIndices.add(index);
          } else {
            displayNumbers[index] = _rand.nextBool() ? 1 : 2;
          }
        }
      }
    } else {
      /// ❌ 未中奖：不能出现整排 0
      bool valid = false;

      while (!valid) {
        for (int i = 0; i < 9; i++) {
          displayNumbers[i] = _rand.nextInt(3); // 0 / 1 / 2
        }

        bool hasZeroRow = false;
        for (int row = 0; row < 3; row++) {
          int base = row * 3;
          if (displayNumbers[base] == 0 &&
              displayNumbers[base + 1] == 0 &&
              displayNumbers[base + 2] == 0) {
            hasZeroRow = true;
            break;
          }
        }

        valid = !hasZeroRow;
      }
    }

    // 5️⃣ 骰子逻辑（未启用）
    bool diceHit = keyHit;  // 判断是否启用骰子逻辑
    if (diceHit) {
      // 找到未中奖的位置
      List<int> nonWinningIndices = [];

      // 查找所有没有中奖的索引（即没有被替换为 0 的位置）
      for (int i = 0; i < displayNumbers.length; i++) {
        if (displayNumbers[i] != 0) {  // 如果该位置不是中奖的 0
          nonWinningIndices.add(i);    // 将其添加到未中奖的位置列表中
        }
      }

      // 如果有未中奖的位置，替换其中一个
      if (nonWinningIndices.isNotEmpty) {
        int diceIdx = nonWinningIndices[_rand.nextInt(nonWinningIndices.length)];
        displayNumbers[diceIdx] = -2; // 替换为骰子命中的值
      }
    }

    // 6️⃣ 返回结果
    return MSPlayJoyResult(
      displayNumbers: displayNumbers, // 九宫格 0/1/2
      winMatchNumbers: rewardValues,  // 9 个奖励数值
      isWin: isWin,
      diceHit: diceHit,
      winIndex: winIndices,           // 中奖那一排的索引
      totalNumber: totalReward,
      winNumbers: [],       // 奖励总和
    );
  }

  MSPlayJoyResult generatelucku_goldpotdig({ bool forceWin = false , bool keyHit = false}) {
    final _rand = Random();
    MSCardGoldPot mode = numberBEntry.cardGoldPot;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    int multiplier = 0;
    if (mode.point >= randomProbability){
      multiplier = 1;
    }
    if (forceWin){
      multiplier = 1;
    }

    // 2️⃣ 是否中奖
    bool isWin = forceWin || multiplier > 0;

    // ==============================
    // 3️⃣ 生成 10 个显示数字（初始值都为 3）
    // ==============================
    List<int> displayNumbers = List.filled(10, 3);

    // ==============================
    // 4️⃣ 生成 10 个奖励数值
    // ==============================
    List<int> fan = getDiceValueByBalance(mode.prizes);
    // 3️⃣ 每个显示数字对应的中奖值
    List<int> rewardValues = List.generate(
        10, (_) => _randomBetween(fan.first.toDouble(), fan.last.toDouble()));

    List<int> winIndices = [];
    int totalReward = 0;

    if (isWin) {
      int replaceCount = multiplier.clamp(0, 10);  // 根据 multiplier 替换数量，最多替换 10 个
      Set<int> usedIndices = {};

      while (usedIndices.length < replaceCount) {
        int index = _rand.nextInt(10);  // 随机选择一个索引
        if (usedIndices.add(index)) {
          // 替换为 2
          displayNumbers[index] = 2;
          winIndices.add(index);

          // 累加奖励数值
          totalReward += rewardValues[index];  // 奖励数值是被替换的数字对应的奖励
        }
      }
    }

    // 5️⃣ 骰子逻辑（未启用）
    bool diceHit = keyHit;  // 判断是否启用骰子逻辑
    if (diceHit) {
      // 找到未中奖的位置
      List<int> nonWinningIndices = [];

      // 查找所有没有中奖的索引（即没有被替换为 2 的位置）
      for (int i = 0; i < displayNumbers.length; i++) {
        if (displayNumbers[i] != 2) {  // 如果该位置不是中奖的 2
          nonWinningIndices.add(i);    // 将其添加到未中奖的位置列表中
        }
      }

      // 如果有未中奖的位置，替换其中一个
      if (nonWinningIndices.isNotEmpty) {
        int diceIdx = nonWinningIndices[_rand.nextInt(nonWinningIndices.length)];
        displayNumbers[diceIdx] = -2; // 替换为骰子命中的值（可以根据需要修改为其他值）
      }
    }

    // 6️⃣ 返回结果
    return MSPlayJoyResult(
      displayNumbers: displayNumbers,  // 10 个数字（3 或 2）
      winMatchNumbers: rewardValues,   // 10 个奖励数值
      isWin: isWin,
      diceHit: diceHit,
      winIndex: winIndices,            // 被替换为 2 的下标
      totalNumber: totalReward,        // 奖励总和（不含倍数）
      winNumbers: [],
    );
  }


  MSPlayJoyResult generatelucku_77n({ bool forceWin = false , bool keyHit = false}) {
    final _rand = Random();
    MSCard77earn mode = numberBEntry.card77earn;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    int multiplier = 0;
    'randomProbability=${mode.pointNowin} ${mode.point7} ${mode.point77} ${mode.point777}'.log();
    'randomProbability=$randomProbability'.log();
    if (randomProbability >= mode.point7) {
      multiplier = 1;
    } else if (randomProbability >= mode.point77) {
      multiplier = 2;
    } else if (randomProbability >= mode.point777) {
      multiplier = 3;
    } else if (randomProbability >= mode.pointNowin) {
      multiplier = 0;
    }
    'multiplier=$multiplier'.log();
    if (forceWin){
      multiplier = 1;
    }

    // 2️⃣ 是否中奖
    bool isWin = forceWin || multiplier > 0;

    // ==============================
    // 3️⃣ 生成 15 个普通数字 (10~99)
    // ==============================
    List<int> displayNumbers =
    List.generate(15, (_) => _rand.nextInt(90) + 10);

    // ==============================
    // 4️⃣ 生成 15 个奖励数值 (10~99)
    // ==============================
    List<int> fan = getDiceValueByBalance(mode.prizes);
    // 3️⃣ 每个显示数字对应的中奖值
    List<int> rewardValues = List.generate(
        15, (_) => _randomBetween(fan.first.toDouble(), fan.last.toDouble()));

    List<int> winIndices = [];
    int totalReward = 0;

    // ==============================
    // 5️⃣ 中奖替换 & 奖励计算
    // ==============================
    if (isWin) {
      int replaceCount = 1.clamp(0, 15);
      Set<int> usedIndices = {};

      while (usedIndices.length < replaceCount) {
        int index = _rand.nextInt(15);
        if (usedIndices.add(index)) {
          // 替换为 0 / 1 / 2
          int replaceValue = multiplier - 1;
          displayNumbers[index] = replaceValue;
          winIndices.add(index);

          // 奖励倍数计算
          int baseReward = rewardValues[index];
          int finalReward;

          if (replaceValue == 0) {
            finalReward = baseReward;       // ×1
          } else if (replaceValue == 1) {
            finalReward = baseReward * 2;   // ×2
          } else {
            finalReward = baseReward * 3;   // ×3
          }

          totalReward += finalReward;
        }
      }
    }

    // 6️⃣ 骰子逻辑（未启用）
    bool diceHit = keyHit;  // 判断是否启用骰子逻辑
    if (diceHit) {
      // 找到未中奖的位置
      List<int> nonWinningIndices = [];

      // 查找所有没有中奖的索引（即没有被替换为 0/1/2 的位置）
      for (int i = 0; i < displayNumbers.length; i++) {
        if (displayNumbers[i] != 0 && displayNumbers[i] != 1 && displayNumbers[i] != 2) {
          nonWinningIndices.add(i);    // 将其添加到未中奖的位置列表中
        }
      }

      // 如果有未中奖的位置，替换其中一个
      if (nonWinningIndices.isNotEmpty) {
        int diceIdx = nonWinningIndices[_rand.nextInt(nonWinningIndices.length)];
        displayNumbers[diceIdx] = -2; // 替换为骰子命中的值（可以根据需求修改为其他值）
      }
    }

    // 7️⃣ 返回结果
    return MSPlayJoyResult(
      displayNumbers: displayNumbers, // 15 个数字（10~99 或 0/1/2）
      winMatchNumbers: rewardValues,  // 15 个奖励数值
      isWin: isWin,
      diceHit: diceHit,
      winIndex: winIndices,           // 被替换的下标
      totalNumber: totalReward,       // 奖励总和
      winNumbers: [],
    );
  }

  MSPlayJoyResult generatelucku_coincraze({ bool forceWin = false ,bool keyHit = false}) {
    final _rand = Random();
    MSLuckyCash mode = numberBEntry.luckyCash;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    int multiplier = 0;
    if (mode.point >= randomProbability){
      multiplier = 1;
    }
    if (forceWin){
      multiplier = 1;
    }

    // 2️⃣ 是否中奖
    bool isWin = forceWin || multiplier > 0;

    // ==============================
    // 3️⃣ 生成 12 个显示数字（全部为 0）
    // ==============================
    List<int> displayNumbers = List.filled(12, 0);

    // ==============================
    // 4️⃣ 生成 12 个奖励数值 (10~99)
    // ==============================
    List<int> fan = getDiceValueByBalance(mode.prizes);
    // 3️⃣ 每个显示数字对应的中奖值
    List<int> rewardValues = List.generate(
        12, (_) => _randomBetween(fan.first.toDouble(), fan.last.toDouble()));

    List<int> winIndices = [];
    int totalReward = 0;

    // ==============================
    // 5️⃣ 中奖替换 & 奖励计算（无倍数）
    // ==============================
    if (isWin) {
      int replaceCount = multiplier.clamp(0, 12);
      Set<int> usedIndices = {};

      while (usedIndices.length < replaceCount) {
        int index = _rand.nextInt(12);
        if (usedIndices.add(index)) {
          // 替换为对应奖励值
          displayNumbers[index] = rewardValues[index];
          winIndices.add(index);

          // 累加奖励（无倍数）
          totalReward += rewardValues[index];
        }
      }
    }

    // 6️⃣ 骰子逻辑（未启用）
    bool diceHit = keyHit;  // 判断是否启用骰子逻辑
    if (diceHit) {
      // 找到未中奖的位置
      List<int> nonWinningIndices = [];

      // 查找所有没有中奖的索引（即没有被替换为奖励值的位置）
      for (int i = 0; i < displayNumbers.length; i++) {
        if (displayNumbers[i] == 0) {  // 如果该位置还没有中奖
          nonWinningIndices.add(i);    // 将其添加到未中奖的位置列表中
        }
      }

      // 如果有未中奖的位置，替换其中一个
      if (nonWinningIndices.isNotEmpty) {
        int diceIdx = nonWinningIndices[_rand.nextInt(nonWinningIndices.length)];
        displayNumbers[diceIdx] = -2; // 替换为骰子命中的值（可以根据需求修改为其他值）
      }
    }

    // 7️⃣ 返回结果
    return MSPlayJoyResult(
      displayNumbers: displayNumbers, // 12 个数字（0 或奖励值）
      winMatchNumbers: rewardValues,  // 12 个奖励数值
      isWin: isWin,
      diceHit: diceHit,
      winIndex: winIndices,           // 中奖下标
      totalNumber: totalReward,       // 奖励总和
      winNumbers: [],
    );
  }



}

class MSPlayJoyResult {
  final List<int> winNumbers; // 中奖数字（4个）
  final List<int> displayNumbers; // 显示的12个数字
  final List<int> winMatchNumbers; // 每个数字对应的中奖值（12个）
  final bool isWin; // 是否中奖
  final bool diceHit; // 是否骰子命中
  final List<int> winIndex; // 若中奖，对应在 displayNumbers 中的下标，未中奖则为 -1
  final int totalNumber;

  MSPlayJoyResult({
    required this.winNumbers,
    required this.displayNumbers,
    required this.winMatchNumbers,
    required this.isWin,
    required this.diceHit,
    required this.winIndex,
    required this.totalNumber,
  });

  factory MSPlayJoyResult.fromJson(Map<String, dynamic> json) {
    return MSPlayJoyResult(
      winNumbers: List<int>.from(json['win_numbers']),
      displayNumbers: List<int>.from(json['display_numbers']),
      winMatchNumbers: List<int>.from(json['win_match_numbers']),
      isWin: json['isWin'],
      diceHit: json['diceHit'],
      winIndex: List<int>.from(json['winIndex']),
      totalNumber: json['totalNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "win_numbers": winNumbers,
      "display_numbers": displayNumbers,
      "win_match_numbers": winMatchNumbers,
      "isWin": isWin,
      "diceHit": diceHit,
      "winIndex": winIndex,
      "totalNumber": totalNumber,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() => toJsonString();
}