-- Table: tbcategory
CREATE TABLE tbcategory (
    cid INT AUTO_INCREMENT PRIMARY KEY,
    cname VARCHAR(50) NOT NULL
);

-- Table: tbunit
CREATE TABLE tbunit (
    uid INT AUTO_INCREMENT PRIMARY KEY,
    uname VARCHAR(50) NOT NULL
    -- No need for bookId here
);

-- Table: tbbook
CREATE TABLE tbbook (
    bookid VARCHAR(20) PRIMARY KEY,
    bookname VARCHAR(100) NOT NULL,
    price INT(11),
    page INT(11),
    categoryId INT,
    unitId INT,
    FOREIGN KEY (categoryId) REFERENCES tbcategory(cid),
    FOREIGN KEY (unitId) REFERENCES tbunit(uid)
);
