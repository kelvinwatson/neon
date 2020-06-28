library neon;

import 'dart:math';

import 'package:flutter/material.dart';

import 'neon_char.dart';

enum EnegryLevel { Low, High }

class Neon extends StatefulWidget {
  final String text;
  final MaterialColor color;
  final double fontSize;
  final NeonFonts font;
  final bool flickeringText;
  final List<int> flickeringLetters;
  final double blurRadius;

  Neon(
      {@required this.text,
      @required this.color,
      @required this.font,
      this.fontSize = 30,
      this.blurRadius = 30,
      this.flickeringText = false,
      this.flickeringLetters,
      Key key})
      : super(key: key);

  @override
  _NeonState createState() => _NeonState();
}

class _NeonState extends State<Neon> with SingleTickerProviderStateMixin {
  List<EnegryLevel> _enegryLevels;
  // GlobalKey _widgetKey = GlobalKey();

  String get text => widget.text;
  MaterialColor get color => widget.color;
  double get fontSize => widget.fontSize;
  NeonFonts get font => widget.font;
  bool get flickeringText => widget.flickeringText;
  List<int> get flickeringLetters => widget.flickeringLetters;
  double get blurRadius => widget.blurRadius;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _enegryLevels = List(text.length);
    // initial high level of the light
    _changeEnergyLevels(EnegryLevel.High);
    if (flickeringText ||
        (flickeringLetters != null && flickeringLetters.length > 0)) {
      _waitForLowPower();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _preprocessText(),
    );
  }

  _afterLayout(_) {
    // var renderWidgetBox =
    //     _widgetKey.currentContext.findRenderObject() as RenderBox;
    // setState(() {
    //   _width = renderWidgetBox.size.width;
    //   _height = renderWidgetBox.size.height;
    // });
  }

  List<NeonChar> _preprocessText() {
    assert(text != null);

    List<NeonChar> list = [];
    for (var i = 0; i < text.length; i++) {
      list.add(NeonChar(
          text[i], color, font, fontSize, _enegryLevels[i], blurRadius));
    }
    return list;
  }

  void _waitForHighPower() async {
    Future.delayed(Duration(milliseconds: _random(150, 300)), () {
      _changeEnergyLevels(EnegryLevel.High, flickeringLetters);
    }).then((value) {
      _waitForLowPower();
    });
  }

  void _waitForLowPower() {
    Future.delayed(Duration(milliseconds: _random(500, 2500)), () {
      _changeEnergyLevels(EnegryLevel.Low, flickeringLetters);
    }).then((value) {
      _waitForHighPower();
    });
  }

  void _changeEnergyLevels(EnegryLevel level, [List<int> indexes]) {
    setState(() {
      if (indexes == null || indexes.length == 0) {
        for (var i = 0; i < text.length; i++) {
          _enegryLevels[i] = level;
        }
      } else {
        for (var index in indexes) {
          _enegryLevels[index] = level;
        }
      }
    });
  }

  int _random(int min, int max) {
    var rn = Random();
    return min + rn.nextInt(max - min);
  }
}

class GradientText extends StatelessWidget {
  GradientText(
    this.text, {
    @required this.gradient,
  });

  final String text;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          // The color must be set to white for this to work
          color: Colors.white,
          fontSize: 40,
        ),
      ),
    );
  }
}

enum NeonFonts {
  Beon,
  Monoton,
  Automania,
  LasEnter,
  TextMeOne,
  NightClub70s,
  Membra,
  Samarin,
  Cyberpunk
}

class Fonts {
  static const String Beon = 'packages/neon/Beon';
  static const String Monoton = 'packages/neon/Monoton';
  static const String Automania = 'packages/neon/Automania';
  static const String LasEnter = 'packages/neon/LasEnter';
  static const String TextMeOne = 'packages/neon/TextMeOne';
  static const String NightClub70s = 'packages/neon/Night-Club-70s';
  static const String Membra = 'packages/neon/Membra';
  static const String Samarin = 'packages/neon/Samarin';
  static const String Cyberpunk = 'packages/neon/Cyberpunk';
}
