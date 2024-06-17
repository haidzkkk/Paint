
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:paint/data/controller/paint_controller.dart';
import 'package:paint/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class OptionWidget extends StatefulWidget {
  const OptionWidget({super.key});

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<PaintController>(
      builder: (context, ctrl, widget) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: ctrl.optionBarExpanded == OptionBarExpanded.collapse 
              ? 50 
              : MediaQuery.of(context).size.width * 0.8,
          height: ctrl.optionBarExpanded == OptionBarExpanded.bigExpand 
              ? MediaQuery.of(context).size.height * 0.5 
              : ctrl.optionBarExpanded == OptionBarExpanded.smallExpand
              ? MediaQuery.of(context).size.height * 0.2
              : 50,
          padding: const EdgeInsetsDirectional.all(5),
          decoration: BoxDecoration(
            color: ctrl.optionBarExpanded == OptionBarExpanded.collapse
                ? Colors.blue
                : Colors.white ,
            border: ctrl.optionBarExpanded == OptionBarExpanded.collapse 
                ? null
                : Border.all(color: Colors.blue, width: 1),
            borderRadius: BorderRadiusDirectional.all(Radius.circular( ctrl.optionBarExpanded == OptionBarExpanded.collapse
                ? 100 
                : 10
            ))
          ),
          child: ctrl.optionBarExpanded == OptionBarExpanded.collapse
              ? InkWell(
                onTap: (){
                  ctrl.changeOptionBarExpanded(OptionBarExpanded.bigExpand);
                },
                child: const Icon(Icons.edit, color: Colors.white,)

              ): Stack(
                children: [
                  ListView(
                    children: [
                      const Text("Shapes", style: TextStyle(fontSize: 14)),
                      const Divider(),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          iconBox(
                            ctrl: ctrl,
                            icon: Icons.edit,
                            label: 'Pencil',
                            option: OptionPaint.draw,
                          ),
                          iconBox(
                            ctrl: ctrl,
                            icon: Icons.rectangle_rounded,
                            label: 'Eraser',
                            option: OptionPaint.eraser,
                          ),
                          iconBox(
                            ctrl: ctrl,
                            icon: Icons.remove,
                            label: 'Line',
                            option: OptionPaint.line,
                          ),
                          iconBox(
                            ctrl: ctrl,
                            icon: Icons.rectangle_outlined,
                            label: 'Rectangle',
                            option: OptionPaint.rectangle,
                          ),
                          iconBox(
                            ctrl: ctrl,
                            icon: Icons.circle_outlined,
                            label: 'Rectangle',
                            option: OptionPaint.circle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      const Text("Color", style: TextStyle(fontSize: 14)),
                      const Divider(),
                      Wrap(
                        children: [
                          boxColor(ctrl, Colors.black),
                          boxColor(ctrl, Colors.white),
                          boxColor(ctrl, Colors.red),
                          boxColor(ctrl, Colors.green),
                          boxColor(ctrl, Colors.blue),
                          boxColor(ctrl, Colors.yellow),
                          boxColor(ctrl, Colors.amberAccent),
                          boxColor(ctrl, Colors.pinkAccent),
                          boxColor(ctrl, Colors.purpleAccent),
                          boxColor(ctrl, Colors.teal),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          boxColor(ctrl, ctrl.selectedColor),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: (){
                              showPickColor(ctrl);
                            },
                              child: Assets.img.color.image(width: 30, height: 30)
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text("Background color", style: TextStyle(fontSize: 14)),
                      const Divider(),
                      Wrap(
                        children: [
                          boxColor(ctrl, Colors.black, true),
                          boxColor(ctrl, Colors.white, true),
                          boxColor(ctrl, Colors.red, true),
                          boxColor(ctrl, Colors.green, true),
                          boxColor(ctrl, Colors.blue, true),
                          boxColor(ctrl, Colors.yellow, true),
                          boxColor(ctrl, Colors.amberAccent, true),
                          boxColor(ctrl, Colors.pinkAccent, true),
                          boxColor(ctrl, Colors.purpleAccent, true),
                          boxColor(ctrl, Colors.teal, true),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          boxColor(ctrl, ctrl.backgroundColor, true),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: (){
                              showPickColor(ctrl, true);
                            },
                              child: Assets.img.color.image(width: 30, height: 30)
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text("Size", style: TextStyle(fontSize: 14)),
                      const Divider(),
                      itemSize(
                          value: ctrl.strokeSize,
                          label: "stroke size",
                          onChange: (value){
                            ctrl.changeStrokeSize(value);
                          }
                      ),
                      itemSize(
                          value: ctrl.eraserSize,
                          label: "eraser size",
                          onChange: (value){
                            ctrl.changeEraserSize(value);
                          }
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text("", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      GestureDetector(
                          onTap: (){
                            ctrl.changeOptionBarExpanded(OptionBarExpanded.collapse);
                          },
                          child: const Icon(Icons.close,)

                      )
                    ],
                  ),
                ],
              )
            );
      }
    );
  }

  Widget boxColor(PaintController ctrl ,Color color, [bool? isBackground]){
    return GestureDetector(
      onTap: (){
        if(isBackground == true){
          ctrl.changeBackgroundColor(color);
        }else{
          ctrl.changeColor(color);
        }
      },
      child: Container(
        height: 25,
        width: 25,
        margin: const EdgeInsetsDirectional.all(1),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: (isBackground == true
                ? ctrl.backgroundColor.value
                : ctrl.selectedColor.value) == color.value
                  ? Colors.blue
                  : Colors.grey,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }

  void showPickColor(PaintController ctrl, [bool? isBackground]){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: ctrl.selectedColor,
          onColorChanged: (value) {
            if(isBackground == true){
              ctrl.changeBackgroundColor(value);
            }else{
              ctrl.changeColor(value);
            }
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Done'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ));
  }
}

  Widget iconBox({
    required PaintController ctrl,
    required IconData icon,
    required OptionPaint option,
    String? label
}){
    bool isSelected = option == ctrl.currentDrawOption;

    return GestureDetector(
      onTap: (){
        ctrl.changeOption(option);
      },
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.grey[900]! : Colors.grey,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Tooltip(
          message: label,
          preferBelow: false,
          child:  Icon(icon, color: isSelected ? Colors.grey[900] : Colors.grey, size: 20,),
        ),
      ),
    );
  }

  Widget itemSize({
    required double value,
    required String label,
    required Function(double) onChange,
}){
    return Row(
      children: [
        const SizedBox(width: 10,),
        Text('$label: ', style: const TextStyle(fontSize: 12),),
        Expanded(
          child: Slider(
            thumbColor: Colors.blue,
            activeColor: Colors.blue,
            value: value,
            min: 0,
            max: 50,
            onChanged: onChange,
          ),
        ),
        SizedBox(
          width: 20,
          child: Text(
            '${value.toInt()}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
