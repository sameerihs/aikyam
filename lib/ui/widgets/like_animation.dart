import 'package:flutter/material.dart';
import 'dart:math' as math;

typedef LikeButtonTapCallback = Future<bool?> Function(bool isLiked);

typedef LikeWidgetBuilder = Widget? Function(bool isLiked);

typedef LikeCountWidgetBuilder = Widget? Function(
  int? likeCount,
  bool isLiked,
  String text,
);

enum LikeCountAnimationType {
  //no animation
  none,
  //animation only on change part
  part,
  //animation on all
  all,
}

///like count widget postion
///left of like widget
///right of like widget
enum CountPostion {
  left,
  right,
  top,
  bottom,
}

///return count widget with decoration
typedef CountDecoration = Widget? Function(
  Widget count,
  int? likeCount,
);

class CirclePainter extends CustomPainter {
  CirclePainter(
      {required this.outerCircleRadiusProgress,
      required this.innerCircleRadiusProgress,
      this.circleColor = const CircleColor(
          start: Color(0xFFFF5722), end: Color(0xFFFFC107))}) {
    //circlePaint..style = PaintingStyle.fill;
    _circlePaint.style = PaintingStyle.stroke;
    //maskPaint..blendMode = BlendMode.clear;
  }

  final Paint _circlePaint = Paint();
  //Paint maskPaint = new Paint();

  final double outerCircleRadiusProgress;
  final double innerCircleRadiusProgress;
  final CircleColor circleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    _updateCircleColor();
    // canvas.saveLayer(Offset.zero & size, Paint());
    // canvas.drawCircle(Offset(center, center),
    //     outerCircleRadiusProgress * center, circlePaint);
    // canvas.drawCircle(Offset(center, center),
    //     innerCircleRadiusProgress * center + 1, maskPaint);
    // canvas.restore();
    //flutter web don't support BlendMode.clear.
    final double strokeWidth = outerCircleRadiusProgress * center -
        (innerCircleRadiusProgress * center);
    if (strokeWidth > 0.0) {
      _circlePaint.strokeWidth = strokeWidth;
      canvas.drawCircle(Offset(center, center),
          outerCircleRadiusProgress * center, _circlePaint);
    }
  }

  void _updateCircleColor() {
    double colorProgress = clamp(outerCircleRadiusProgress, 0.5, 1.0);
    colorProgress = mapValueFromRangeToRange(colorProgress, 0.5, 1.0, 0.0, 1.0);
    _circlePaint.color =
        Color.lerp(circleColor.start, circleColor.end, colorProgress)!;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) {
      return true;
    }

    return oldDelegate is CirclePainter &&
        (oldDelegate.outerCircleRadiusProgress != outerCircleRadiusProgress ||
            oldDelegate.innerCircleRadiusProgress !=
                innerCircleRadiusProgress ||
            oldDelegate.circleColor.start != circleColor.start ||
            oldDelegate.circleColor.end != circleColor.end);
  }
}

class BubblesPainter extends CustomPainter {
  BubblesPainter({
    required this.currentProgress,
    this.bubblesCount = 7,
    this.color1 = const Color(0xFFFFC107),
    this.color2 = const Color(0xFFFF9800),
    this.color3 = const Color(0xFFFF5722),
    this.color4 = const Color(0xFFF44336),
  }) {
    _outerBubblesPositionAngle = 360.0 / bubblesCount;
    for (int i = 0; i < 4; i++) {
      _circlePaints.add(Paint()..style = PaintingStyle.fill);
    }
  }
  final double currentProgress;
  final int bubblesCount;
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  double _outerBubblesPositionAngle = 51.42;
  double _centerX = 0.0;
  double _centerY = 0.0;
  final List<Paint> _circlePaints = <Paint>[];

  double _maxOuterDotsRadius = 0.0;
  double _maxInnerDotsRadius = 0.0;
  double? _maxDotSize;

