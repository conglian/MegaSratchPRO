import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MSText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final int maxLines;
  final TextAlign? align;
  final bool useType;
  final bool is_btn;

  const MSText(
      {required this.text,
      required this.size,
      required this.color,
      required this.weight,
      this.maxLines = 1,
      this.align,
      this.useType = false, this.is_btn = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;
    if (useType) {
      textStyle = TextStyle(fontSize: size, color: color, height: 1.15, fontWeight: weight, fontFamily: is_btn ? 'Atkinson' : 'Atkinson');
    } else {
      textStyle = TextStyle(fontSize: size, color: color, height: 1.15, fontWeight: weight, fontFamily: is_btn ? 'Atkinson' : 'Atkinson');
    }

    return Text(text, textAlign: align, maxLines: maxLines, overflow: TextOverflow.ellipsis, style: textStyle);
  }
}
class MSUnderlineTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double fontSize;
  final Color textColor;
  final Color? underlineColor;
  final double? thickness;
  final TextDecorationStyle decorationStyle;
  final EdgeInsetsGeometry? padding;

  /// ✅ 外部只需传入颜色列表
  final List<Color>? gradientColors;

  const MSUnderlineTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.fontSize = 14.0,
    this.textColor = Colors.white,
    this.underlineColor,
    this.thickness,
    this.decorationStyle = TextDecorationStyle.solid,
    this.padding,
    this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 如果外部传入了 gradientColors，则构造线性渐变
    final Gradient? gradient = (gradientColors != null && gradientColors!.length >= 2)
        ? LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: gradientColors!,
    )
        : null;

    final textWidget = Text(
      text,
      style: TextStyle(
        fontFamily: 'Atkinson',
        fontSize: fontSize,
        color: gradient == null ? textColor : Colors.white,
        decoration: TextDecoration.underline,
        decorationColor: underlineColor ?? textColor,
        decorationThickness: thickness ?? 1.0,
        decorationStyle: decorationStyle,
      ),
    );

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: padding ?? EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: gradient != null
          ? ShaderMask(
        shaderCallback: (bounds) =>
            gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        blendMode: BlendMode.srcIn,
        child: textWidget,
      )
          : textWidget,
    );
  }
}
class MSBouncyText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final bool enableAnimation;
  final Color borderColor;
  final double borderWidth;

  const MSBouncyText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    this.fontWeight = FontWeight.w800,
    this.enableAnimation = true,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
  });

  @override
  State<MSBouncyText> createState() => _MSBouncyTextState();
}

class _MSBouncyTextState extends State<MSBouncyText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _scale = Tween(begin: 0.85, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MSBouncyText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enableAnimation != widget.enableAnimation) {
      if (widget.enableAnimation) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildText() {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// 描边层
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Atkinson',
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = widget.borderWidth
              ..color = widget.borderColor,
          ),
        ),

        /// 正常文字层
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Atkinson',
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            color: widget.color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableAnimation) {
      return _buildText();
    }

    return ScaleTransition(
      scale: _scale,
      child: _buildText(),
    );
  }
}
