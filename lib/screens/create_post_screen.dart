// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/data_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  File? _selectedImage;
  bool _isLoading = false;
  String _selectedCategory = 'Environment';
  
  final List<String> _categories = [
    'Environment',
    'Education',
    'Community',
    'Health',
    'Technology',
    'Arts & Culture',
    'Business',
    'Other',
  ];

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _createPost() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageId;
      if (_selectedImage != null) {
        imageId = await DataService.saveImage(_selectedImage!);
      }

      final newPost = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'location': _locationController.text.isNotEmpty 
            ? _locationController.text 
            : 'Not specified',
        'category': _selectedCategory,
        'author': 'You',
        'likes': 0,
        'comments': 0,
        'hasImage': _selectedImage != null,
        'imageId': imageId,
      };

      await DataService.savePost(newPost);

      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      setState(() {
        _selectedImage = null;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dream shared successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to home after a delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });

    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

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
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Dream Title',
                hintText: 'What is your dream?',
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
            ),
            
            const SizedBox(height: 16),
            
            // Category
            const Text('Category', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = category);
                  },
                  selectedColor: const Color(0xFF1E3A8A),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Location
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (Optional)',
                hintText: 'Where will this happen?',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your dream in detail...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLength: 500,
            ),
            
            const SizedBox(height: 20),
            
            // Image Picker
            const Text('Add Image (Optional)', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _selectedImage != null ? Colors.green : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: _selectedImage == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text('Tap to add image', style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 5),
                          Text('JPEG, PNG, WebP, GIF', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error, color: Colors.red),
                                  Text('Error loading image'),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
            
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _selectedImage = null),
                      child: const Text('Remove Image', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 30),
            
            // Create Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text(
                        'Share Dream',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}