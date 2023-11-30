const express = require("express");
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const secretKey = process.env.JWT_SECRET_KEY

// Define routes

// Get all recipes
router.get('/recipes', (req, res) => {
    const db = require('../server').db;
    db.query('SELECT * FROM recipes', (error, results) => {
        if (error) {
            console.error('Error executing query:', error);
            res.status(500).json({ error: 'Internal Server Error' });
        } else {
            res.json(results);
        }
    });
});

// Get a single recipe
router.get('/recipe/:id', (req, res) => {
    const db = require('../server').db;
    const id = req.params.id;
    db.query('SELECT * FROM recipes WHERE id = ?', [id], (error, results) => {
        if (error) {
            console.error('Error executing query:', error);
            res.status(500).json({ error: 'Internal Server Error' });
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

// Search recipes by difficulty
router.get('/recipes/search', (req, res) => {
    const db = require('../server').db;
    const { time, difficulty } = req.query;
  
    // Check if at least one parameter is provided
    if (!time && !difficulty) {
      return res.status(400).json({ error: 'At least one parameter (time or difficulty) is required' });
    }
  
    // Build the WHERE clause based on provided parameters
    let whereClause = '';
    let params = [];
  
    if (time) {
      whereClause += 'time <= ?';
      params.push(Number(time));
    }
  
    if (difficulty) {
      if (whereClause) {
        whereClause += ' AND ';
      }
      whereClause += 'difficulty <= ?';
      params.push(Number(difficulty));
    }
  
    const query = `SELECT * FROM recipes${whereClause ? ' WHERE ' + whereClause : ''}`;
  
    db.query(query, params, (error, results) => {
      if (error) {
        console.error('Error executing search query:', error);
        return res.status(500).json({ error: 'Internal Server Error' });
      }
  
      res.json(results);
    });
  });
  

// USER RELATED ROUTES

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
          const token = jwt.sign({ username }, secretKey, {
            expiresIn: "1h",
          });
          res.json({ token });
        } else {
          res.status(401).json({ error: "Invalid credentials" });
        }
      } else {
        res.status(404).json({ error: "User not found" });
      }
    }
  );
});

// User logout
router.post("/logout", (req, res) => {
  // Handle user logout
});

module.exports = router;
