import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';

class CustomCheckBox extends StatefulWidget {
  final Function()? onTap;
  final bool trigger;
  final Color color;
  final Color checkColor;
  const CustomCheckBox({
    super.key,
    this.onTap,
    required this.trigger,
    required this.color,
    required this.checkColor,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        margin: const EdgeInsets.fromLTRB(15, 0, 10, 0),
        duration: const Duration(milliseconds: 150),
        height: 24,
        width: 24,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: widget.trigger ? widget.color : Colors.transparent,
          border: Border.all(
            color: widget.color.withOpacity(0.5),
          ),
        ),
        child: SvgPicture.asset(
          "assets/icons/check.svg",
          color: widget.trigger
              ? widget.checkColor
              : widget.color.withOpacity(0.5),
        ),
      ),
    );
  }
}
