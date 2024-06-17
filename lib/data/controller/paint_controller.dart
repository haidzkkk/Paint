import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import  'package:image_gallery_saver/image_gallery_saver.dart';
import '../model/sketch.dart';

enum OptionPaint{
  draw,
  eraser,
  line,
  rectangle,
  circle
}

enum OptionBarExpanded{
  bigExpand,
  smallExpand,
  collapse,
}

class PaintController extends ChangeNotifier{
  final GlobalKey _canvasKey = GlobalKey();
  Color _backgroundColor = Colors.white;
  Color _selectedColor = Colors.black;
  double _strokeSize = 10;
  double _eraserSize = 10;
  OptionBarExpanded _optionBarExpanded = OptionBarExpanded.collapse;
  final List<Sketch> _sketches = [];
  final Queue<Sketch> _backupSketches = Queue();
  Sketch? _currentSketch;
  OptionPaint _currentDrawOption = OptionPaint.draw;

  Color get backgroundColor => _backgroundColor;
  Color get selectedColor => _selectedColor;
  double get strokeSize => _strokeSize;
  double get eraserSize => _eraserSize;
  OptionBarExpanded get optionBarExpanded => _optionBarExpanded;
  GlobalKey get canvasKey => _canvasKey;
  List<Sketch> get sketches => _sketches;
  Queue<Sketch> get backupSketches => _backupSketches;
  Sketch? get currentSketch => _currentSketch;
  OptionPaint? get currentDrawOption => _currentDrawOption;


  void changeBackgroundColor(Color color){
    _backgroundColor = color;
    notifyListeners();
  }

  void changeColor(Color color){
    _selectedColor = color;
    notifyListeners();
  }

  void changeStrokeSize(double size){
    _strokeSize = size;
    notifyListeners();
  }


  void changeEraserSize(double size){
    _eraserSize = size;
    notifyListeners();
  }

  void changeOption(OptionPaint option){
    _currentDrawOption = option;
    notifyListeners();
  }

  void changeOptionBarExpanded(OptionBarExpanded option){
    _optionBarExpanded = option;
    notifyListeners();
  }

  void currentDraw(Sketch data){
    _currentSketch = data;
    notifyListeners();
  }

  void addDraw(Sketch data){
    _sketches.add(data);
    _currentSketch = null;
    _backupSketches.clear();
    notifyListeners();
  }

  void backAction(){
    if(_sketches.isEmpty) return;
    var item = _sketches.last;
    _sketches.removeLast();
    _backupSketches.add(item);
    notifyListeners();
  }

  void forwardAction(){
    if(_backupSketches.isEmpty) return;
    var data = _backupSketches.removeLast();
    _sketches.add(data);
    notifyListeners();
  }

  void deleteAction(){
    if(_sketches.isEmpty) return;
    _sketches.clear();
    notifyListeners();
  }

  Future<bool> downloadImage(String name) async{
    RenderRepaintBoundary widget = canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await widget.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();

    if(pngBytes == null ){ print("Lỗi tải ảnh"); return false; }

    await ImageGallerySaver.saveImage(pngBytes);
    return true;
  }
}