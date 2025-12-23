import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../MSModel/MSProbabilityModel.dart';
import 'ms_extension_help.dart';

class MSNumberAHelper {

  static final MSNumberAHelper _instance = MSNumberAHelper._internal();

  factory MSNumberAHelper() => _instance;

  MSNumberAHelper._internal();

  MSRewardData numberAEntry = MSRewardData();

  Future<void> init() async {
    await _loadNumberDataFromLocate();
  }

  Future<void> _loadNumberDataFromLocate() async {
    String jsonString = await rootBundle.loadString("mega_number".jsons());
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    numberAEntry = MSRewardData.fromJson(jsonMap);
    '${numberAEntry.luckyNumbers.first.Probability}'.log();
  }

  /// 🎲 生成 lucku_moment 模式结果
  MSPlayJoyResult generatelucku_Numbers({ bool forceWin = false }) {
    final _rand = Random();
    MSReward mode = numberAEntry.luckyNumbers.first;

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
    num probability = 0;
    int multiplier = 0;
    int coins = 100;
    // 遍历 luckyNumbers，检查中奖规则
    for (var luckyNumber in MSNumberAHelper().numberAEntry.luckyNumbers) {
      if (luckyNumber.Probability >= randomProbability) {
        probability = luckyNumber.Probability;
        multiplier = luckyNumber.Multiplier;
        coins = luckyNumber.Coins;
        if (coins <= 0){
          coins = 100;
        }
        mode = luckyNumber;
        break;  // 找到匹配的项后，跳出循环
      }
    }

    // 3️⃣ 每个显示数字对应的中奖值
    List<int> winMatchNumbers = List.generate(
        15, (_) => _rand.nextInt(coins) + 10);

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
    bool diceHit = false;
    // bool diceHit = _rand.nextDouble() < mode.diceProbability;
    // if (diceHit) {
    //   int diceIdx = _rand.nextInt(displayNumbers.length);
    //   displayNumbers[diceIdx] = -2; // 替换为骰子命中的值
    // }

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

  MSPlayJoyResult generatelucku_diamonds({ bool forceWin = false }) {
    final _rand = Random();

    MSReward mode = numberAEntry.luckyDiamond.first;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();

    int multiplier = 0;
    int coins = 100;
    for (var luckyNumber in MSNumberAHelper().numberAEntry.luckyDiamond) {
      if (luckyNumber.Probability >= randomProbability) {
        multiplier = luckyNumber.Multiplier;
        coins = luckyNumber.Coins;
        if (coins <= 0){
          coins = 100;
        }
        mode = luckyNumber;
        break;  // 找到匹配的项后，跳出循环
      }
    }

    // 2️⃣ 是否中奖
    bool isWin = forceWin || multiplier > 0;

    // ==============================
    // 3️⃣ 生成 12 个显示数字（范围 1 或 2）
    // ==============================
    List<int> displayNumbers = List.generate(12, (_) => _rand.nextInt(2) + 1);  // 每个数字为1或2

    // ==============================
    // 4️⃣ 生成 12 个奖励数值 (10~99)
    // ==============================
    List<int> rewardValues = List.generate(12, (_) => _rand.nextInt(coins) + 10);  // 奖励数值范围10~99

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
      totalReward *= multiplier;
    }

    'isWin=$isWin'.log();

    // 6️⃣ 骰子逻辑（未启用）
    bool diceHit = false;

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


  MSPlayJoyResult generatelucku_partpay({ bool forceWin = false }) {
    final _rand = Random();
    MSReward mode = numberAEntry.fruitPartyPay.first;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    int multiplier = 0;
    int coins = 100;
    for (var luckyNumber in MSNumberAHelper().numberAEntry.fruitPartyPay) {
      if (luckyNumber.Probability >= randomProbability) {
        multiplier = luckyNumber.Multiplier;
        coins = luckyNumber.Coins;
        if (coins <= 0){
          coins = 100;
        }
        mode = luckyNumber;
        break;  // 找到匹配的项后，跳出循环
      }
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
    List<int> rewardValues =
    List.generate(9, (_) => _rand.nextInt(coins) + 10);

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
    bool diceHit = false;

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

  MSPlayJoyResult generatelucku_emojifun({ bool forceWin = false }) {
    final _rand = Random();
    MSReward mode = numberAEntry.emojiFunReward.first;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    int multiplier = 0;
    int coins = 100;
    for (var luckyNumber in MSNumberAHelper().numberAEntry.emojiFunReward) {
      if (luckyNumber.Probability >= randomProbability) {
        multiplier = luckyNumber.Multiplier;
        coins = luckyNumber.Coins;
        if (coins <= 0){
          coins = 100;
        }
        mode = luckyNumber;
        break;  // 找到匹配的项后，跳出循环
      }
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
    List<int> rewardValues =
    List.generate(9, (_) => _rand.nextInt(coins) + 10);

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
    bool diceHit = false;

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

  MSPlayJoyResult generatelucku_goldpotdig({ bool forceWin = false }) {
    final _rand = Random();
    MSReward mode = numberAEntry.goldPotDig.first;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    int multiplier = 0;
    int coins = 100;
    for (var luckyNumber in MSNumberAHelper().numberAEntry.goldPotDig) {
      if (luckyNumber.Probability >= randomProbability) {
        multiplier = luckyNumber.Multiplier;
        coins = luckyNumber.Coins;
        if (coins <= 0){
          coins = 100;
        }
        mode = luckyNumber;
        break;  // 找到匹配的项后，跳出循环
      }
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
    List<int> rewardValues = List.generate(10, (_) => _rand.nextInt(coins) + 10);  // 奖励数值范围10~99

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
    bool diceHit = false;

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


  MSPlayJoyResult generatelucku_77n({ bool forceWin = false }) {
    final _rand = Random();
    MSReward mode = numberAEntry.huntAndEarn.first;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    int multiplier = 0;
    int coins = 100;
    for (var luckyNumber in MSNumberAHelper().numberAEntry.huntAndEarn) {
      if (luckyNumber.Probability >= randomProbability) {
        multiplier = luckyNumber.Multiplier;
        coins = luckyNumber.Coins;
        if (coins <= 0){
          coins = 100;
        }
        mode = luckyNumber;
        break;  // 找到匹配的项后，跳出循环
      }
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
    List<int> rewardValues =
    List.generate(15, (_) => _rand.nextInt(coins) + 10);

    List<int> winIndices = [];
    int totalReward = 0;

    // ==============================
    // 5️⃣ 中奖替换 & 奖励计算
    // ==============================
    if (isWin) {
      int replaceCount = multiplier.clamp(0, 15);
      Set<int> usedIndices = {};

      while (usedIndices.length < replaceCount) {
        int index = _rand.nextInt(15);
        if (usedIndices.add(index)) {
          // 替换为 0 / 1 / 2
          int replaceValue = _rand.nextInt(3);
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
    bool diceHit = false;

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

  MSPlayJoyResult generatelucku_coincraze({ bool forceWin = false }) {
    final _rand = Random();
    MSReward mode = numberAEntry.coinCraze.first;

    // 1️⃣ 概率判定
    double randomProbability = _rand.nextDouble();
    int multiplier = 0;
    int coins = 100;
    for (var luckyNumber in MSNumberAHelper().numberAEntry.coinCraze) {
      if (luckyNumber.Probability >= randomProbability) {
        multiplier = luckyNumber.Multiplier;
        coins = luckyNumber.Coins;
        if (coins <= 0){
          coins = 100;
        }
        mode = luckyNumber;
        break;  // 找到匹配的项后，跳出循环
      }
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
    List<int> rewardValues =
    List.generate(12, (_) => _rand.nextInt(coins) + 10);

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
    bool diceHit = false;

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