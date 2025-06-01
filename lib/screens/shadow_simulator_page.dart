import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/efficiency_forecast_widget.dart';

class ShadowSimulatorPage extends StatefulWidget {
  const ShadowSimulatorPage({super.key});

  @override
  State<ShadowSimulatorPage> createState() => _ShadowSimulatorPageState();
}

class _ShadowSimulatorPageState extends State<ShadowSimulatorPage> with TickerProviderStateMixin {
  double hour = 12;
  double panelTilt = 35;
  double panelAzimuth = 180;
  double installationPower = 10.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateSunPosition(double newHour) {
    setState(() {
      hour = newHour;
    });
    _animationController.forward(from: 0);
  }

  void _updatePanelTilt(double newTilt) {
    setState(() {
      panelTilt = newTilt;
    });
    _animationController.forward(from: 0);
  }

  void _updatePanelAzimuth(double newAzimuth) {
    setState(() {
      panelAzimuth = newAzimuth;
    });
    _animationController.forward(from: 0);
  }

  void _updateInstallationPower(double newPower) {
    setState(() {
      installationPower = newPower;
    });
    _animationController.forward(from: 0);
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
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spacer(),
                        Icon(Icons.school, size: 48, color: Colors.white),
                        SizedBox(height: 12),
                        Text(
                          'Akademia Fotowoltaiki',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                        Text('Edukacja i symulacje', 
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                        SizedBox(height: 4),
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
                  // Symulator cieni
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Symulator pozycji słońca i cieni',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          
                          // Wizualizacja z progress barem
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                // Progress bar z wydajnością z lewej strony
                                Container(
                                  width: 80,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    border: Border(
                                      right: BorderSide(color: Colors.grey.shade300),
                                    ),
                                  ),
                                  child: _buildEfficiencyProgressBar(),
                                ),
                                // Wizualizacja panelu
                                Expanded(
                                  child: CustomPaint(
                                    painter: SolarPanelShadowPainter(
                                      hour: hour,
                                      panelTilt: panelTilt,
                                      panelAzimuth: panelAzimuth,
                                      installationPower: installationPower,
                                    ),
                                    size: const Size(double.infinity, 300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          const Text(
                            'Parametry symulacji',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildSlider(
                            'Godzina dnia',
                            hour,
                            6.0,
                            18.0,
                            (value) => _updateSunPosition(value),
                            '${hour.round()}:00',
                          ),
                          
                          _buildSlider(
                            'Nachylenie paneli',
                            panelTilt,
                            0.0,
                            60.0,
                            (value) => _updatePanelTilt(value),
                            '${panelTilt.round()}°',
                          ),
                          
                          _buildSlider(
                            'Azymut paneli',
                            panelAzimuth,
                            0.0,
                            360.0,
                            (value) => _updatePanelAzimuth(value),
                            '${panelAzimuth.round()}° (${_getAzimuthDirection(panelAzimuth)})',
                          ),
                          
                          _buildSlider(
                            'Moc instalacji',
                            installationPower,
                            1.0,
                            20.0,
                            (value) => _updateInstallationPower(value),
                            '${installationPower.toStringAsFixed(1)} kW',
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  EfficiencyForecastWidget(
                    hour: hour,
                    panelTilt: panelTilt,
                    panelAzimuth: panelAzimuth,
                    installationPower: installationPower,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Sekcja edukacyjna - Optymalizacja orientacji
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Optymalizacja orientacji paneli',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(1.5),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(1),
                            },
                            children: [
                              _buildTableHeader(),
                              _buildTableRow('180°', 'Południe', 'Optymalny', '100%', Colors.green),
                              _buildTableRow('135°', 'Pd-Wsch', 'Bardzo dobry', '95%', Colors.lightGreen),
                              _buildTableRow('225°', 'Pd-Zach', 'Bardzo dobry', '95%', Colors.lightGreen),
                              _buildTableRow('90°', 'Wschód', 'Dobry', '85%', Colors.orange),
                              _buildTableRow('270°', 'Zachód', 'Dobry', '85%', Colors.orange),
                              _buildTableRow('0°', 'Północ', 'Niezalecany', '60%', Colors.red),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue.shade600),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Optymalne nachylenie dla Polski: 30-40°. Odchylenie ±15° od kierunku południowego nie wpływa znacząco na wydajność.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sekcja edukacyjna - Praktyczne wskazówki
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Praktyczne wskazówki optymalizacji',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildTipCard(
                            'Analiza zacienienia',
                            'Sprawdź zacienienie paneli o różnych porach dnia (6:00-18:00). Unikaj miejsc zacienionych przez budynki, drzewa czy kominy.',
                            Colors.orange,
                            'Optimum: brak cieni 9:00-15:00'
                          ),
                          const SizedBox(height: 12),
                          
                          _buildTipCard(
                            'Szerokość geograficzna',
                            'Dla Krakowa (50.06°N) optymalne nachylenie to 35°. Im dalej na północ, tym większe nachylenie zalecane.',
                            Colors.blue,
                            'Kraków: 35°, Gdańsk: 38°'
                          ),
                          const SizedBox(height: 12),
                          
                          _buildTipCard(
                            'Tolerancja orientacji',
                            'Odchylenie ±30° od kierunku południowego powoduje stratę wydajności poniżej 10%. To wciąż opłacalna inwestycja.',
                            Colors.green,
                            'Strata 150°-210°: <10%'
                          ),
                          const SizedBox(height: 12),
                          
                          _buildTipCard(
                            'Temperatura paneli',
                            'Zbyt wysokie temperatury (>85°C) obniżają wydajność. Zapewnij odpowiedni przepływ powietrza pod panelami.',
                            Colors.red,
                            'Optymalna temp: 25-45°C'
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sekcja edukacyjna - Mity i fakty
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mity i fakty o fotowoltaice',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildFactCard(
                            '✅ FAKT: Panele działają również w pochmurne dni',
                            'Panele fotowoltaiczne produkują energię nawet przy rozproszonej śiecie słonecznej. W pochmurny dzień wydajność wynosi 10-25% maksymalnej mocy.',
                            true
                          ),
                          
                          _buildFactCard(
                            '❌ MIT: Panele PV wymagają bezpośredniego słońca',
                            'To nieprawda! Panele wykorzystują również światło rozproszone. Niemiecka fotowoltaika działa sprawnie mimo częstego zachmurzenia.',
                            false
                          ),
                          
                          _buildFactCard(
                            '✅ FAKT: Chłodniejsze temperatury zwiększają wydajność',
                            'Panele krzem krystaliczny osiągają najwyższą sprawność przy temperaturach 15-25°C. Każdy stopień powyżej 25°C obniża wydajność o 0,4%.',
                            true
                          ),
                          
                          _buildFactCard(
                            '❌ MIT: Czyszczenie paneli jest konieczne co miesiąc',
                            'Nowoczesne panele są samoczyszczące. Deszcz usuwa większość zanieczyszczeń. Czyszczenie 1-2 razy rocznie wystarcza.',
                            false
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sekcja edukacyjna - Kalendarz konserwacji
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kalendarz konserwacji systemu PV',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            children: [
                              _buildSeasonCard(
                                '🌸 WIOSNA',
                                [
                                  'Kontrola wizualna paneli',
                                  'Sprawdzenie mocowań',
                                  'Czyszczenie paneli',
                                  'Test systemu monitoringu'
                                ],
                                Colors.green,
                              ),
                              _buildSeasonCard(
                                '☀️ LATO',
                                [
                                  'Monitoring wydajności',
                                  'Kontrola wentylacji',
                                  'Sprawdzenie połączeń',
                                  'Analiza produkcji energii'
                                ],
                                Colors.orange,
                              ),
                              _buildSeasonCard(
                                '🍂 JESIEŃ',
                                [
                                  'Usunięcie liści z paneli',
                                  'Przegląd przed zimą',
                                  'Test systemu grzewczego',
                                  'Kontrola szczelności'
                                ],
                                Colors.brown,
                              ),
                              _buildSeasonCard(
                                '❄️ ZIMA',
                                [
                                  'Usuwanie śniegu z paneli',
                                  'Kontrola obciążenia',
                                  'Monitoring spadków',
                                  'Planowanie serwisu'
                                ],
                                Colors.blue,
                              ),
                            ],
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

  Widget _buildSlider(String label, double value, double min, double max, 
      Function(double) onChanged, String displayValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(displayValue, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: onChanged,
            activeColor: Colors.orange.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String description, Color color, String additionalInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              additionalInfo,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactCard(String title, String description, bool isFact) {
    final color = isFact ? Colors.green : Colors.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonCard(String season, List<String> tasks, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            season,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          ...tasks.map((task) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 6, right: 8),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    task,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      children: [
        _buildTableCell('Azymut', true),
        _buildTableCell('Kierunek', true),
        _buildTableCell('Charakterystyka', true),
        _buildTableCell('Wydajność', true),
      ],
    );
  }

  TableRow _buildTableRow(String azimuth, String direction, String description, String efficiency, Color color) {
    return TableRow(
      children: [
        _buildTableCell(azimuth, false, color: color),
        _buildTableCell(direction, false),
        _buildTableCell(description, false),
        _buildTableCell(efficiency, false, color: color),
      ],
    );
  }

  Widget _buildTableCell(String text, bool isHeader, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 13 : 12,
          color: color ?? (isHeader ? Colors.grey.shade800 : Colors.black87),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _getAzimuthDirection(double azimuth) {
    if (azimuth >= 0 && azimuth <= 22.5 || azimuth >= 337.5 && azimuth <= 360) return 'Północ';
    if (azimuth > 22.5 && azimuth < 67.5) return 'Północny wschód';
    if (azimuth >= 67.5 && azimuth <= 112.5) return 'Wschód';
    if (azimuth > 112.5 && azimuth < 157.5) return 'Południowy wschód';
    if (azimuth >= 157.5 && azimuth <= 202.5) return 'Południe';
    if (azimuth > 202.5 && azimuth < 247.5) return 'Południowy zachód';
    if (azimuth >= 247.5 && azimuth <= 292.5) return 'Zachód';
    if (azimuth > 292.5 && azimuth < 337.5) return 'Północny zachód';
    return 'Kierunek';
  }

  Widget _buildEfficiencyProgressBar() {
    final efficiency = _calculateEfficiency(hour, panelTilt, panelAzimuth);
    final currentProduction = installationPower * efficiency / 100;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tytuł
        Text(
          'Wydajność',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        
        // Pionowy progress bar
        Expanded(
          child: Container(
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Tło progress bara
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                // Wypełnienie progress bara
                FractionallySizedBox(
                  heightFactor: efficiency / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          _getEfficiencyColor(efficiency),
                          _getEfficiencyColor(efficiency).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                // Wskaźnik poziomu
                Positioned(
                  bottom: (efficiency / 100) * 200 - 10,
                  child: Container(
                    width: 34,
                    height: 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Wartość procentowa
        Text(
          '${efficiency.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _getEfficiencyColor(efficiency),
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 4),
        
        // Aktualna produkcja
        Text(
          '${currentProduction.toStringAsFixed(1)}kW',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Ikona słońca/chmury w zależności od wydajności
        Icon(
          efficiency > 70 ? Icons.wb_sunny : 
          efficiency > 30 ? Icons.wb_cloudy : Icons.cloud,
          color: _getEfficiencyColor(efficiency),
          size: 20,
        ),
      ],
    );
  }

  Color _getEfficiencyColor(double efficiency) {
    if (efficiency >= 80) return Colors.green;
    if (efficiency >= 60) return Colors.lightGreen;
    if (efficiency >= 40) return Colors.orange;
    if (efficiency >= 20) return Colors.deepOrange;
    return Colors.red;
  }

  double _calculateEfficiency(double hour, double panelTilt, double panelAzimuth) {
    // Obliczenia kąta słońca
    final sunAngle = (hour - 12) / 6 * 90; // stopnie od południa
    final sunAzimuth = 180 + sunAngle; // azymut słońca w stopniach
    final sunElevation = 90 - (sunAngle.abs() * 0.75); // wysokość słońca
    
    if (sunElevation <= 0) return 0.0;
    
    // Obliczenie różnicy azymutów
    double azimuthDifference = (sunAzimuth - panelAzimuth).abs();
    if (azimuthDifference > 180) azimuthDifference = 360 - azimuthDifference;
    
    // Konwersja na radiany
    final sunElevationRad = sunElevation * math.pi / 180;
    final panelTiltRad = panelTilt * math.pi / 180;
    final azimuthDifferenceRad = azimuthDifference * math.pi / 180;
    
    // Obliczenie kąta padania przy użyciu iloczynu skalarnego
    final cosIncidenceAngle = math.sin(sunElevationRad) * math.cos(panelTiltRad) +
        math.cos(sunElevationRad) * math.sin(panelTiltRad) * math.cos(azimuthDifferenceRad);
    
    final clampedCosIncidenceAngle = math.max(-1.0, math.min(1.0, cosIncidenceAngle));
    final incidenceAngle = math.acos(clampedCosIncidenceAngle);
    
    // Obliczenie składników wydajności
    final cosineEffect = math.cos(incidenceAngle);
    final solarIrradiance = math.sin(sunElevationRad);
    
    // Końcowe obliczenie wydajności
    final efficiency = cosineEffect * solarIrradiance * 100 * 0.85; // 85% sprawność systemu
    
    return math.max(0, math.min(100, efficiency));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is SolarPanelShadowPainter && 
           (oldDelegate.hour != hour || 
            oldDelegate.panelTilt != panelTilt ||
            oldDelegate.panelAzimuth != panelAzimuth ||
            oldDelegate.installationPower != installationPower);
  }
}

class SolarPanelShadowPainter extends CustomPainter {
  final double hour;
  final double panelTilt;
  final double panelAzimuth;
  final double installationPower;

  SolarPanelShadowPainter({
    required this.hour, 
    required this.panelTilt,
    required this.panelAzimuth,
    required this.installationPower,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Draw sky gradient
    final skyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.lightBlue.shade200,
        Colors.lightBlue.shade50,
      ],
    );
    final skyRect = Rect.fromLTWH(0, 0, size.width, size.height * 0.8);
    paint.shader = skyGradient.createShader(skyRect);
    canvas.drawRect(skyRect, paint);
    paint.shader = null;

    // Draw ground
    paint.color = Colors.green.shade200;
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.8, size.width, size.height * 0.2), paint);

    // Sun position calculations
    final sunAngle = (hour - 12) / 6 * math.pi / 2;
    final sunX = size.width / 2 + math.sin(sunAngle) * size.width * 0.35;
    final sunY = size.height * 0.2 + (1 - math.cos(sunAngle).abs()) * size.height * 0.3;

    // Draw sun with corona effect
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade300, Colors.orange.shade400],
      ).createShader(Rect.fromCircle(center: Offset(sunX, sunY), radius: 25));
    canvas.drawCircle(Offset(sunX, sunY), 25, sunPaint);
    
    // Sun corona
    paint.color = Colors.yellow.withOpacity(0.3);
    canvas.drawCircle(Offset(sunX, sunY), 35, paint);

    // Panel position
    final panelX = size.width / 2;
    final panelY = size.height * 0.65;
    final panelWidth = 140.0;
    final panelHeight = 12.0;
    final panelAngleRad = -panelTilt * math.pi / 180;

    // Azimuth visual offset
    final azimuthOffset = (panelAzimuth - 180) / 180 * size.width * 0.1;
    final adjustedPanelX = panelX + azimuthOffset;

    // Draw solar panel with correct angle
    canvas.save();
    canvas.translate(adjustedPanelX, panelY);
    canvas.rotate(panelAngleRad);
    
    final panelGradient = LinearGradient(
      colors: [Colors.blue.shade900, Colors.blue.shade700],
    );
    paint.shader = panelGradient.createShader(
      Rect.fromCenter(center: Offset.zero, width: panelWidth, height: panelHeight),
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: panelWidth, height: panelHeight),
      paint,
    );
    paint.shader = null;

    // Panel grid lines
    paint.color = Colors.blue.shade800;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    for (int i = 1; i < 6; i++) {
      final x = -panelWidth/2 + (panelWidth / 6) * i;
      canvas.drawLine(
        Offset(x, -panelHeight/2),
        Offset(x, panelHeight/2),
        paint,
      );
    }
    
    canvas.restore();

    // Calculate and display efficiency
    final efficiency = _calculateEfficiency(hour, panelTilt, panelAzimuth);
    final currentProduction = installationPower * efficiency / 100;

    // Draw info text with efficiency
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${hour.round()}:00\n',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Moc: ${installationPower.toStringAsFixed(1)} kW\n',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Nachylenie: ${panelTilt.round()}°\n',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Azymut: ${panelAzimuth.round()}°\n',
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Wydajność: ${efficiency.toStringAsFixed(1)}%\n',
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Produkcja: ${currentProduction.toStringAsFixed(2)} kW',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 200, 20));
  }

  double _calculateEfficiency(double hour, double panelTilt, double panelAzimuth) {
    // Sun angle calculations
    final sunAngle = (hour - 12) / 6 * 90; // degrees from south
    final sunAzimuth = 180 + sunAngle; // sun azimuth in degrees
    final sunElevation = 90 - (sunAngle.abs() * 0.75); // sun elevation
    
    if (sunElevation <= 0) return 0.0;
    
    // Calculate azimuth difference
    double azimuthDifference = (sunAzimuth - panelAzimuth).abs();
    if (azimuthDifference > 180) azimuthDifference = 360 - azimuthDifference;
    
    // Convert to radians
    final sunElevationRad = sunElevation * math.pi / 180;
    final panelTiltRad = panelTilt * math.pi / 180;
    final azimuthDifferenceRad = azimuthDifference * math.pi / 180;
    
    // Calculate incidence angle using dot product
    final cosIncidenceAngle = math.sin(sunElevationRad) * math.cos(panelTiltRad) +
        math.cos(sunElevationRad) * math.sin(panelTiltRad) * math.cos(azimuthDifferenceRad);
    
    final clampedCosIncidenceAngle = math.max(-1.0, math.min(1.0, cosIncidenceAngle));
    final incidenceAngle = math.acos(clampedCosIncidenceAngle);
    
    // Calculate efficiency components
    final cosineEffect = math.cos(incidenceAngle);
    final solarIrradiance = math.sin(sunElevationRad);
    
    // Final efficiency calculation
    final efficiency = cosineEffect * solarIrradiance * 100 * 0.85; // 85% system efficiency
    
    return math.max(0, math.min(100, efficiency));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is SolarPanelShadowPainter && 
           (oldDelegate.hour != hour || 
            oldDelegate.panelTilt != panelTilt ||
            oldDelegate.panelAzimuth != panelAzimuth ||
            oldDelegate.installationPower != installationPower);
  }
}
