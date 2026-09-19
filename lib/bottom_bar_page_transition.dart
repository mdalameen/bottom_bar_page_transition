import 'dart:math' as math;

import 'package:flutter/material.dart';

class BottomBarPageTransition extends StatefulWidget {
  const BottomBarPageTransition({
    super.key,
    required this.builder,
    required this.currentIndex,
    required this.totalLength,
    this.transitionType = TransitionType.circular,
    this.transitionCurve = Curves.easeIn,
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  final IndexedWidgetBuilder builder;
  final int currentIndex;
  final int totalLength;
  final TransitionType transitionType;
  final Duration transitionDuration;
  final Curve transitionCurve;

  @override
  State<BottomBarPageTransition> createState() =>
      _BottomBarPageTransitionState();
}

class _BottomBarPageTransitionState extends State<BottomBarPageTransition>
    with TickerProviderStateMixin {
  int _displayingIndex = -1;
  int _animatingIndex = -1;
  int _tempAnimatingIndex = -1;
  int _index = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    );

    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.forward) {
        _tempAnimatingIndex = _animatingIndex;
      } else if (_animationController.status == AnimationStatus.dismissed) {
        if (_tempAnimatingIndex != -1) _displayingIndex = _tempAnimatingIndex;
      }

      if (_animationController.status == AnimationStatus.completed) {
        _displayingIndex = _animatingIndex;
        _animatingIndex = -1;
        _animationController.stop();
        _tempAnimatingIndex = -1;
      }

      setState(() {});
    });
    _index = widget.currentIndex;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_displayingIndex == -1) _displayingIndex = _index;
    if (_index != widget.currentIndex) {
      _index = widget.currentIndex;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _animatingIndex = widget.currentIndex;
        _animationController.duration = widget.transitionDuration;
        _animationController.reset();
        _animationController.forward();
      });
    }

    final canAnimate =
        _animatingIndex != -1 && _displayingIndex != _animatingIndex;

    return Stack(
      children: <Widget>[
        widget.builder(context, _displayingIndex),
        if (canAnimate && widget.transitionType == TransitionType.circular)
          ClipOval(
            clipper: _OvalClipper(
              widget.currentIndex,
              widget.totalLength,
              Tween(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: widget.transitionCurve))
                  .animate(_animationController)
                  .value,
            ),
            child: widget.builder(context, _animatingIndex),
          ),
        if (canAnimate && widget.transitionType == TransitionType.slide)
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset(_animatingIndex < _displayingIndex ? -1 : 1, 0),
              end: Offset.zero,
            )
                .chain(CurveTween(curve: widget.transitionCurve))
                .animate(_animationController),
            child: widget.builder(context, _animatingIndex),
          ),
        if (canAnimate && widget.transitionType == TransitionType.fade)
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: widget.transitionCurve))
                .animate(_animationController),
            child: widget.builder(context, _animatingIndex),
          ),
      ],
    );
  }
}

class _OvalClipper extends CustomClipper<Rect> {
  _OvalClipper(this.currentIndex, this.length, this.value);

  final int currentIndex;
  final int length;
  final double value;

  @override
  Rect getClip(Size size) {
    final step = currentIndex + size.width / length;
    final halfStep = step / 2;
    final d = math.sqrt(
          (size.width + halfStep) + (size.height + 30) * (size.height + 30),
        ) *
        2.5 *
        value;
    return Rect.fromCenter(
      center: Offset((currentIndex * step) + halfStep, size.height + 30),
      width: d,
      height: d,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    if (oldClipper is _OvalClipper) {
      return oldClipper.value != value ||
          oldClipper.currentIndex != currentIndex;
    }
    return true;
  }
}

enum TransitionType { circular, slide, fade }
