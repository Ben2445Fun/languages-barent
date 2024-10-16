//Dependencies
const express = require("express");
const { Pool } = require("pg");
const path = require("path");
const dotenv = require("dotenv");

// Load environment variables
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

const pool = new Pool({
  connectionString: process.env.DATABASE_URL, //DATABASE_URL set in .env
});

const getRandomWord = async () => {
  const result = await pool.query(
    "SELECT word FROM words ORDER BY RANDOM() LIMIT 1" //SQL command
  );
  return result.rows.length > 0 ? result.rows[0].word : "default";
};

app.post("/register", async (req, res) => {
  const { username } = req.body;
  try {
    const result = await pool.query(
      "INSERT INTO users (username) VALUES ($1) RETURNING *",
      [username]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});
