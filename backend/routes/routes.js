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
    const {
      instructions,
      difficulty,
      time,
      budget,
      creator_id,
      title,
      short_description,
      is_public,
      rating,
      image_link,
    } = req.body;

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
        instructions,
        difficulty,
        time,
        budget,
        creator_id,
        title,
        short_description,
        is_public,
        rating,
        image_link,
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
  const {
    instructions,
    difficulty,
    time,
    budget,
    creator_id,
    title,
    short_description,
    is_public,
    rating,
    image_link,
  } = req.body;
  const id = req.params.id;
  const db = require("../server").db;

  const sql = `
  UPDATE recipes
  SET instructions = ?, difficulty = ?, time = ?, budget = ?, title = ?, short_description = ?, is_public = ?, rating = ?, image_link = ?
  WHERE id = ?
`;

  db.query(
    sql,
    [
      instructions,
      difficulty,
      time,
      budget,
      title,
      short_description,
      is_public,
      rating,
      image_link,
      id,
    ],
    (err, results) => {
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
    }
  );
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



/**
 * Ingredients routes
 */
//Add ingredients
router.post('/ingredients', (req, res) => {
  try {
    const db = require("../server").db;
    const { name, unit } = req.body;

    if (!name || !unit) {
      return res.status(400).json({ error: 'Both name and unit are required' });
    }

    // Check if the ingredient with the same name already exists
    db.query('SELECT * FROM ingredients WHERE name = ?', [name], (err, results) => {
      if (err) {
        console.error('Error querying database:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }

      if (results.length > 0) {
        return res.status(400).json({ error: 'Ingredient with the same name already exists', id: results[0].id });
      }

      // Add a new ingredient to the database
      db.query('INSERT INTO ingredients (name, quantity_type) VALUES (?, ?)', [name, unit], (err, result) => {
        if (err) {
          console.error('Error inserting into database:', err);
          return res.status(500).json({ error: 'Internal Server Error' });
        }

        return res.status(201).json({ message: 'Ingredient added successfully', id: result.insertId });
      });
    });
  } catch (err) {
    console.error('Exception:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

//Get all ingredients
router.get('/api/ingredients', (req, res) => {
  const db = require("../server").db;
  db.query('SELECT * FROM ingredients', (err, results) => {
    if (err) {
      console.error('Error querying database:', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    return res.status(200).json(results);
  });
});

//Get one single ingredient
router.get('/api/ingredients/:id', (req, res) => {
  const db = require("../server").db;
  const ingredientId = req.params.id;

  db.query('SELECT * FROM ingredients WHERE id = ?', [ingredientId], (err, results) => {
    if (err) {
      console.error('Error querying database:', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    if (results.length === 0) {
      return res.status(404).json({ error: 'Ingredient not found' });
    }

    return res.status(200).json(results[0]);
  });
});

//PUT to update a single ingredient
router.put('/api/ingredients/:id', (req, res) => {
  const db = require("../server").db;
  const ingredientId = req.params.id;
  const updatedIngredient = req.body;

  db.query('UPDATE ingredients SET ? WHERE id = ?', [updatedIngredient, ingredientId], (err) => {
    if (err) {
      console.error('Error updating database:', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    return res.status(200).json({ message: 'Ingredient updated successfully' });
  });
});

//DETELE a single ingredient
router.delete('/api/ingredients/:id', (req, res) => {
  const db = require("../server").db;
  const ingredientId = req.params.id;

  db.query('DELETE FROM ingredients WHERE id = ?', [ingredientId], (err, result) => {
    if (err) {
      console.error('Error deleting from database:', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Ingredient not found' });
    }

    return res.status(200).json({ message: 'Ingredient deleted successfully' });
  });
});


router.post('/recipe-ingredients', (req, res) => {
  try {
    const { recipeId, ingredientId, quantity } = req.body;

    // Check if the required fields are provided
    if (!recipeId || !ingredientId || !quantity) {
      return res.status(400).json({ error: 'Recipe ID, Ingredient ID, and Quantity are required' });
    }

    // Add a new row to the recipe_ingredients table
    db.query(
      'INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES (?, ?, ?)',
      [recipeId, ingredientId, quantity],
      (err, result) => {
        if (err) {
          console.error('Error inserting into recipe_ingredients table:', err);
          return res.status(500).json({ error: 'Internal Server Error' });
        }

        return res.status(201).json({ message: 'Row added to recipe_ingredients successfully', id: result.insertId });
      }
    );
  } catch (err) {
    console.error('Exception:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

module.exports = router;
