import 'package:flutter/material.dart';

import '../../mixin/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
           // backgroundColor: Colors.transparent,
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/intro.jpg', // replace with NetworkImage if needed
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            child: Container(
              color: Colors.white,
              child: ClipRRect(
              borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Hey, I'm Susan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('26 years old, from Ngong (1.5 mi)', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),

                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('New friends or chats'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], foregroundColor: Colors.black),
                      ),
                      const SizedBox(height: 24),

                      const Text('I speak', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Chip(label: Text('English')),

                      const SizedBox(height: 24),
                      const Text('About me', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: const [
                          Chip(label: Text('Ngong'), avatar: Icon(Icons.home, size: 16)),
                          Chip(label: Text('Other'), avatar: Icon(Icons.account_circle_outlined, size: 16)),
                        ],
                      ),

                      const SizedBox(height: 32),
                      const Text('Advertising', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/intro.jpg'), // Replace with real ad or NetworkImage
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Bottom LinkedIn Ad
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text('LinkedIn: Jobs & Business - Install'),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
