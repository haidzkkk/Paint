
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paint/data/controller/paint_controller.dart';
import 'package:provider/provider.dart';

class ToolBarScreen extends StatefulWidget {
  const ToolBarScreen({super.key});

  @override
  State<ToolBarScreen> createState() => _ToolBarScreenState();
}

class _ToolBarScreenState extends State<ToolBarScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(5),
      margin: const EdgeInsetsDirectional.all(5),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.all(Radius.circular( 10))
      ),
      child: Consumer<PaintController>(
        builder: (context, ctrl, widget) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                  onPressed: ctrl.sketches.isEmpty ? null : (){
                    ctrl.backAction();
                  },
                  icon: Icon(Icons.arrow_back_sharp, color: ctrl.sketches.isEmpty ? Colors.grey : Colors.black,)
              ),
              IconButton(
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                  onPressed: ctrl.sketches.isEmpty ? null : (){
                    if(ctrl.backupSketches.isEmpty) return;
                    ctrl.forwardAction();
                  },
                  icon: Icon(Icons.arrow_forward_sharp, color: ctrl.backupSketches.isEmpty ? Colors.grey : Colors.black,)
              ),
              IconButton(
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                  onPressed: ctrl.sketches.isEmpty ? null : (){
                    if(ctrl.sketches.isEmpty) return;
                    ctrl.downloadImage("${DateTime.now()}")
                      .then((value){
                        if(value) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Save into gallery success")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Save failed")));
                        }
                    }).catchError((onError){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Save failed")));
                    });
                  },
                  icon: Icon(Icons.save_alt, color: ctrl.sketches.isEmpty ? Colors.grey : Colors.black,)
              ),
              IconButton(
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                  onPressed: ctrl.sketches.isEmpty ? null : (){
                    if(ctrl.sketches.isEmpty) return;
                    ctrl.deleteAction();
                  },
                  icon: Icon(Icons.delete_outline, color: ctrl.sketches.isEmpty ? Colors.grey : Colors.black,)
              ),
              IconButton(
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                  onPressed: (){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Haidzkkk is developing")));
                  },
                  icon: const Icon(Icons.settings_rounded, color: Colors.blue,)
              ),
            ],
          );
        }
      ),
    );
  }
}
