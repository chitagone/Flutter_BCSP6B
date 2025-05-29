const express = require("express");
const mysql = require("mysql");
const cors = require("cors");
const app = express();

app.use(express.json());
app.use(cors());

// Database connection
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "root",
  database: "dbcsp6b",
});

db.connect((err) => {
  if (err) {
    console.log("Cannot connect to database: " + err);
    return;
  }
  console.log("Connected to database");
});

// ------------------ BOOK API ------------------

// Get all books
app.get("/book", (req, res) => {
  const sql = "SELECT * FROM tbbook";
  db.query(sql, (err, result) => {
    if (err) return res.status(400).send(err);
    return res.status(200).send(result);
  });
});

// Search book by ID or name
app.get("/book/:bid", (req, res) => {
  const bid = req.params.bid;
  const sql =
    "SELECT * FROM tbbook WHERE bookid LIKE ? or bookname LIKE ? or price LIKE ? or page LIKE ?";
  const val = [`${bid}`, `%${bid}%`, `${bid}`, `${bid}`];
  db.query(sql, val, (err, result) => {
    if (err) return res.status(400).send(err);
    return res.status(200).send(result);
  });
});

// Create new book
app.post("/book", (req, res) => {
  const { bookid, bookname, price, page } = req.body;
  if (!bookname || !price || !page) {
    return res
      .status(400)
      .send({ message: "Please provide all required fields" });
  }

  let sql, values;
  if (bookid) {
    sql =
      "INSERT INTO tbbook (bookid, bookname, price, page) VALUES (?, ?, ?, ?)";
    values = [bookid, bookname, price, page];
  } else {
    sql = "INSERT INTO tbbook (bookname, price, page) VALUES (?, ?, ?)";
    values = [bookname, price, page];
  }

  db.query(sql, values, (err, result) => {
    if (err) return res.status(500).send(err);
    return res
      .status(201)
      .send({ message: "Book created", bookId: bookid || result.insertId });
  });
});

// Update book
app.put("/book/:id", (req, res) => {
  const bookId = req.params.id;
  const { bookname, price, page } = req.body;
  if (!bookname || !price || !page) {
    return res.status(400).send({ message: "All fields are required" });
  }

  const sql =
    "UPDATE tbbook SET bookname = ?, price = ?, page = ? WHERE bookid = ?";
  db.query(sql, [bookname, price, page, bookId], (err, result) => {
    if (err) return res.status(500).send(err);
    if (result.affectedRows === 0)
      return res.status(404).send({ message: "Book not found" });
    return res.status(200).send({ message: "Book updated" });
  });
});

// Delete book
app.delete("/book/:id", (req, res) => {
  const bookId = req.params.id;
  const sql = "DELETE FROM tbbook WHERE bookid = ?";
  db.query(sql, [bookId], (err, result) => {
    if (err) return res.status(500).send(err);
    if (result.affectedRows === 0)
      return res.status(404).send({ message: "Book not found" });
    return res.status(200).send({ message: "Book deleted" });
  });
});

// ------------------ UNIT API ------------------

// Get all units
app.get("/unit", (req, res) => {
  const sql = "SELECT * FROM tbunit";
  db.query(sql, (err, result) => {
    if (err) return res.status(500).send(err);
    return res.status(200).send(result);
  });
});

// Get unit by ID
app.get("/unit/:id", (req, res) => {
  const uid = req.params.id;
  const sql = "SELECT * FROM tbunit WHERE uid = ?";
  db.query(sql, [uid], (err, result) => {
    if (err) return res.status(500).send(err);
    if (result.length === 0)
      return res.status(404).send({ message: "Unit not found" });
    return res.status(200).send(result[0]);
  });
});

// Create new unit
app.post("/unit", (req, res) => {
  const { uname } = req.body;
  if (!uname) return res.status(400).send({ message: "Unit name is required" });

  const sql = "INSERT INTO tbunit (uname) VALUES (?)";
  db.query(sql, [uname], (err, result) => {
    if (err) return res.status(500).send(err);
    return res
      .status(201)
      .send({ message: "Unit created", uid: result.insertId });
  });
});

// Update unit
app.put("/unit/:id", (req, res) => {
  const uid = req.params.id;
  const { uname } = req.body;
  if (!uname) return res.status(400).send({ message: "Unit name is required" });

  const sql = "UPDATE tbunit SET uname = ? WHERE uid = ?";
  db.query(sql, [uname, uid], (err, result) => {
    if (err) return res.status(500).send(err);
    if (result.affectedRows === 0)
      return res.status(404).send({ message: "Unit not found" });
    return res.status(200).send({ message: "Unit updated" });
  });
});

// Delete unit
app.delete("/unit/:id", (req, res) => {
  const uid = req.params.id;
  const sql = "DELETE FROM tbunit WHERE uid = ?";
  db.query(sql, [uid], (err, result) => {
    if (err) return res.status(500).send(err);
    if (result.affectedRows === 0)
      return res.status(404).send({ message: "Unit not found" });
    return res.status(200).send({ message: "Unit deleted" });
  });
});

// Get all categories
app.get("/category", (req, res) => {
  const sql = "SELECT * FROM tbcategory";
  db.query(sql, (err, result) => {
    if (err) return res.status(500).send(err);
    return res.status(200).send(result);
  });
});

// Get category by ID
app.get("/category/:id", (req, res) => {
  const cid = req.params.id;
  const sql = "SELECT * FROM tbcategory WHERE cid = ?";
  db.query(sql, [cid], (err, result) => {
    if (err) return res.status(500).send(err);
    if (result.length === 0)
      return res.status(404).send({ message: "Category not found" });
    return res.status(200).send(result[0]);
  });
});

// Create new category
app.post("/category", (req, res) => {
  const { cname } = req.body;
  if (!cname)
    return res.status(400).send({ message: "Category name is required" });

  const sql = "INSERT INTO tbcategory (cname) VALUES (?)";
  db.query(sql, [cname], (err, result) => {
    if (err) return res.status(500).send(err);
    return res
      .status(201)
      .send({ message: "Category created", cid: result.insertId });
  });
});

// Update category
app.put("/category/:id", (req, res) => {
  const cid = req.params.id;
  const { cname } = req.body;
  if (!cname)
    return res.status(400).send({ message: "Category name is required" });

  const sql = "UPDATE tbcategory SET cname = ? WHERE cid = ?";
  db.query(sql, [cname, cid], (err, result) => {
    if (err) return res.status(500).send(err);
    if (result.affectedRows === 0)
      return res.status(404).send({ message: "Category not found" });
    return res.status(200).send({ message: "Category updated" });
  });
});

// Delete category
app.delete("/category/:id", (req, res) => {
  const cid = req.params.id;
  const sql = "DELETE FROM tbcategory WHERE cid = ?";
  db.query(sql, [cid], (err, result) => {
    if (err) return res.status(500).send(err);
    if (result.affectedRows === 0)
      return res.status(404).send({ message: "Category not found" });
    return res.status(200).send({ message: "Category deleted" });
  });
});

// ------------------ START SERVER ------------------
app.listen(5000, () => {
  console.log("Server is running on port 5000");
});
