
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paint/data/controller/paint_controller.dart';
import 'package:paint/data/model/sketch.dart';
import 'package:provider/provider.dart';

class PaintWidget extends StatefulWidget {
  const PaintWidget({super.key});

  @override
  State<PaintWidget> createState() => _PaintWidgetState();
}

class _PaintWidgetState extends State<PaintWidget> {

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent details){
        var ctrl = context.read<PaintController>();

        if(ctrl.optionBarExpanded == OptionBarExpanded.bigExpand){
          ctrl.changeOptionBarExpanded(OptionBarExpanded.smallExpand);
        }

        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset offset = renderBox.globalToLocal(details.position);
        ctrl.currentDraw(Sketch(
            points: [offset],
            color: ctrl.selectedColor,
            size: ctrl.currentDrawOption == OptionPaint.eraser
                ? ctrl.eraserSize
                : ctrl.strokeSize,
            optionPaint: ctrl.currentDrawOption,
        ));
      },
      onPointerMove: (PointerMoveEvent details){
        var ctrl = context.read<PaintController>();

        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset offset = renderBox.globalToLocal(details.position);

        final points = List<Offset>.from(ctrl.currentSketch?.points ?? [])
          ..add(offset);
        ctrl.currentDraw(Sketch(
            points: points,
            color: ctrl.selectedColor,
            size: ctrl.currentDrawOption == OptionPaint.eraser
                ? ctrl.eraserSize
                : ctrl.strokeSize,
            optionPaint: ctrl.currentDrawOption,
        ));
      },
      onPointerUp: (PointerUpEvent details){
        var ctrl = context.read<PaintController>();
        ctrl.addDraw(ctrl.currentSketch!);
      },
      child: Consumer<PaintController>(
        builder: (context, ctrl, widget) {
          return RepaintBoundary(
            key: ctrl.canvasKey,
            child: Material(
              color: ctrl.backgroundColor,
              child: Stack(
                children: [
                  allDraw(ctrl),
                  currentDraw(ctrl),   /// when drawing, it will show in this widget
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget currentDraw(PaintController ctrl){
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: SketchPaint(
            backgroundColor: ctrl.backgroundColor,
            sketches: ctrl.currentSketch == null ? [] : [ctrl.currentSketch!],
          ),
        ),
      );
  }

  Widget allDraw(PaintController ctrl){
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: SketchPaint(
              backgroundColor: ctrl.backgroundColor,
              sketches: ctrl.sketches
          ),
        ),
      );
  }
}


class SketchPaint extends CustomPainter{

  final List<Sketch> sketches;
  final Color backgroundColor;

  SketchPaint({required this.sketches, required this.backgroundColor});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {

    for(Sketch sketch in sketches){
      Paint paint = Paint()
        ..color = OptionPaint.eraser == sketch.optionPaint ? backgroundColor : sketch.color
        ..strokeWidth = sketch.size
        ..style = PaintingStyle.stroke;
      Path path = Path();

      List<Offset> points = sketch.points;
      switch(sketch.optionPaint){
        case OptionPaint.draw || OptionPaint.eraser: {
          path.moveTo(points.first.dx, points.first.dy);

          for(int i = 1; i < points.length - 2; i++){
            final p0 = points[i];
            final p1 = points[i + 1];

            path.quadraticBezierTo(
              p0.dx,
              p0.dy,
              (p0.dx + p1.dx) / 2,
              (p0.dy + p1.dy) / 2,
            );
          }

          /// border radius first and last point
          final circlePaint = Paint()
            ..color = OptionPaint.eraser == sketch.optionPaint ? backgroundColor : sketch.color
            ..style = PaintingStyle.fill;
          canvas.drawCircle(points.first, paint.strokeWidth / 2, circlePaint);
          if(points.length > 2) canvas.drawCircle(points[points.length - 2], paint.strokeWidth / 2, circlePaint); /// bo cái gần cuối nữa cho nét
          canvas.drawCircle(points.last, paint.strokeWidth / 2, circlePaint);
        }
        case OptionPaint.line:{
          Offset firstPoint = points.first;
          Offset lastPoint = points.last;
          canvas.drawLine(firstPoint, lastPoint, paint);
        }
        case OptionPaint.rectangle:{
          Offset firstPoint = points.first;
          Offset lastPoint = points.last;
          Rect rect = Rect.fromPoints(firstPoint, lastPoint);
          canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(5)), paint);
        }
        case OptionPaint.circle:{
          Offset firstPoint = points.first;
          Offset lastPoint = points.last;
          Rect rect = Rect.fromPoints(firstPoint, lastPoint);
          canvas.drawOval(rect, paint);

        }
        default: {

        }
      }
      
      canvas.drawPath(path, paint);
    }
  }
}
