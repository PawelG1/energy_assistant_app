import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ThreeJSWebViewPage extends StatefulWidget {
  const ThreeJSWebViewPage({super.key});

  @override
  State<ThreeJSWebViewPage> createState() => _ThreeJSWebViewPageState();
}

class _ThreeJSWebViewPageState extends State<ThreeJSWebViewPage> {
  late final WebViewController _controller;
  double hour = 12;

  @override
  void initState() {
    super.initState();
    // Updated WebView initialization - safer approach
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _updateSunPosition(hour);
          },
        ),
      )
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Solar Panel Shadow</title>
          <style>
            body { margin: 0; overflow: hidden; }
            iframe { width: 100%; height: 100vh; border: none; }
          </style>
        </head>
        <body>
          <iframe src="assets/panel_sim.html" id="simFrame"></iframe>
          <script>
            window.addEventListener('message', function(event) {
              const iframe = document.getElementById('simFrame');
              if (iframe && iframe.contentWindow) {
                iframe.contentWindow.postMessage(event.data, '*');
              }
            });
          </script>
        </body>
        </html>
      ''');
  }

  void _updateSunPosition(double newHour) {
    setState(() {
      hour = newHour;
    });

    // Run JavaScript to update sun position
    _controller.runJavaScript('window.postMessage("$hour", "*");');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            title: const Text('HITACHI',  
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Helvetica', color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red.shade600, Colors.orange.shade500],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Spacer(),
                        const Icon(Icons.wb_sunny, size: 48, color: Colors.white),
                        const SizedBox(height: 12),
                        const Text(
                          'Symulacja cienia paneli słonecznych',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        const Text('Wizualizacja 3D',
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wizualizacja paneli i cieni',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Przesuń suwak aby zobaczyć jak zmienia się położenie słońca i cienie rzucane przez panele w ciągu dnia.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  
                  // WebView with Three.js simulation
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: WebViewWidget(controller: _controller),
                    ),
                  ),
                  
                  // Slider controls
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Wschód (6:00)', style: TextStyle(color: Colors.grey.shade600)),
                          Text('Południe (12:00)', style: TextStyle(color: Colors.grey.shade600)),
                          Text('Zachód (18:00)', style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        min: 6,
                        max: 18,
                        divisions: 12,
                        label: '${hour.round()}:00',
                        value: hour,
                        activeColor: Colors.orange.shade600,
                        inactiveColor: Colors.orange.shade200,
                        onChanged: (value) {
                          _updateSunPosition(value);
                        },
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Text(
                            'Godzina: ${hour.round()}:00',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Additional information
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info, color: Colors.blue),
                              const SizedBox(width: 8),
                              const Text(
                                'Informacje o symulacji',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ta symulacja pokazuje jak porusza się słońce w ciągu dnia i jak wpływa to na cienie '
                            'rzucane przez panele fotowoltaiczne. Dzięki temu możesz dobrać optymalną konfigurację układu paneli.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
