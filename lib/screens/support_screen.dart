import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        const Icon(Icons.support_agent, size: 48, color: Colors.white),
                        const SizedBox(height: 12),
                        const Text(
                          'Centrum wsparcia technicznego',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        const Text('Pomoc i konsultacje', 
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.headset_mic, size: 80, color: Colors.red.shade300),
                    const SizedBox(height: 24),
                    const Text(
                      'Wsparcie Techniczne',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Skontaktuj się z naszym zespołem ekspertów, którzy pomogą Ci rozwiązać problemy techniczne lub odpowiedzą na pytania dotyczące Twojej instalacji.',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Support contact options
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          leading: Icon(Icons.phone, color: Colors.red.shade600),
                          title: const Text('Infolinia techniczna'),
                          subtitle: const Text('+48 123 456 789'),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.email, color: Colors.orange.shade500),
                          title: const Text('Email wsparcia'),
                          subtitle: const Text('support@hitachienergy.com'),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.chat, color: Colors.red.shade600),
                          title: const Text('Czat na żywo'),
                          subtitle: const Text('Dostępny w dni robocze 8:00-18:00'),
                          onTap: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}