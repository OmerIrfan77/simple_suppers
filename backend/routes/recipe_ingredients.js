// routes/recipe_ingredients.js

const express = require('express');
const router = express.Router();


/**
 * Recipe_Ingredients routes
 */
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


//POST an ingredient to recipe
router.post('/recipe/:id/ingredient', (req, res) => {
try {
    const db = require("../server").db;
    const id = req.params.id;
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
        return res.status(400).json({ error: 'Ingredient with the same name already exists' });
    }

    // Add a new ingredient to the database
    db.query('INSERT INTO ingredients (name, quantity_type) VALUES (?, ?)', [name, unit], (err) => {
        if (err) {
        console.error('Error inserting into database:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
        }

        return res.status(201).json({ message: 'Ingredient added successfully' });
    });
    });
} catch (err) {
    console.error('Exception:', err);
    res.status(500).json({ error: 'Internal Server Error' });
}
});

//DELETE a recipe-ingredient association by ID
router.delete('/api/recipe_ingredients/:id', (req, res) => {
const db = require("../server").db;
const associationId = req.params.id;

db.query('DELETE FROM recipe_ingredients WHERE id = ?', [associationId], (err, result) => {
    if (err) {
    console.error('Error deleting from database:', err);
    return res.status(500).json({ error: 'Internal Server Error' });
    }

    if (result.affectedRows === 0) {
    return res.status(404).json({ error: 'Association not found' });
    }

    return res.status(200).json({ message: 'Association deleted successfully' });
});
});

module.exports = router;