  double _currentRadius1 = 0.0;
  double? _currentDotSize1 = 0.0;
  double? _currentDotSize2 = 0.0;
  double _currentRadius2 = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    _centerX = size.width * 0.5;
    _centerY = size.height * 0.5;
    _maxDotSize = size.width * 0.05;
    _maxOuterDotsRadius = size.width * 0.5 - _maxDotSize! * 2;
    _maxInnerDotsRadius = 0.8 * _maxOuterDotsRadius;

    _updateOuterBubblesPosition();
    _updateInnerBubblesPosition();
    _updateBubblesPaints();
    _drawOuterBubblesFrame(canvas);
    _drawInnerBubblesFrame(canvas);
  }

  void _drawOuterBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0;
    for (int i = 0; i < bubblesCount; i++) {
      final double cX = _centerX +
          _currentRadius1 *
              math.cos(degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY +
          _currentRadius1 *
              math.sin(degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize1!,
          _circlePaints[i % _circlePaints.length]);
    }
  }

  void _drawInnerBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0 -
        _outerBubblesPositionAngle / 2.0;
    for (int i = 0; i < bubblesCount; i++) {
      final double cX = _centerX +
          _currentRadius2 *
              math.cos(degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY +
          _currentRadius2 *
              math.sin(degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize2!,
          _circlePaints[(i + 1) % _circlePaints.length]);
    }
  }

  void _updateOuterBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius1 = mapValueFromRangeToRange(
          currentProgress, 0.0, 0.3, 0.0, _maxOuterDotsRadius * 0.8);
    } else {
      _currentRadius1 = mapValueFromRangeToRange(currentProgress, 0.3, 1.0,
          0.8 * _maxOuterDotsRadius, _maxOuterDotsRadius);
    }
    if (currentProgress == 0) {
      _currentDotSize1 = 0;
    } else if (currentProgress < 0.7) {
      _currentDotSize1 = _maxDotSize;
    } else {
      _currentDotSize1 = mapValueFromRangeToRange(
          currentProgress, 0.7, 1.0, _maxDotSize!, 0.0);
    }
  }

  void _updateInnerBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius2 = mapValueFromRangeToRange(
          currentProgress, 0.0, 0.3, 0.0, _maxInnerDotsRadius);
    } else {
      _currentRadius2 = _maxInnerDotsRadius;
    }
    if (currentProgress == 0) {
      _currentDotSize2 = 0;
    } else if (currentProgress < 0.2) {
      _currentDotSize2 = _maxDotSize;
    } else if (currentProgress < 0.5) {
      _currentDotSize2 = mapValueFromRangeToRange(
          currentProgress, 0.2, 0.5, _maxDotSize!, 0.3 * _maxDotSize!);
    } else {
      _currentDotSize2 = mapValueFromRangeToRange(
          currentProgress, 0.5, 1.0, _maxDotSize! * 0.3, 0.0);
    }
  }

  void _updateBubblesPaints() {
    final double progress = clamp(currentProgress, 0.6, 1.0);
    final int alpha =
        mapValueFromRangeToRange(progress, 0.6, 1.0, 255.0, 0.0).toInt();
    if (currentProgress < 0.5) {
      final double progress =
          mapValueFromRangeToRange(currentProgress, 0.0, 0.5, 0.0, 1.0);
      _circlePaints[0].color =
          Color.lerp(color1, color2, progress)!.withAlpha(alpha);
      _circlePaints[1].color =
          Color.lerp(color2, color3, progress)!.withAlpha(alpha);
      _circlePaints[2].color =
          Color.lerp(color3, color4, progress)!.withAlpha(alpha);
      _circlePaints[3].color =
          Color.lerp(color4, color1, progress)!.withAlpha(alpha);
    } else {
      final double progress =
          mapValueFromRangeToRange(currentProgress, 0.5, 1.0, 0.0, 1.0);
      _circlePaints[0].color =
          Color.lerp(color2, color3, progress)!.withAlpha(alpha);
      _circlePaints[1].color =
          Color.lerp(color3, color4, progress)!.withAlpha(alpha);
      _circlePaints[2].color =
          Color.lerp(color4, color1, progress)!.withAlpha(alpha);
      _circlePaints[3].color =
          Color.lerp(color1, color2, progress)!.withAlpha(alpha);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) {
      return true;
    }

    return oldDelegate is BubblesPainter &&
        (oldDelegate.bubblesCount != bubblesCount ||
            oldDelegate.currentProgress != currentProgress ||
            oldDelegate.color1 != color1 ||
            oldDelegate.color2 != color2 ||
            oldDelegate.color3 != color3 ||
            oldDelegate.color4 != color4);
  }
}

