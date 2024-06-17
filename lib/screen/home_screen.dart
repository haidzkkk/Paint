
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paint/data/controller/paint_controller.dart';
import 'package:paint/screen/widget/drag_widget.dart';
import 'package:paint/screen/widget/option_widget.dart';
import 'package:paint/screen/widget/paint_widget.dart';
import 'package:paint/screen/widget/tool_bar_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.read<PaintController>().backgroundColor,
        appBar: AppBar(
          title: const Text("PAINT", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 5),),
          backgroundColor: Colors.blue,
          actions: const [
            ToolBarScreen()
          ],
        ),
        body: const PaintWidget(),
        floatingActionButton: const DragWidget(
          hasAppBar: true,
          child: OptionWidget(),
        ),
      ),
    );
  }
}
