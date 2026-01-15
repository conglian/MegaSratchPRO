import 'dart:math';

class WheelItem {
  final String name;      // 命中的类型（例如：20, 50, 道具卡）
  final double probability; // 概率

  WheelItem({
    required this.name,
    required this.probability,
  });
}

class WheelSpin {
  // 创建一个包含所有命中类型的列表和其对应的概率
  final List<WheelItem> items;
  // 1000=道具卡
  WheelSpin() : items = [
    WheelItem(name: "50", probability: 0.1),
    WheelItem(name: "1000", probability: 0.3),
    WheelItem(name: "20", probability: 0.5),
    WheelItem(name: "80", probability: 0.07),
    WheelItem(name: "100", probability: 0.03),
  ];

  // 根据概率返回当前命中的类型
  int spinWheel() {
    final random = Random();
    double randomValue = random.nextDouble(); // 获取一个 [0, 1) 范围的随机数

    double cumulativeProbability = 0.0;
    for (var item in items) {
      cumulativeProbability += item.probability;

      // 如果随机值小于累计概率，则返回该项
      if (randomValue < cumulativeProbability) {
        return int.parse(item.name);
      }
    }
    // 默认返回空字符串，如果所有概率之和有问题，应该保证概率和为1
    return 20;
  }
}
