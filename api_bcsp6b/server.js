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

// Get all books with category and unit details
app.get("/book", (req, res) => {
  const sql = `
    SELECT b.*, c.cname as categoryName, u.uname as unitName 
    FROM tbbook b 
    LEFT JOIN tbcategory c ON b.categoryId = c.cid 
    LEFT JOIN tbunit u ON b.unitId = u.uid
  `;
  db.query(sql, (err, result) => {
    if (err) return res.status(400).send(err);
    return res.status(200).send(result);
  });
});

// Search book by ID or name with category and unit details
app.get("/book/:bid", (req, res) => {
  const bid = req.params.bid;
  const sql = `
    SELECT b.*, c.cname as categoryName, u.uname as unitName 
    FROM tbbook b 
    LEFT JOIN tbcategory c ON b.categoryId = c.cid 
    LEFT JOIN tbunit u ON b.unitId = u.uid
    WHERE b.bookid LIKE ? OR b.bookname LIKE ? OR b.price LIKE ? OR b.page LIKE ?
  `;
  const val = [`${bid}`, `%${bid}%`, `${bid}`, `${bid}`];
  db.query(sql, val, (err, result) => {
    if (err) return res.status(400).send(err);
    return res.status(200).send(result);
  });
});

// Create new book
app.post("/book", (req, res) => {
  const { bookid, bookname, price, page, categoryId, unitId } = req.body;

  if (!bookid || !bookname || !price || !page) {
    return res.status(400).send({
      message: "Please provide bookid, bookname, price, and page",
    });
  }

  // Validate foreign keys exist
  const validateFK = () => {
    return new Promise((resolve, reject) => {
      let validations = [];

      if (categoryId) {
        validations.push(
          new Promise((res, rej) => {
            db.query(
              "SELECT cid FROM tbcategory WHERE cid = ?",
              [categoryId],
              (err, result) => {
                if (err) rej(err);
                else if (result.length === 0)
                  rej(new Error("Category not found"));
                else res();
              }
            );
          })
        );
      }

      if (unitId) {
        validations.push(
          new Promise((res, rej) => {
            db.query(
              "SELECT uid FROM tbunit WHERE uid = ?",
              [unitId],
              (err, result) => {
                if (err) rej(err);
                else if (result.length === 0) rej(new Error("Unit not found"));
                else res();
              }
            );
          })
        );
      }

      if (validations.length === 0) {
        resolve();
      } else {
        Promise.all(validations).then(resolve).catch(reject);
      }
    });
  };

  validateFK()
    .then(() => {
      const sql =
        "INSERT INTO tbbook (bookid, bookname, price, page, categoryId, unitId) VALUES (?, ?, ?, ?, ?, ?)";
      const values = [
        bookid,
        bookname,
        price,
        page,
        categoryId || null,
        unitId || null,
      ];

      db.query(sql, values, (err, result) => {
        if (err) return res.status(500).send(err);
        return res.status(201).send({
          message: "Book created",
          bookId: bookid,
        });
      });
    })
    .catch((error) => {
      return res.status(400).send({ message: error.message });
    });
});