num degToRad(num deg) => deg * (math.pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / math.pi);

double mapValueFromRangeToRange(double value, double fromLow, double fromHigh,
    double toLow, double toHigh) {
  return toLow + ((value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow));
}

double clamp(double value, double low, double high) {
  return math.min(math.max(value, low), high);
}

///CHANGE COLORS HERE
Widget defaultWidgetBuilder(bool isLiked, double size) {
  if (isLiked == false) {
    return Icon(
      Icons.favorite_border_sharp,
      color: Colors.black12,
      size: size,
    );
  } else {
    return Icon(
      Icons.favorite,
      color: isLiked ? const Color(0xFF643843) : const Color(0xFFBE9BA4),
      size: size,
    );
  }
}
/////
//

////
class LikeButton2 extends StatefulWidget {
  const LikeButton2({
    Key? key,
    this.size = 30.0,
    this.likeBuilder,
    this.countBuilder,
    double? bubblesSize,
    double? circleSize,
    this.likeCount,
    this.isLiked = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.likeCountAnimationType = LikeCountAnimationType.part,
    this.likeCountAnimationDuration = const Duration(milliseconds: 500),
    this.likeCountPadding = const EdgeInsets.only(left: 3.0),
    this.bubblesColor = const BubblesColor(
      dotPrimaryColor: Color(0xFFFFC107),
      dotSecondaryColor: Color(0xFFFF9800),
      dotThirdColor: Color(0xFFFF5722),
      dotLastColor: Color(0xFF643843),
    ),
    this.circleColor =
        const CircleColor(start: Color(0xFFFF5722), end: Color(0xFFFFC107)),
    this.onTap,
    this.countPostion = CountPostion.right,
    this.padding,
    this.countDecoration,
    this.postFrameCallback,
  })  : bubblesSize = bubblesSize ?? size * 2.0,
        circleSize = circleSize ?? size * 0.8,
        super(key: key);

  /// size of like widget
  final double size;

  /// animation duration to change isLiked state
  final Duration animationDuration;

  /// total size of bubbles
  final double bubblesSize;

  /// colors of bubbles
  final BubblesColor bubblesColor;

  /// size of circle
  final double circleSize;

  /// colors of circle
  final CircleColor circleColor;

  /// tap call back of like button
  final LikeButtonTapCallback? onTap;

  /// whether it is liked
  /// it's initial value
  /// you can get current value from onTap/countBuilder
  final bool? isLiked;

  /// like count
  /// if null, will not show
  /// it's initial value
  /// you can get current value from countBuilder
  final int? likeCount;

  /// mainAxisAlignment for like button
  final MainAxisAlignment mainAxisAlignment;

  /// crossAxisAlignment for like button
  final CrossAxisAlignment crossAxisAlignment;

  /// builder to create like widget
  final LikeWidgetBuilder? likeBuilder;

  /// builder to create like count widget
  final LikeCountWidgetBuilder? countBuilder;

  /// animation duration to change like count
  final Duration likeCountAnimationDuration;

  /// animation type to change like count(none,part,all)
  final LikeCountAnimationType likeCountAnimationType;

  /// padding for like count widget
  final EdgeInsetsGeometry? likeCountPadding;

  /// like count widget postion
  /// left of like widget
  /// right of like widget
  /// top of like widget
  /// bottom of like widget
  final CountPostion countPostion;

