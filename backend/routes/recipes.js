// routes/users.js
const express = require('express');
const router = express.Router();

// Import the MySQL connection pool
const db = require('../server').db;

// Define routes

// Example: Get all users
router.get('/recipes', (req, res) => {
  db.query('SELECT * FROM recipes', (error, results) => {
    if (error) {
      console.error('Error executing query:', error);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      res.json(results);
    }
  });
});

// More routes can be added for creating, updating, and deleting users

module.exports = router;