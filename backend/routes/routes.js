const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");

const secretKey = process.env.JWT_SECRET_KEY;

/**
 * Recipes routes
 */
// Get all recipes
router.get("/recipes", (req, res) => {
  const db = require("../server").db;
  db.query("SELECT * FROM recipes", (error, results) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).json({ error: "Internal Server Error" });
    } else {
      res.json(results);
    }
  });
});

// Get all public recipes
router.get("/recipes/public", (req, res) => {
  const db = require("../server").db;

  const query = "SELECT * FROM recipes WHERE is_public = 1";

  db.query(query, (error, results) => {
    if (error) {
      console.error("Error executing query: ", error);
      res.status(500).json({ error: "Internal Server Error" });
    } else {
      res.json(results);
    }
  });
});

// Search recipes by difficulty
router.get("/recipes/search", (req, res) => {
  const db = require("../server").db;
  const { time, difficulty } = req.query;

  // Check if at least one parameter is provided
  if (!time && !difficulty) {
    return res.status(400).json({
      error: "At least one parameter (time or difficulty) is required",
    });
  }

  // Build the WHERE clause based on provided parameters
  let whereClause = "";
  let params = [];

  if (time) {
    whereClause += "time <= ?";
    params.push(Number(time));
  }

  if (difficulty) {
    if (whereClause) {
      whereClause += " AND ";
    }
    whereClause += "difficulty = ?";
    params.push(Number(difficulty));
  }

  const query = `SELECT * FROM recipes${
    whereClause ? " WHERE " + whereClause : ""
  }`;

  db.query(query, params, (error, results) => {
    if (error) {
      console.error("Error executing search query:", error);
      return res.status(500).json({ error: "Internal Server Error" });
    }

    res.json(results);
  });
});

// Get all public recipes and recipes owned by logged in user
router.get("/recipes/:userId", (req, res) => {
  const db = require("../server").db;

  // Get the user id
  const userId = req.params.userId;

  const query = "SELECT * FROM recipes WHERE is_public = 1 OR creator_id = ?";

  db.query(query, [userId], (error, results) => {
    if (error) {
      console.error("Error executing query: ", error);
      res.status(500).json({ error: "Internal Server Error" });
    } else {
      res.json(results);
    }
  });
});

// Get all recipes owned by logged in user
router.get("/recipes/user/:userId", (req, res) => {
  const db = require("../server").db;

  // Get the user id
  const userId = req.params.userId;

  const query = "SELECT * FROM recipes WHERE creator_id = ?";

  db.query(query, [userId], (error, results) => {
    if (error) {
      console.error("Error executing query: ", error);
      res.status(500).json({ error: "Internal Server Error" });
    } else {
      res.json(results);
    }
  });
});

// Get a single recipe
router.get("/recipe/:id", (req, res) => {
  const db = require("../server").db;
  const id = req.params.id;
  db.query("SELECT * FROM recipes WHERE id = ?", [id], (error, results) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).json({ error: "Internal Server Error" });
    } else {
      res.json(results);
    }
  });
});

// Post a recipe
router.post("/recipes", (req, res) => {
  const db = require("../server").db;
  try {
    db.getConnection((err, connection) => {
      if (err) {
        console.error("Error getting MySQL connection: ", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      const sql = `
                INSERT INTO recipes
                (instructions, difficulty, time, budget, creator_id, title, short_description, is_public, rating, image_link)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `;

      const values = [
        req.body.instructions,
        req.body.difficulty,
        req.body.time,
        req.body.budget,
        req.body.creator_id,
        req.body.title,
        req.body.short_description,
        req.body.is_public,
        req.body.rating,
        req.body.image_link,
      ];

      connection.query(sql, values, (queryErr, results) => {
        connection.release(); // Release the connection

        if (queryErr) {
          console.error("Error executing MySQL query: ", queryErr);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        // Respond with the ID of the inserted recipe
        res.json({ recipeId: results.insertId });
      });
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// PUT to update a single recipe
router.put("/recipe/:id", (req, res) => {
  const id = req.params.id;
  const db = require("../server").db;

  const sql = `
  UPDATE recipes
  SET instructions = ?, difficulty = ?, time = ?, budget = ?, title = ?, short_description = ?, is_public = ?, rating = ?, image_link = ?
  WHERE id = ?
`;

  const values = [
    req.body.instructions,
    req.body.difficulty,
    req.body.time,
    req.body.budget,
    req.body.title,
    req.body.short_description,
    req.body.is_public,
    req.body.rating,
    req.body.image_link,
    id,
  ];

  db.query(sql, values, (err, results) => {
    if (err) {
      console.error("Error updating query:", err);
      res
        .status(500)
        .json({ success: false, message: "Internal Server Error" });
      return;
    }
    console.log("Rows affected:", results.affectedRows);
    res.json({
      recipeId: Number(id),
      message: "Recipe updated successfully",
    });
  });
});

// DELETE to delete a recipe
router.delete("/recipe/:id", (req, res) => {
  const id = req.params.id;
  const db = require("../server").db;

  const sql = "DELETE FROM recipes WHERE id = ?";

  db.query(sql, [id], (err, results) => {
    if (err) {
      console.error("Error deleting recipe:", err);
      res.status(500).json({ error: "Internal Server Error" });
      return;
    }
    console.log("Rows affected:", results.affectedRows);
    res.json({ message: "Recipe deleted successfully" });
  });
});

/**
 * User related routes
 */
// User registration
router.post("/register", async (req, res) => {
  const db = require("../server").db;
  const { username, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  db.query(
    "INSERT INTO users (username, password) VALUES (?, ?)",
    [username, hashedPassword],
    (err, result) => {
      if (err) {
        console.error("Error registering user:", err);
        res.status(500).json({ error: "Internal server error" });
      } else {
        res.json({ message: "User registered successfully" });
      }
    }
  );
});

//User login
router.post("/login", async (req, res) => {
  const db = require("../server").db;
  const { username, password } = req.body;

  db.query(
    "SELECT * FROM users WHERE username = ?",
    [username],
    async (err, results) => {
      if (err) {
        console.error("Error during login:", err);
        res.status(500).json({ error: "Internal server error" });
      } else if (results.length > 0) {
        const match = await bcrypt.compare(password, results[0].password);

        if (match) {
          res.json({ username: results[0].username, id: results[0].id });
        } else {
          res.status(401).json({ error: "Invalid credentials" });
        }
      } else {
        res.status(404).json({ error: "User not found" });
      }
    }
  );
});

module.exports = router;
