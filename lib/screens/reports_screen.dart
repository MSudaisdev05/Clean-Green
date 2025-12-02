// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../services/data_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  String _selectedCategory = 'Cleanliness Issue';
  bool _isSubmitting = false;
  List<Map<String, dynamic>> _reports = [];

  final List<String> _categories = [
    'Cleanliness Issue',
    'Infrastructure',
    'Safety Concern',
    'Suggestion',
    'Complaint',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final reports = await DataService.getReports();
    setState(() => _reports = reports);
  }

  Future<void> _submitReport() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe the issue')),
      );
      return;
    }

    if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a location')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final newReport = {
        'description': _descriptionController.text,
        'location': _locationController.text,
        'category': _selectedCategory,
        'status': 'Pending',
      };

      await DataService.saveReport(newReport);

      // Clear form
      _descriptionController.clear();
      _locationController.clear();

      // Refresh list
      await _loadReports();

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  String _formatTime(String isoTime) {
    final time = DateTime.parse(isoTime);
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${(difference.inDays / 7).floor()}w ago';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'in progress': return Colors.blue;
      case 'completed': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('reports_screen'),
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
            // Report Form
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Report an Issue',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Help us improve by reporting issues or suggesting improvements.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Category
                    const Text('Category', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedCategory = value!),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Location
                    const Text('Location', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Where is the issue located?',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    const Text('Description', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Describe the issue in detail...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        alignLabelWithHint: true,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                            : const Text('Submit Report', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Submitted Reports
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Reports',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadReports,
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            Text(
              '${_reports.length} report${_reports.length == 1 ? '' : 's'} submitted',
              style: TextStyle(color: Colors.grey[600]),
            ),
            
            const SizedBox(height: 16),
            
            // Reports List
            ..._reports.map((report) => _buildReportItem(report)).toList(),
            
            if (_reports.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                child: const Column(
                  children: [
                    Icon(Icons.report, size: 60, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      'No reports yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Submit your first report above',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(Map<String, dynamic> report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(report['category']),
                  backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
                  labelStyle: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(report['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    report['status'],
                    style: TextStyle(
                      color: _getStatusColor(report['status']),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              report['description'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Location and Time
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    report['location'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Text(
                  _formatTime(report['createdAt']),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}