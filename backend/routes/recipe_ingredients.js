// routes/recipe_ingredients.js

const express = require('express');
const router = express.Router();

// Get the ingredients for a single recipe
router.get('/recipe_ingredients/:recipe_id', (req, res) => {
    const db = require('../server').db;
    const id = req.params.recipe_id;
    db.query('select ri.quantity, i.quantity_type, i.name from ingredients i inner join recipe_ingredients ri on ri.ingredient_id = i.id where ri.recipe_id = ?;', [id], (error, results) => {
        if (error) {
            console.error('Error executing query:', error);
            res.status(500).json({ error: 'Internal Server Error' });
        } else {
            res.json(results);
        }
    });
});

module.exports = router;