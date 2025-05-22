const express = require("express");
const mysql = require("mysql");
const cors = require("cors");
const app = express();

app.use(express.json());
app.use(cors());

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "root",
  database: "dbcspb",
});

db.connect((err) => {
  if (err) {
    console.log("Cannot connect to database" + err);
    return;
  }

  console.log("Connected to database");
});

app.get("/", (req, res) => {
  res.send("Welcome! Try /book or /search endpoints.");
});


// Get all books
app.get("/book", (req, res) => {
  try {
    const sql = "SELECT * FROM tbbook";
    db.query(sql, (err, result) => {
      if (err) {
        console.log(err);
        return res.status(400).send();
      }
      return res.status(200).send(result);
    });
  } catch (err) {
    console.log("Error: " + err);
    return res.status(500).send({ message: "Server error", error: err });
  }
});

// Search book by ID or name
app.get("/book/:bid", (req, res) => {
  try {
    const bid = req.params.bid;
    const sql =
      "SELECT * FROM tbbook WHERE bookid LIKE ? or bookname LIKE ? or price LIKE ? or page LIKE ?";
    const val = [`${bid}`, `%${bid}%`, `${bid}`, `${bid}`];
    db.query(sql, val, (err, result) => {
      if (err) {
        console.log(err);
        return res.status(400).send();
      }
      return res.status(200).send(result);
    });
  } catch (err) {
    console.log("Error: " + err);
    return res.status(500).send({ message: "Server error", error: err });
  }
});

// Create new book
app.post("/book", (req, res) => {
  try {
    const { bookid, bookname, price, page } = req.body;

    if (!bookname || !price || !page) {
      return res
        .status(400)
        .send({ message: "Please provide all required fields" });
    }

    let sql;
    let values;

    // If bookid is provided, use it; otherwise, let MySQL auto-increment
    if (bookid) {
      sql =
        "INSERT INTO tbbook (bookid, bookname, price, page) VALUES (?, ?, ?, ?)";
      values = [bookid, bookname, price, page];
    } else {
      sql = "INSERT INTO tbbook (bookname, price, page) VALUES (?, ?, ?)";
      values = [bookname, price, page];
    }

    db.query(sql, values, (err, result) => {
      if (err) {
        console.log(err);
        return res.status(500).send({ message: "Database error", error: err });
      }

      return res.status(201).send({
        message: "Book created successfully",
        bookId: bookid || result.insertId,
      });
    });
  } catch (err) {
    console.log("Error: " + err);
    return res.status(500).send({ message: "Server error", error: err });
  }
});

// Update book
app.put("/book/:id", (req, res) => {
  try {
    const bookId = req.params.id;
    const { bookname, price, page } = req.body;

    if (!bookname || !price || !page) {
      return res
        .status(400)
        .send({ message: "Please provide all required fields" });
    }

    const sql =
      "UPDATE tbbook SET bookname = ?, price = ?, page = ? WHERE bookid = ?";
    const values = [bookname, price, page, bookId];

    db.query(sql, values, (err, result) => {
      if (err) {
        console.log(err);
        return res.status(500).send({ message: "Database error", error: err });
      }

      if (result.affectedRows === 0) {
        return res.status(404).send({ message: "Book not found" });
      }

      return res.status(200).send({ message: "Book updated successfully" });
    });
  } catch (err) {
    console.log("Error: " + err);
    return res.status(500).send({ message: "Server error", error: err });
  }
});

// Delete book
app.delete("/book/:id", (req, res) => {
  try {
    const bookId = req.params.id;

    const sql = "DELETE FROM tbbook WHERE bookid = ?";

    db.query(sql, [bookId], (err, result) => {
      if (err) {
        console.log(err);
        return res.status(500).send({ message: "Database error", error: err });
      }

      if (result.affectedRows === 0) {
        return res.status(404).send({ message: "Book not found" });
      }

      return res.status(200).send({ message: "Book deleted successfully" });
    });
  } catch (err) {
    console.log("Error: " + err);
    return res.status(500).send({ message: "Server error", error: err });
  }
});

// Advanced search endpoint
app.get("/search", (req, res) => {
  try {
    // Get search parameters from query string
    const { query, field, sort, order, limit } = req.query;

    // Default values if not provided
    const searchQuery = query || "";
    const searchField = field || "all"; // 'all' or specific field name
    const sortBy = sort || "bookid";
    const sortOrder = order?.toUpperCase() === "DESC" ? "DESC" : "ASC";
    const resultLimit = limit ? parseInt(limit) : 100;

    let sql = "";
    let values = [];

    // Build the query based on search field
    if (searchField === "all") {
      sql = `
        SELECT * FROM tbbook 
        WHERE bookid LIKE ? 
        OR bookname LIKE ? 
        OR price LIKE ? 
        OR page LIKE ?
        ORDER BY ${sortBy} ${sortOrder}
        LIMIT ?
      `;
      values = [
        `%${searchQuery}%`,
        `%${searchQuery}%`,
        `%${searchQuery}%`,
        `%${searchQuery}%`,
        resultLimit,
      ];
    } else {
      // Search in specific field only
      sql = `
        SELECT * FROM tbbook 
        WHERE ${searchField} LIKE ? 
        ORDER BY ${sortBy} ${sortOrder}
        LIMIT ?
      `;
      values = [`%${searchQuery}%`, resultLimit];
    }

    db.query(sql, values, (err, result) => {
      if (err) {
        console.log(err);
        return res.status(500).send({ message: "Database error", error: err });
      }

      return res.status(200).send({
        results: result,
        count: result.length,
        query: searchQuery,
        field: searchField,
        sortBy: sortBy,
        sortOrder: sortOrder,
      });
    });
  } catch (err) {
    console.log("Error: " + err);
    return res.status(500).send({ message: "Server error", error: err });
  }
});

// Simple search by any field (alternative implementation)
app.get("/quicksearch", (req, res) => {
  try {
    const searchTerm = req.query.q || "";

    if (searchTerm.trim() === "") {
      return res.status(400).send({ message: "Search term is required" });
    }

    const sql = `
      SELECT * FROM tbbook 
      WHERE bookid LIKE ? 
      OR bookname LIKE ? 
      OR price LIKE ? 
      OR page LIKE ?
    `;

    const values = Array(4).fill(`%${searchTerm}%`);

    db.query(sql, values, (err, result) => {
      if (err) {
        console.log(err);
        return res.status(500).send({ message: "Database error", error: err });
      }

      return res.status(200).send(result);
    });
  } catch (err) {
    console.log("Error: " + err);
    return res.status(500).send({ message: "Server error", error: err });
  }
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
