// routes/recipes.js

const express = require('express');
const router = express.Router();

// Define routes

// Example: Get all recipes
router.get('/recipes', (req, res) => {
    const db = require('../server').db; // Move the import inside the route handler
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

// More routes can be added for creating, updating, and deleting recipes

module.exports = router;