  /// padding of like button
  final EdgeInsetsGeometry? padding;

  /// return count widget with decoration
  final CountDecoration? countDecoration;

  /// call back of first frame with LikeButtonState
  final Function(LikeButton2State state)? postFrameCallback;

  @override
  State<StatefulWidget> createState() => LikeButton2State();
}

class LikeButton2State extends State<LikeButton2>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bubblesAnimation;
  late Animation<Offset> _slidePreValueAnimation;
  late Animation<Offset> _slideCurrentValueAnimation;
  AnimationController? _likeCountController;
  late Animation<double> _opacityAnimation;

  AnimationController? get controller => _controller;
  AnimationController? get likeCountController => _likeCountController;

  bool? _isLiked = false;
  int? _likeCount;
  int? _preLikeCount;

  bool? get isLiked => _isLiked;
  int? get likeCount => _likeCount;
  int? get preLikeCount => _preLikeCount;
  @override
  void initState() {
    super.initState();

    _isLiked = widget.isLiked;

    _likeCount = widget.likeCount;
    _preLikeCount = _likeCount;

    _controller =
        AnimationController(duration: widget.animationDuration, vsync: this);
    _likeCountController = AnimationController(
        duration: widget.likeCountAnimationDuration, vsync: this);

    _initAnimations();

    if (widget.postFrameCallback != null) {
      // ignore: unnecessary_cast
      (WidgetsBinding.instance as WidgetsBinding)
          .addPostFrameCallback((Duration timeStamp) {
        widget.postFrameCallback!.call(this);
      });
    }
  }

  @override
  void didUpdateWidget(LikeButton2 oldWidget) {
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
    _preLikeCount = _likeCount;

    if (_controller?.duration != widget.animationDuration) {
      _controller?.dispose();
      _controller =
          AnimationController(duration: widget.animationDuration, vsync: this);
      _initControlAnimation();
    }

    if (_likeCountController?.duration != widget.likeCountAnimationDuration) {
      _likeCountController?.dispose();
      _likeCountController = AnimationController(
          duration: widget.likeCountAnimationDuration, vsync: this);
      _initLikeCountControllerAnimation();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller!.dispose();
    _likeCountController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget likeCountWidget = _getLikeCountWidget();
    if (widget.countDecoration != null) {
      likeCountWidget = widget.countDecoration!(likeCountWidget, _likeCount) ??
          likeCountWidget;
    }
    if (widget.likeCountPadding != null) {
      likeCountWidget = Padding(
        padding: widget.likeCountPadding!,
        child: likeCountWidget,
      );
    }

    List<Widget> children = <Widget>[
      AnimatedBuilder(
        animation: _controller!,
        builder: (BuildContext c, Widget? w) {
          final Widget likeWidget =
              widget.likeBuilder?.call(_isLiked ?? true) ??
                  defaultWidgetBuilder(_isLiked ?? true, widget.size);
          return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                top: (widget.size - widget.bubblesSize) / 2.0,
                left: (widget.size - widget.bubblesSize) / 2.0,
                child: CustomPaint(
                  size: Size(widget.bubblesSize, widget.bubblesSize),
                  painter: BubblesPainter(
                    currentProgress: _bubblesAnimation.value,
                    color1: widget.bubblesColor.dotPrimaryColor,
                    color2: widget.bubblesColor.dotSecondaryColor,
                    color3: widget.bubblesColor.dotThirdColorReal,
                    color4: widget.bubblesColor.dotLastColorReal,
                  ),
                ),
              ),
              Positioned(
                top: (widget.size - widget.circleSize) / 2.0,
                left: (widget.size - widget.circleSize) / 2.0,
                child: CustomPaint(
                  size: Size(widget.circleSize, widget.circleSize),
                  painter: CirclePainter(
                    innerCircleRadiusProgress: _innerCircleAnimation.value,
                    outerCircleRadiusProgress: _outerCircleAnimation.value,
                    circleColor: widget.circleColor,
                  ),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: ((_isLiked ?? true) && _controller!.isAnimating)
                      ? _scaleAnimation.value
                      : 1.0,
                  child: SizedBox(
                    child: likeWidget,
                    height: widget.size,
                    width: widget.size,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      likeCountWidget
    ];

    if (widget.countPostion == CountPostion.left ||
        widget.countPostion == CountPostion.top) {
      children = children.reversed.toList();
    }
    Widget result = (widget.countPostion == CountPostion.left ||
            widget.countPostion == CountPostion.right)
        ? Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            crossAxisAlignment: widget.crossAxisAlignment,
            children: children,
          )
        : Column(
            mainAxisAlignment: widget.mainAxisAlignment,
            crossAxisAlignment: widget.crossAxisAlignment,
            children: children,
          );

    if (widget.padding != null) {
      result = Padding(
        padding: widget.padding!,
        child: result,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: result,
    );
  }

  Widget _getLikeCountWidget() {
    if (_likeCount == null) {
      return Container();
    }
    final String likeCount = _likeCount.toString();
    final String preLikeCount = _preLikeCount.toString();

    int didIndex = 0;
    if (preLikeCount.length == likeCount.length) {
      for (; didIndex < likeCount.length; didIndex++) {
        if (likeCount[didIndex] != preLikeCount[didIndex]) {
          break;
        }
      }
    }
    final bool allChange =
        preLikeCount.length != likeCount.length || didIndex == 0;

    Widget result;

    if (widget.likeCountAnimationType == LikeCountAnimationType.none ||
        _likeCount == _preLikeCount) {
      result = _createLikeCountWidget(
          _likeCount, _isLiked ?? true, _likeCount.toString());
    } else if (widget.likeCountAnimationType == LikeCountAnimationType.part &&
        !allChange) {
      final String samePart = likeCount.substring(0, didIndex);
      final String preText =
          preLikeCount.substring(didIndex, preLikeCount.length);
      final String text = likeCount.substring(didIndex, likeCount.length);
      final Widget preSameWidget =
          _createLikeCountWidget(_preLikeCount, !(_isLiked ?? true), samePart);
      final Widget currentSameWidget =
          _createLikeCountWidget(_likeCount, _isLiked ?? true, samePart);
      final Widget preWidget =
          _createLikeCountWidget(_preLikeCount, !(_isLiked ?? true), preText);
      final Widget currentWidget =
          _createLikeCountWidget(_likeCount, _isLiked ?? true, text);

      result = AnimatedBuilder(
          animation: _likeCountController!,
          builder: (BuildContext b, Widget? w) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    fit: StackFit.passthrough,
                    clipBehavior: Clip.hardEdge,
                    children: <Widget>[
                      Opacity(
                        child: currentSameWidget,
                        opacity: _opacityAnimation.value,
                      ),
                      Opacity(
                        child: preSameWidget,
                        opacity: 1.0 - _opacityAnimation.value,
                      ),
                    ],
                  ),
                  Stack(
                    fit: StackFit.passthrough,
                    clipBehavior: Clip.hardEdge,
                    children: <Widget>[
                      FractionalTranslation(
                          translation: _preLikeCount! > _likeCount!
                              ? _slideCurrentValueAnimation.value
                              : -_slideCurrentValueAnimation.value,
                          child: currentWidget),
                      FractionalTranslation(
                          translation: _preLikeCount! > _likeCount!
                              ? _slidePreValueAnimation.value
                              : -_slidePreValueAnimation.value,
                          child: preWidget),
                    ],
                  )
                ],
              ),
            );
          });
    } else {
      result = AnimatedBuilder(
        animation: _likeCountController!,
        builder: (BuildContext b, Widget? w) {
          return Stack(
            fit: StackFit.passthrough,
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              FractionalTranslation(
                  translation: _preLikeCount! > _likeCount!
                      ? _slideCurrentValueAnimation.value
                      : -_slideCurrentValueAnimation.value,
                  child: _createLikeCountWidget(
                      _likeCount, _isLiked ?? true, _likeCount.toString())),
              FractionalTranslation(
                  translation: _preLikeCount! > _likeCount!
                      ? _slidePreValueAnimation.value
                      : -_slidePreValueAnimation.value,
                  child: _createLikeCountWidget(_preLikeCount,
                      !(_isLiked ?? true), _preLikeCount.toString())),
            ],
          );
        },
      );
    }

    result = ClipRect(
      child: result,
      clipper: LikeCountClip(),
    );

    return result;
  }

  Widget _createLikeCountWidget(int? likeCount, bool isLiked, String text) {
    return widget.countBuilder?.call(likeCount, isLiked, text) ??
        Text(text, style: const TextStyle(color: Colors.grey));
  }

  void onTap() {
    if (_controller!.isAnimating || _likeCountController!.isAnimating) {
      return;
    }
    if (widget.onTap != null) {
      widget.onTap!(_isLiked ?? true).then((bool? isLiked) {
        _handleIsLikeChanged(isLiked);
      });
    } else {
      _handleIsLikeChanged(!(_isLiked ?? true));
    }
  }

  void _handleIsLikeChanged(bool? isLiked) {
    if (_isLiked == null) {
      if (_likeCount != null) {
        _preLikeCount = _likeCount;
        _likeCount = _likeCount! + 1;
      }
      if (mounted) {
        setState(() {
          _controller!.reset();
          _controller!.forward();

          if (widget.likeCountAnimationType != LikeCountAnimationType.none) {
            _likeCountController!.reset();
            _likeCountController!.forward();
          }
        });
      }
      return;
    }

    if (isLiked != null && isLiked != _isLiked) {
      if (_likeCount != null) {
        _preLikeCount = _likeCount;
        if (isLiked) {
          _likeCount = _likeCount! + 1;
        } else {
          _likeCount = _likeCount! - 1;
        }
      }
      _isLiked = isLiked;

      if (mounted) {
        setState(() {
          if (_isLiked!) {
            _controller!.reset();
            _controller!.forward();
          }
          if (widget.likeCountAnimationType != LikeCountAnimationType.none) {
            _likeCountController!.reset();
            _likeCountController!.forward();
          }
        });
      }
    }
  }

  void _initAnimations() {
    _initControlAnimation();
    _initLikeCountControllerAnimation();
  }

  void _initLikeCountControllerAnimation() {
    _slidePreValueAnimation = _likeCountController!.drive(Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 1.0),
    ));
    _slideCurrentValueAnimation = _likeCountController!.drive(Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ));

    _opacityAnimation = _likeCountController!.drive(Tween<double>(
      begin: 0.0,
      end: 1.0,
    ));
  }

  void _initControlAnimation() {
    _outerCircleAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );
    _innerCircleAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
    final Animation<double> animate = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.35,
          0.7,
          curve: OvershootCurve(),
        ),
      ),
    );
    _scaleAnimation = animate;
    _bubblesAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}

class BubblesColor {
  const BubblesColor({
    required this.dotPrimaryColor,
    required this.dotSecondaryColor,
    this.dotThirdColor,
    this.dotLastColor,
  });
  final Color dotPrimaryColor;
  final Color dotSecondaryColor;
  final Color? dotThirdColor;
  final Color? dotLastColor;
  Color get dotThirdColorReal => dotThirdColor ?? dotPrimaryColor;

  Color get dotLastColorReal => dotLastColor ?? dotSecondaryColor;
}

class CircleColor {
  const CircleColor({
    required this.start,
    required this.end,
  });
  final Color start;
  final Color end;
}

class OvershootCurve extends Curve {
  const OvershootCurve([this.period = 2.5]);

  final double period;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    t -= 1.0;
    return t * t * ((period + 1) * t + period) + 1.0;
  }

  @override
  String toString() {
    return '$runtimeType($period)';
  }
}

class LikeCountClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Offset.zero & size;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
