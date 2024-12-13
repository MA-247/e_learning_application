import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddNewChapterPage extends StatefulWidget {
  final String? chapterId;
  final String? initialTitle;
  final String? initialDescription;
  final String? initialImageUrl;
  final String? initialModelId;
  final String? topicId;

  AddNewChapterPage({
    this.chapterId,
    this.initialTitle,
    this.initialDescription,
    this.initialImageUrl,
    this.initialModelId,
    required this.topicId,
  });

  @override
  _AddNewChapterPageState createState() => _AddNewChapterPageState();
}

class _AddNewChapterPageState extends State<AddNewChapterPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imageUrl;
  String? _modelId;
  bool _isImageSelected = false;  // Flag to track image selection
  bool _isModelSelected = false;  // Flag to track model selection

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

  @override
  void initState() {
    super.initState();
    if (widget.chapterId != null) {
      _titleController.text = widget.initialTitle ?? '';
      _descriptionController.text = widget.initialDescription ?? '';
      _imageUrl = widget.initialImageUrl;
      _modelId = widget.initialModelId;
      _selectedModel = widget.initialModelId != null
          ? models.firstWhere((model) => model['url'] == widget.initialModelId)['name']
          : null;
    }
  }

  Future<void> _uploadImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = result.files.single;
      final filePath = file.path;
      if (filePath != null) {
        try {
          final ref = FirebaseStorage.instance.ref().child('chapter_images/${file.name}');
          await ref.putFile(File(filePath));

          String downloadUrl = await ref.getDownloadURL();

          setState(() {
            _imageUrl = downloadUrl;
            _isImageSelected = true;  // Image has been selected
            _isModelSelected = false; // Disable model selection
          });

          print("Image uploaded successfully, URL: $_imageUrl"); // Debugging log

        } catch (e) {
          print("Error uploading image: $e");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image')));
        }
      }
    }
  }

  // Method to update the modelId when a new model is selected or deselected
  void _onModelSelected(String? selectedModel) {
    setState(() {
      if (selectedModel == null) {
        // Deselecting the model
        _selectedModel = null;
        _modelId = null;
        _isModelSelected = false;
      } else {
        // Selecting a model
        _selectedModel = selectedModel;
        _modelId = models.firstWhere((model) => model['name'] == selectedModel)['url'];
        _isModelSelected = true;  // Model has been selected
        _isImageSelected = false; // Disable image selection
      }
    });
  }

  Future<void> _saveChapter() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      final chapterData = {
        'title': title,
        'description': description,
        'topicId': widget.topicId,
        'imageUrl': _imageUrl,  // This should store the image URL
        '3dModelId': _modelId,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (widget.chapterId == null) {
        await FirebaseFirestore.instance.collection('topics').doc(widget.topicId).collection("chapters").add(chapterData);
      } else {
        await FirebaseFirestore.instance.collection('topics').doc(widget.topicId).collection("chapters").doc(widget.chapterId).update(chapterData);
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Title and description cannot be empty')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterId == null ? 'Add New Chapter' : 'Edit Chapter'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isModelSelected ? null : _uploadImage,  // Disable if model is selected
              child: Text('Upload Image'),
            ),
            SizedBox(height: 10),
            // Dropdown for selecting the 3D model
            DropdownButton<String>(
              value: _selectedModel,
              hint: Text('Select 3D Model'),
              onChanged: _isImageSelected ? null : _onModelSelected,  // Disable if image is selected
              items: [
                // Option to deselect the model
                DropdownMenuItem<String>(
                  value: null,
                  child: Text('No Model Selected'),
                ),
                ...models.map((model) {
                  return DropdownMenuItem<String>(
                    value: model['name']!, // Force unwrap, assuming the name will never be null
                    child: Text(model['name']!),
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChapter,
              child: Text(widget.chapterId == null ? 'Add Chapter' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
