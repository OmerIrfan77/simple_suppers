// routes/recipes.js

const express = require('express');
const router = express.Router();

// Define routes

// Example: Get all recipes
router.get('/recipes', (req, res) => {
    const db = require('../server').db;
    console.log('DB: ', db);
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