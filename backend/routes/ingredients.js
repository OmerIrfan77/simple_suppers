// routes/ingredients.js

const express = require("express");
const router = express.Router();

/**
 * Ingredients routes
 */
//Add ingredients
router.post("/ingredients", (req, res) => {
  try {
    const db = require("../server").db;
    const { name, unit } = req.body;

    if (!name || !unit) {
      return res.status(400).json({ error: "Both name and unit are required" });
    }

    // Check if the ingredient with the same name already exists
    db.query(
      "SELECT * FROM ingredients WHERE name COLLATE utf8_general_ci = ?",
      [name],
      (err, results) => {
        if (err) {
          console.error("Error querying database:", err);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        if (results.length > 0) {
          return res.status(400).json({
            error: "Ingredient with the same name already exists",
            id: results[0].id,
          });
        }

        // Add a new ingredient to the database
        db.query(
          "INSERT INTO ingredients (name, quantity_type) VALUES (?, ?)",
          [name, unit],
          (err, result) => {
            if (err) {
              console.error("Error inserting into database:", err);
              return res.status(500).json({ error: "Internal Server Error" });
            }

            return res.status(201).json({
              message: "Ingredient added successfully",
              id: result.insertId,
            });
          }
        );
      }
    );
  } catch (err) {
    console.error("Exception:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

//Get all ingredients
router.get("/ingredients", (req, res) => {
  const db = require("../server").db;
  db.query("SELECT * FROM ingredients", (err, results) => {
    if (err) {
      console.error("Error querying database:", err);
      return res.status(500).json({ error: "Internal Server Error" });
    }

    return res.status(200).json(results);
  });
});

//Get one single ingredient
router.get("/ingredients/:id", (req, res) => {
  const db = require("../server").db;
  const ingredientId = req.params.id;

  db.query(
    "SELECT * FROM ingredients WHERE id = ?",
    [ingredientId],
    (err, results) => {
      if (err) {
        console.error("Error querying database:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      if (results.length === 0) {
        return res.status(404).json({ error: "Ingredient not found" });
      }

      return res.status(200).json(results[0]);
    }
  );
});

//PUT to update a single ingredient
router.put("/ingredients/:id", (req, res) => {
  const db = require("../server").db;
  const ingredientId = req.params.id;
  const updatedIngredient = req.body;

  db.query(
    "UPDATE ingredients SET ? WHERE id = ?",
    [updatedIngredient, ingredientId],
    (err) => {
      if (err) {
        console.error("Error updating database:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      return res
        .status(200)
        .json({ message: "Ingredient updated successfully" });
    }
  );
});

//DETELE a single ingredient
router.delete("/ingredients/:id", (req, res) => {
  const db = require("../server").db;
  const ingredientId = req.params.id;

  db.query(
    "DELETE FROM ingredients WHERE id = ?",
    [ingredientId],
    (err, result) => {
      if (err) {
        console.error("Error deleting from database:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      if (result.affectedRows === 0) {
        return res.status(404).json({ error: "Ingredient not found" });
      }

      return res
        .status(200)
        .json({ message: "Ingredient deleted successfully" });
    }
  );
});

module.exports = router;
