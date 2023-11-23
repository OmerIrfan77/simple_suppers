// routes/recipes.js

const express = require('express');
const router = express.Router();
// Define routes

// Example: Get all recipes
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

// Example: Get a single recipe
router.get('/recipes/:id', (req, res) => {
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

router.get('/recipes/search', (req, res) => {
    const db = require('../server').db;
    const { maxTime, maxDifficulty } = req.query;
  
    // Check if at least one parameter is provided
    if (!maxTime && !maxDifficulty) {
      return res.status(400).json({ error: 'At least one parameter (maxTime or maxDifficulty) is required' });
    }
  
    // Build the WHERE clause based on provided parameters
    let whereClause = '';
    let params = [];
  
    if (maxTime) {
      whereClause += 'time < ?';
      params.push(Number(maxTime));
    }
  
    if (maxDifficulty) {
      if (whereClause) {
        whereClause += ' AND ';
      }
      whereClause += 'difficulty < ?';
      params.push(Number(maxDifficulty));
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


// Post a recipe
router.post('/recipes', (req, res) => {
    const db = require('../server').db;
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
            image_link
        } = req.body;

        db.getConnection((err, connection) => {
            if (err) {
                console.error('Error getting MySQL connection: ', err);
                return res.status(500).json({ error: 'Internal Server Error' });
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
                image_link
            ];

            connection.query(sql, values, (queryErr, results) => {
                connection.release(); // Release the connection

                if (queryErr) {
                    console.error('Error executing MySQL query: ', queryErr);
                    return res.status(500).json({ error: 'Internal Server Error' });
                }

                // Respond with the ID of the inserted recipe
                res.json({ recipeId: results.insertId });
            });
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

module.exports = router;