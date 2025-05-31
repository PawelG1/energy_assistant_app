import 'package:flutter/material.dart';

class SolarCalculatorPage extends StatefulWidget {
  const SolarCalculatorPage({super.key});
  
  @override
  State<SolarCalculatorPage> createState() => _SolarCalculatorPageState();
}

class _SolarCalculatorPageState extends State<SolarCalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('HITACHI', style: TextStyle(fontFamily: 'Helvetica',fontSize: 32, color: Colors.white),),
                      Text(' - Energy AI Assistant', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  Text('Twoja słoneczna Przyszłość', style: TextStyle(fontSize: 14, color: Colors.white)),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade600, Colors.orange.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              child:  Center(
                child: MediaQuery.of(context).size.width > 1200 ?
                  const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wb_sunny, size: 48, color: Colors.white),
                    SizedBox(height: 16),
                    Text('Zoptymalizuj swoją produkcję energii',
                     style: TextStyle(fontSize: 18, color: Colors.white),
                     textAlign: TextAlign.center,),
                  ],
                  )
                  : null
              ),
              ),
            ),
          )
        ],
      )
    );
  }


  @override
  void initState() {
    super.initState();
    //TODO: load statistical data
  }


}