// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  TeamScreen({super.key});

  final List<Map<String, dynamic>> _teamMembers = [
    {
      'name': 'Alex Johnson',
      'role': 'Founder & CEO',
      'description':
          'Visionary leader with 10+ years experience in community development. Passionate about creating positive social impact through innovative solutions.',
      'projects': 24,
      'joined': '2018',
      'skills': ['Leadership', 'Strategy', 'Public Speaking'],
    },
    {
      'name': 'Maria Garcia',
      'role': 'Operations Director',
      'description':
          'Expert in project management and community engagement. Leads all field operations and ensures smooth execution of our initiatives.',
      'projects': 18,
      'joined': '2019',
      'skills': ['Operations', 'Management', 'Logistics'],
    },
    {
      'name': 'David Chen',
      'role': 'Tech Lead',
      'description':
          'Develops our digital platforms and tech solutions. Ensures our community stays connected through innovative technology.',
      'projects': 15,
      'joined': '2020',
      'skills': ['Development', 'UI/UX', 'Data Analysis'],
    },
    {
      'name': 'Sarah Williams',
      'role': 'Community Manager',
      'description':
          'Builds strong relationships with members and partners. Organizes events and manages all community communications.',
      'projects': 21,
      'joined': '2019',
      'skills': ['Communication', 'Events', 'Public Relations'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        leading: Padding(
          // Add padding around the avatar
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            // Use AssetImage for local assets
            backgroundImage: AssetImage('assets/logo.png'),
            // or use NetworkImage for images from the internet
            // backgroundImage: NetworkImage('https://example.com/logo.png'),
            radius: 20, // Adjust the size of the circle
          ),
        ),
        // Optional: Add actions/icons to the right side
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team Introduction
            Card(
              color: const Color(0xFF1E3A8A).withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meet Our Dream Team',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We are a passionate group of individuals dedicated to making dreams come true. Each team member brings unique expertise and commitment to our mission.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTeamStat(
                            'Team Members', '${_teamMembers.length}'),
                        _buildTeamStat('Total Projects', '78'),
                        _buildTeamStat('Years Combined', '28+'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Team Members
            const Text(
              'Core Team Members',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'The passionate people behind Dreamers Society',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // Team Members List
            ..._teamMembers
                .map((member) => _buildTeamMemberCard(member))
                .toList(),

            const SizedBox(height: 30),

            // Contact Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Want to Join Our Team?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We\'re always looking for passionate individuals who want to make a difference.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Contact feature coming soon!')),
                        );
                      },
                      icon: const Icon(Icons.email),
                      label: const Text('Contact Us'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMemberCard(Map<String, dynamic> member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                        color: const Color(0xFF1E3A8A).withOpacity(0.2)),
                  ),
                  child: Center(
                    child: Text(
                      member['name'].substring(0, 1),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Chip(
                        label: Text(member['role']),
                        backgroundColor:
                            const Color(0xFF1E3A8A).withOpacity(0.1),
                        labelStyle: const TextStyle(
                          color: Color(0xFF1E3A8A),
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        member['description'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Skills
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: (member['skills'] as List).map((skill) {
                          return Chip(
                            label: Text(skill),
                            backgroundColor: Colors.grey[100],
                            labelStyle: const TextStyle(fontSize: 11),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 12),

                      // Stats
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.rocket_launch,
                                    size: 12, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  '${member['projects']} projects',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 12, color: Colors.blue),
                                const SizedBox(width: 4),
                                Text(
                                  'Since ${member['joined']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
