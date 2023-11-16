const express = require('express');
const mysql = require('mysql');
const fs = require('fs');
require('dotenv').config();

const app = express();




// Middleware for parsing JSON requests
app.use(express.json());

// Middleware for handling CORS (enable cross-origin resource sharing)
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});

const port = process.env.PORT || 3000;

const db = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: {
        ca: fs.readFileSync(process.env.DB_CA),
    }
  });

// Routes
const recipesRoutes = require('./routes/recipes');
app.use('/api', recipesRoutes);

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});

process.on('SIGINT', () => {
    db.end((err) => {
        if (err) {
            console.error('Error closing database connection:', err);
        } else {
            console.log('Database connection closed');
        }
        process.exit();
    });
});

module.exports = { app, db };