import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab_assignment/models/recipe.dart';
import 'package:lab_assignment/resources/recipe_methods.dart';
import 'package:lab_assignment/screens/home_screen.dart';

class ViewRecipe extends StatefulWidget {
  final Map<String, dynamic> recipe;
  const ViewRecipe({super.key, required this.recipe});

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  initState() {
    super.initState();
    _titleController.text = widget.recipe['title'];
    _descriptionController.text = widget.recipe['description'];
    _ingredientsController.text = widget.recipe['ingredients'].join(', ');
  }

  editRecipe() async {
    final isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) return;

    setState(() {
      _isLoading = true;
    });
    Recipe editedRecipe = Recipe(
      id: widget.recipe['id'],
      title: _titleController.text,
      description: _descriptionController.text,
      ingredients: _ingredientsController.text.split(', '),
    );

    String res = await RecipeMethods().updateRecipe(
      recipe: editedRecipe,
    );

    if (res == 'success') {
      Fluttertoast.showToast(
        msg: 'Recipe edited successfully',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        _isEditing = false;
      });
    } else {
      Fluttertoast.showToast(
        msg: res,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  deleteRecipe(BuildContext context) async {
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      child: const Text("Cancel", style: TextStyle(color: Colors.black)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text(
        "Delete",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        RecipeMethods().deleteRecipe(recipeId: widget.recipe['id']);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Recipe"),
      content: const Text("Are you sure you want to delete this recipe?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Recipe',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.purple,
            ),
          ),
          !_isEditing
              ? IconButton(
                  onPressed: () async {
                    setState(() {
                      _isEditing = false;
                    });

                    deleteRecipe(context);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Title Form Field
                  TextFormField(
                    enabled: _isEditing,
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Recipt title',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter recipe title';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Description Form Field
                  TextFormField(
                    enabled: _isEditing,
                    controller: _descriptionController,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Please enter description',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter description';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Ingredients Form Field
                  TextFormField(
                    enabled: _isEditing,
                    controller: _ingredientsController,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ingredient 1, Ingredient 2, Ingredient 3',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Ingredients';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Submit Button
                  _isEditing
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: editRecipe,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text(
                                    'Edit Recipe',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
