const express = require('express');
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

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});