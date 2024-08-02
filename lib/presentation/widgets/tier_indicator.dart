import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wietapp/data/models/tier.dart';

class TierIndicator extends StatelessWidget {
  final List<Tier> tiers;
  final String currentTierName;
  final int currentPoints;

  const TierIndicator({
    Key? key,
    required this.tiers,
    required this.currentTierName,
    required this.currentPoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: const Size(320, 320),
        painter: TierIndicatorPainter(tiers, currentTierName, currentPoints),
      ),
    );
  }
}

class TierIndicatorPainter extends CustomPainter {
  final List<Tier> tiers;
  final String currentTierName;
  final int currentPoints;

  TierIndicatorPainter(this.tiers, this.currentTierName, this.currentPoints);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double outerRadius = min(size.width, size.height) / 2 - 50;
    final double tierNameRadius = outerRadius - 20;
    final double pointTextRadius = outerRadius + 35;
    double startAngle = -pi / 2;
    const double segmentPadding = 0.02;
    final double sweepAngle = (2 * pi / tiers.length) - segmentPadding * 2;

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40;

    Tier? currentTier;
    double currentTierStartAngle = startAngle;

    for (var tier in tiers) {
      paint.color =
          Color(int.parse('FF${tier.bgColor.substring(1)}', radix: 16));
      canvas.drawArc(Rect.fromCircle(center: center, radius: outerRadius),
          startAngle, sweepAngle, false, paint);
      drawAlignedText(canvas, tier.tierName, center,
          startAngle + segmentPadding, sweepAngle, tierNameRadius, true);
      drawCurvedText(canvas, '${tier.minPoint}-${tier.maxPoint}', center,
          startAngle, sweepAngle, pointTextRadius);

      if (tier.tierName == currentTierName) {
        currentTier = tier;
        currentTierStartAngle = startAngle;
      }
      startAngle += sweepAngle + segmentPadding * 2;
    }

    if (currentTier == null) {
      throw Exception('Current tier is not defined in the tiers list.');
    }

    // Draw current tier indicator
    double progressRatio = (currentPoints - currentTier.minPoint) /
        (currentTier.maxPoint - currentTier.minPoint);
    double indicatorAngle = currentTierStartAngle + progressRatio * sweepAngle;
    drawIndicator(canvas, center, outerRadius, indicatorAngle);

    drawCenterText(canvas, center, currentTierName, currentPoints.toString(),
        'TIER CREDITS\nTO NEXT TIER');
  }

  void drawIndicator(
      Canvas canvas, Offset center, double radius, double angle) {
    Paint indicatorPaint = Paint()
      ..color = Colors.black // Adjust the color as needed
      ..strokeWidth = 5; // Set the thickness of the indicator

    // Set the starting point just outside the outer radius
    final Offset startPoint =
        center + Offset(cos(angle), sin(angle)) * (radius + 5);
    // Set the ending point 5px inside the inner edge of the arc
    final double innerRadius =
        radius - 40; // Assuming the arc's width is around 40px
    final Offset endPoint =
        center + Offset(cos(angle), sin(angle)) * (innerRadius - 5);

    // Draw the line from the start point to the end point
    canvas.drawLine(startPoint, endPoint, indicatorPaint);
  }

  void drawCenterText(Canvas canvas, Offset center, String tierLevel,
      String points, String description) {
    // Main style
    TextStyle mainStyle = const TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    TextStyle tierNameStyle = const TextStyle(
        color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold);
    TextStyle secondaryStyle = const TextStyle(
        color: Colors.black54, fontSize: 12, fontWeight: FontWeight.normal);

    // Building the rich text with different styles
    TextSpan span = TextSpan(children: [
      TextSpan(text: '$tierLevel\n', style: tierNameStyle),
      TextSpan(text: 'TIER LEVEL\n\n', style: secondaryStyle),
      TextSpan(text: '$points\n', style: mainStyle),
      TextSpan(text: description, style: secondaryStyle),
    ]);

    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(maxWidth: 200); // Adjust width if needed

    // Centering the text
    double x = center.dx - textPainter.width / 2;
    double y = center.dy - textPainter.height / 2;
    textPainter.paint(canvas, Offset(x, y));
  }

  void drawAlignedText(Canvas canvas, String text, Offset center,
      double startAngle, double sweepAngle, double radius, bool isTierName) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(
              color: Colors.white,
              fontSize: isTierName ? 16 : 14,
              fontWeight: isTierName ? FontWeight.bold : FontWeight.normal)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    double angle = startAngle + sweepAngle / 2;
    double x = center.dx + radius * cos(angle);
    double y = center.dy + radius * sin(angle);

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle + pi / 2);
    if (!isTierName) {
      canvas.translate(0, textPainter.height / 2);
    } else {
      canvas.translate(0, -textPainter.height / 2);
    }
    textPainter.paint(
        canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  void drawCurvedText(Canvas canvas, String text, Offset center,
      double startAngle, double sweepAngle, double radius) {
    // Adding internal padding for the text start and end within the arc
    const double textPaddingAngle =
        0.25; // Angle padding for text start and end
    double textStartAngle = startAngle + textPaddingAngle;
    double textSweepAngle = sweepAngle - 2 * textPaddingAngle;

    drawCurvedTextLine(
        canvas, text, center, textStartAngle, textSweepAngle, radius);
  }

  void drawCurvedTextLine(Canvas canvas, String text, Offset center,
      double startAngle, double sweepAngle, double radius) {
    double anglePerChar = sweepAngle / text.length;
    double startTextAngle = startAngle;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      TextPainter charPainter = TextPainter(
        text: TextSpan(
          text: char,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      charPainter.layout();

      double charAngle = startTextAngle +
          i * anglePerChar; // Center each character within its sub-angle
      double x = center.dx + radius * cos(charAngle);
      double y = center.dy + radius * sin(charAngle);

      canvas.save();
      canvas.translate(x, y);
      canvas
          .rotate(charAngle + pi / 2); // Adjust rotation to align text properly
      charPainter.paint(
          canvas, Offset(-charPainter.width / 2, -charPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
