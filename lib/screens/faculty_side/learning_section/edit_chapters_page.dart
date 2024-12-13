import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EditChapterPage extends StatefulWidget {
  final String chapterId; // ID of the chapter to be edited
  final String topicId;   // The topic this chapter belongs to

  EditChapterPage({required this.chapterId, required this.topicId});

  @override
  _EditChapterPageState createState() => _EditChapterPageState();
}

class _EditChapterPageState extends State<EditChapterPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? _imageUrl; // The URL of the uploaded image
  String? _selected3DModelId; // To store selected 3D model if applicable
  bool _isImageSelected = false; // Flag to track image selection
  bool _isModelSelected = false; // Flag to track model selection

  // Define model names and URLs
  final List<Map<String, String>> models = [
    {'name': 'Caries Prog. 1', 'url': 'https://ma-247.github.io/pulpath_assets/model1.glb'},
    {'name': 'Caries Prog. 2', 'url': 'https://ma-247.github.io/pulpath_assets/model2.glb'},
    {'name': 'Caries Prog. 3', 'url': 'https://ma-247.github.io/pulpath_assets/model3.glb'},
    {'name': 'Caries Prog. 4', 'url': 'https://ma-247.github.io/pulpath_assets/model4.glb'},
    {'name': 'Caries Prog. 5', 'url': 'https://ma-247.github.io/pulpath_assets/model5.glb'},
    {'name': 'Tooth Cross Section', 'url': 'https://ma-247.github.io/pulpath_3d_models_extras/cross.glb'},
    {'name': 'Second Molar', 'url': 'https://ma-247.github.io/pulpath_3d_models_extras/mandibular_second_molar.glb'},
    {'name': 'First Molar', 'url': 'https://ma-247.github.io/pulpath_3d_models_extras/maxillary_first_molar_with_two_root_canals.glb'},
  ];

  String? _selectedModel;

  // Fetch the chapter details from Firestore
  Future<void> _loadChapterDetails() async {
    DocumentSnapshot chapterSnapshot = await FirebaseFirestore.instance
        .collection('topics')
        .doc(widget.topicId)
        .collection("chapters")
        .doc(widget.chapterId)
        .get();

    if (chapterSnapshot.exists) {
      var chapterData = chapterSnapshot.data() as Map<String, dynamic>;
      _titleController.text = chapterData['title'];
      _descriptionController.text = chapterData['description'];
      setState(() {
        _imageUrl = chapterData['imageUrl'];
        _selected3DModelId = chapterData['3DModelId'];
        _selectedModel = _selected3DModelId != null
            ? models.firstWhere((model) => model['url'] == _selected3DModelId)['name']
            : null;
        _isImageSelected = _imageUrl != null;
        _isModelSelected = _selected3DModelId != null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChapterDetails(); // Load the chapter details when the page is initialized
  }

  // Upload a new image and get its URL from Firebase Storage
  Future<void> _uploadImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = result.files.single;
      final filePath = file.path;
      if (filePath != null) {
        final ref = FirebaseStorage.instance.ref().child('chapter_images/${file.name}');
        await ref.putFile(File(filePath));
        String downloadUrl = await ref.getDownloadURL();
        setState(() {
          _imageUrl = downloadUrl;
          _isImageSelected = true;
          _isModelSelected = false; // Disable model selection
        });
      }
    }
  }

  // Update the chapter in Firestore
  Future<void> _updateChapter() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Title and description cannot be empty')));
      return;
    }

    final chapterData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imageUrl': _imageUrl,
      '3DModelId': _selected3DModelId,
      'lastEditedTimestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance.collection('topics').doc(widget.topicId).collection("chapters").doc(widget.chapterId).update(chapterData);

    Navigator.pop(context); // Go back after saving
  }

  // Method to handle 3D model selection
  void _onModelSelected(String? selectedModel) {
    setState(() {
      if (selectedModel == null) {
        _selectedModel = null;
        _selected3DModelId = null;
        _isModelSelected = false;
      } else {
        _selectedModel = selectedModel;
        _selected3DModelId = models.firstWhere((model) => model['name'] == selectedModel)['url'];
        _isModelSelected = true;
        _isImageSelected = false; // Disable image selection
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Chapter'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Chapter Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
              ),
              SizedBox(height: 10),
              // Show current image or button to upload new image
              _imageUrl == null
                  ? ElevatedButton(
                onPressed: _isModelSelected ? null : _uploadImage, // Disable if model is selected
                child: Text('Upload Image'),
              )
                  : Column(
                children: [
                  Image.network(_imageUrl!),
                  ElevatedButton(
                    onPressed: _isModelSelected ? null : _uploadImage, // Disable if model is selected
                    child: Text('Change Image'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Dropdown for selecting the 3D model
              DropdownButton<String>(
                value: _selectedModel,
                hint: Text('Select 3D Model'),
                onChanged: _isImageSelected ? null : _onModelSelected, // Disable if image is selected
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('No Model Selected'),
                  ),
                  ...models.map((model) {
                    return DropdownMenuItem<String>(
                      value: model['name']!,
                      child: Text(model['name']!),
                    );
                  }).toList(),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateChapter,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
