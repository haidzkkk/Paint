
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paint/data/controller/paint_controller.dart';
import 'package:provider/provider.dart';

class DragWidget extends StatefulWidget {
  const DragWidget({super.key, required this.child, this.hasAppBar, this.hasBottomNav});

  final Widget child;
  final bool? hasAppBar;
  final bool? hasBottomNav;

  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  bool isHandlePostion = false;

  late Size _childSize;

  double? _top;
  double? _left;
  double _screenWidth = 0.0;
  double _screenHeight = 0.0;
  double? _screenWidthMid, _screenHeightMid;
  int _timeMiliDuration = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _childSize = context.size!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_top != null && _left != null && isHandlePostion){
      WidgetsBinding.instance
          .addPostFrameCallback((_) {
        _timeMiliDuration = 300;
        _left = handlePositionX(_left!);
        _top = handlePositionY(_top!);
        setState(() {});
      });
    }
    isHandlePostion = false;

    return Stack(
      children: [
        Consumer<PaintController>(
          builder: (context, ctrl, widgetCtrl) {
            return AnimatedPositioned(
                duration: Duration(milliseconds: _timeMiliDuration),
                top: ctrl.optionBarExpanded == OptionBarExpanded.bigExpand
                    && (_top ?? 0.0) > (_screenHeight * 0.5)
                    ? ((_top ?? 0) - ((_top ?? 0) -_screenHeight * 0.5))
                    : ctrl.optionBarExpanded == OptionBarExpanded.smallExpand
                    && (_top ?? 0.0) > (_screenHeight * 0.8)              /// 0.8 is opposite 0.2 in height of child
                    ? ((_top ?? 0) - ((_top ?? 0) -_screenHeight * 0.8))
                    : _top,
                left: ctrl.optionBarExpanded != OptionBarExpanded.collapse
                    && (_left ?? 0.0) > (_screenWidthMid ?? 0.0)
                    ? _screenWidth * 0.2
                    : _left,
                curve: Curves.easeInOutCirc,
                child: Draggable(
                  childWhenDragging: const SizedBox(width: 0.0,height: 0.0,),
                  feedback: Material(
                    color: Colors.transparent,
                    child: widget.child
                  ),
                  onDragEnd: _handleDragEnded,
                  child: widget.child,
                )
            );
          }
        )
      ],
    );
  }

  void _handleDragEnded(DraggableDetails draggableDetails) {
    _calculatePosition(draggableDetails.offset);
  }

  void _calculatePosition(Offset targetOffsetPosition) {
    if (_screenWidthMid == null || _screenHeightMid == null) {
      Size screenSize = MediaQuery.of(context).size;
      _screenWidth = screenSize.width;
      _screenHeight = screenSize.height;
      _screenWidthMid = _screenWidth / 2;
      _screenHeightMid = _screenHeight / 2;
    }

    isHandlePostion = true;
    _timeMiliDuration = 0;
    _left = targetOffsetPosition.dx;
    _top = targetOffsetPosition.dy;
    setState(() {});
  }

  double handlePositionX(double position){
    double value = 0;
    if(position < _screenWidthMid! - _childSize.width){
      value = 30;
    }else{
      value = _screenWidth - _childSize.width;
    }
    return value;
  }

  double handlePositionY(double position){
    double heightAppBar = widget.hasAppBar == true ? 80 : 0;
    double heightBottomNav = widget.hasBottomNav == true ? 80 : 0;
    double value = 0;

    /// above screen
    if(position < 0 + _childSize.width / 2 + heightAppBar){
      value = 0 + _childSize.width / 2 + heightAppBar;

     /// below screen
    }else if(position > _screenHeight - (_childSize.width + 5) - heightBottomNav){
      value = _screenHeight - (_childSize.width + 5);
    }else{
      value = position;
    }
    return value;
  }
}
