import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_assignment/models/recipe.dart';
import 'package:uuid/uuid.dart';

class RecipeMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! CREATE RECIPE
  Future<String> createRecipe({
    required String title,
    required String description,
    required List<String> ingredients,
  }) async {
    String res = 'some error occured';
    try {
      String recipeId = const Uuid().v4();

      Recipe recipe = Recipe(
        id: recipeId,
        title: title,
        description: description,
        ingredients: ingredients,
      );
      _firestore.collection('recipes').doc(recipeId).set(recipe.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //! UPDATE RECIPE
  Future<String> updateRecipe({
    required Recipe recipe,
  }) async {
    String res = 'some error occured';
    try {
      _firestore.collection('recipes').doc(recipe.id).update(recipe.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //! DELETE RECIPE
  Future<void> deleteRecipe({
    required String recipeId,
  }) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).delete();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