// Update book
app.put("/book/:id", (req, res) => {
  const bookId = req.params.id;
  const { bookname, price, page, categoryId, unitId } = req.body;

  if (!bookname || !price || !page) {
    return res.status(400).send({
      message: "bookname, price, and page are required",
    });
  }

  // Validate foreign keys exist
  const validateFK = () => {
    return new Promise((resolve, reject) => {
      let validations = [];

      if (categoryId) {
        validations.push(
          new Promise((res, rej) => {
            db.query(
              "SELECT cid FROM tbcategory WHERE cid = ?",
              [categoryId],
              (err, result) => {
                if (err) rej(err);
                else if (result.length === 0)
                  rej(new Error("Category not found"));
                else res();
              }
            );
          })
        );
      }

      if (unitId) {
        validations.push(
          new Promise((res, rej) => {
            db.query(
              "SELECT uid FROM tbunit WHERE uid = ?",
              [unitId],
              (err, result) => {
                if (err) rej(err);
                else if (result.length === 0) rej(new Error("Unit not found"));
                else res();
              }
            );
          })
        );
      }

      if (validations.length === 0) {
        resolve();
      } else {
        Promise.all(validations).then(resolve).catch(reject);
      }
    });
  };

  validateFK()
    .then(() => {
      const sql =
        "UPDATE tbbook SET bookname = ?, price = ?, page = ?, categoryId = ?, unitId = ? WHERE bookid = ?";
      db.query(
        sql,
        [bookname, price, page, categoryId || null, unitId || null, bookId],
        (err, result) => {
          if (err) return res.status(500).send(err);
          if (result.affectedRows === 0)
            return res.status(404).send({ message: "Book not found" });
          return res.status(200).send({ message: "Book updated" });
        }
      );
    })
    .catch((error) => {
      return res.status(400).send({ message: error.message });
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

// Get books by category
app.get("/book/category/:categoryId", (req, res) => {
  const categoryId = req.params.categoryId;
  const sql = `
    SELECT b.*, c.cname as categoryName, u.uname as unitName 
    FROM tbbook b 
    LEFT JOIN tbcategory c ON b.categoryId = c.cid 
    LEFT JOIN tbunit u ON b.unitId = u.uid
    WHERE b.categoryId = ?
  `;
  db.query(sql, [categoryId], (err, result) => {
    if (err) return res.status(500).send(err);
    return res.status(200).send(result);
  });
});

// Get books by unit
app.get("/book/unit/:unitId", (req, res) => {
  const unitId = req.params.unitId;
  const sql = `
    SELECT b.*, c.cname as categoryName, u.uname as unitName 
    FROM tbbook b 
    LEFT JOIN tbcategory c ON b.categoryId = c.cid 
    LEFT JOIN tbunit u ON b.unitId = u.uid
    WHERE b.unitId = ?
  `;
  db.query(sql, [unitId], (err, result) => {
    if (err) return res.status(500).send(err);
    return res.status(200).send(result);
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

// Delete unit (with cascade check)
app.delete("/unit/:id", (req, res) => {
  const uid = req.params.id;

  // Check if unit is referenced by any books
  const checkSql = "SELECT COUNT(*) as count FROM tbbook WHERE unitId = ?";
  db.query(checkSql, [uid], (err, result) => {
    if (err) return res.status(500).send(err);

    if (result[0].count > 0) {
      return res.status(400).send({
        message: "Cannot delete unit. It is referenced by existing books.",
      });
    }

    const deleteSql = "DELETE FROM tbunit WHERE uid = ?";
    db.query(deleteSql, [uid], (err, result) => {
      if (err) return res.status(500).send(err);
      if (result.affectedRows === 0)
        return res.status(404).send({ message: "Unit not found" });
      return res.status(200).send({ message: "Unit deleted" });
    });
  });
});

// ------------------ CATEGORY API ------------------

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

// Delete category (with cascade check)
app.delete("/category/:id", (req, res) => {
  const cid = req.params.id;

  // Check if category is referenced by any books
  const checkSql = "SELECT COUNT(*) as count FROM tbbook WHERE categoryId = ?";
  db.query(checkSql, [cid], (err, result) => {
    if (err) return res.status(500).send(err);

    if (result[0].count > 0) {
      return res.status(400).send({
        message: "Cannot delete category. It is referenced by existing books.",
      });
    }

    const deleteSql = "DELETE FROM tbcategory WHERE cid = ?";
    db.query(deleteSql, [cid], (err, result) => {
      if (err) return res.status(500).send(err);
      if (result.affectedRows === 0)
        return res.status(404).send({ message: "Category not found" });
      return res.status(200).send({ message: "Category deleted" });
    });
  });
});

// ------------------ START SERVER ------------------
app.listen(5000, () => {
  console.log("Server is running on port 5000");
});
