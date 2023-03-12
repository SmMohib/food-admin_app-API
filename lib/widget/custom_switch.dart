import 'package:admin_app/widget/brand_colors.dart';
import 'package:flutter/material.dart';

class MCustomSwitch extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? activeTogolColor;
  MCustomSwitch(
      {Key? key,
      this.value,
      this.onChanged,
      this.activeColor,
      this.activeTogolColor})
      : super(key: key);
  //   MCustomSwitch({Key key, this.value, this.onChanged, this.activeColor,required this.activeTogolColor})

  @override
  _MCustomSwitchState createState() => _MCustomSwitchState();
}

class _MCustomSwitchState extends State<MCustomSwitch>
    with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value! ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value! ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.linear));
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged!(true)
                : widget.onChanged!(false);
          },
          child: Container(
            width: 35.0,
            height: 18.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: _circleAnimation.value == Alignment.centerLeft
                    ? Colors.grey
                    : widget.activeColor),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0.0, right: 0.0, left: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _circleAnimation.value == Alignment.centerRight
                      ? Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 0.0),
                          child: Text(
                            '',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w900,
                                fontSize: 2.0),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Align(
                      alignment: _circleAnimation.value,
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _circleAnimation.value == Alignment.centerLeft
                                    ? aSearchFieldColor
                                    : widget.activeTogolColor),
                      ),
                    ),
                  ),
                  _circleAnimation.value == Alignment.centerLeft
                      ? Padding(
                          padding:
                              const EdgeInsets.only(left: 0.0, right: 18.0),
                          child: Text(
                            '',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w900,
                                fontSize: 2.0),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
