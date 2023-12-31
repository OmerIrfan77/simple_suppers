// routes/recipe_ingredients.js

const express = require('express');
const router = express.Router();


/**
 * Recipe_Ingredients routes
 */
// Get the ingredients for a single recipe
router.get("/recipe-ingredients/:recipe_id", (req, res) => {
  const db = require("../server").db;
  const id = req.params.recipe_id;
  db.query(
    "select ri.quantity, i.quantity_type, i.name from ingredients i inner join recipe_ingredients ri on ri.ingredient_id = i.id where ri.recipe_id = ?;",
    [id],
    (error, results) => {
      if (error) {
        console.error("Error executing query:", error);
        res.status(500).json({ error: "Internal Server Error" });
      } else {
        res.json(results);
      }
    }
  );
});

//POST an ingredient to recipe
router.post("/recipe-ingredients", (req, res) => {
  const db = require("../server").db;
  try {
    const { recipeId, ingredientId, quantity } = req.body;

    // Check if the required fields are provided
    if (!recipeId || !ingredientId || !quantity) {
      return res
        .status(400)
        .json({ error: "Recipe ID, Ingredient ID, and Quantity are required" });
    }

    // Add a new row to the recipe_ingredients table
    db.query(
      "INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES (?, ?, ?)",
      [recipeId, ingredientId, quantity],
      (err, result) => {
        if (err) {
          console.error("Error inserting into recipe_ingredients table:", err);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        return res.status(201).json({
          message: "Row added to recipe_ingredients successfully",
          id: result.insertId,
        });
      }
    );
  } catch (err) {
    console.error("Exception:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

//DELETE a recipe-ingredient association by ID
router.delete("/api/recipe-ingredients/:id", (req, res) => {
  const db = require("../server").db;
  const associationId = req.params.id;

  db.query(
    "DELETE FROM recipe_ingredients WHERE id = ?",
    [associationId],
    (err, result) => {
      if (err) {
        console.error("Error deleting from database:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      if (result.affectedRows === 0) {
        return res.status(404).json({ error: "Association not found" });
      }

      return res
        .status(200)
        .json({ message: "Association deleted successfully" });
    }
  );
});

//DELETE all the recipe ingredients by recipe id
router.delete("/recipe-ingredients/:recipe_id", (req, res) => {
  const db = require("../server").db;
  const id = req.params.recipe_id;
  db.query(
    "DELETE FROM recipe_ingredients WHERE recipe_id = ?",
    [id],
    (err, result) => {
      if (err) {
        console.error("Error deleting from database:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      if (result.affectedRows === 0) {
        return res.status(404).json({ error: "Association not found" });
      }

      return res
        .status(200)
        .json({ message: "Association deleted successfully" });
    }
  );
});

module.exports = router;
