use LibraryManagementSystem

---------------------------------------------------- project part one -------------------------------------------------------
----Tables-----

-- Library
CREATE TABLE Library (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    EstablishedYear INT NOT NULL CHECK (EstablishedYear >= 1800)
);

-- Staff
CREATE TABLE Staff (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    LID INT NOT NULL,
    FOREIGN KEY (LID) REFERENCES Library(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Member
CREATE TABLE Member (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20) NOT NULL,
    StartDate DATE NOT NULL
);

-- Book
CREATE TABLE Book (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ISBN VARCHAR(20) NOT NULL UNIQUE,
    Title VARCHAR(200) NOT NULL,
    Genre VARCHAR(50) NOT NULL CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')),
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    AvailabilityStatus BIT NOT NULL DEFAULT 1, -- 1: Available, 0: Not Available
    ShelfLocation VARCHAR(50),
    LID INT NOT NULL,
    FOREIGN KEY (LID) REFERENCES Library(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Lone
CREATE TABLE Loan (
    MID INT NOT NULL,
    BID INT NOT NULL,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    Status VARCHAR(20) NOT NULL DEFAULT 'Issued' 
        CHECK (Status IN ('Issued', 'Returned', 'Overdue')),
    PRIMARY KEY (MID, BID, LoanDate),
    FOREIGN KEY (MID) REFERENCES Member(ID)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (BID) REFERENCES Book(ID)
        ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Payment
CREATE TABLE Payment (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    Method VARCHAR(20) NOT NULL,
    MID INT NOT NULL,
    BID INT NOT NULL,
    LoanDate DATE NOT NULL,
    FOREIGN KEY (MID, BID, LoanDate) REFERENCES Loan(MID, BID, LoanDate)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Review
CREATE TABLE Review (
    MID INT NOT NULL,
    BID INT NOT NULL,
    ReviewDate DATE NOT NULL,
    Comments TEXT DEFAULT 'No comments',
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    PRIMARY KEY (MID, BID, ReviewDate),
    FOREIGN KEY (MID) REFERENCES Member(ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BID) REFERENCES Book(ID)
        ON DELETE CASCADE ON UPDATE CASCADE  
);

------ real-world data -----
--Libraries
INSERT INTO Library (Name, Location, ContactNumber, EstablishedYear) VALUES
('Central Library', 'Main St, City A', '123456789', 1950),
('Westside Branch', 'West Ave, City B', '987654321', 1980),
('Eastside Learning Center', 'East Blvd, City C', '555777999', 1995);

--Staff
INSERT INTO Staff (FullName, Position, ContactNumber, LID) VALUES
('Alice Smith', 'Librarian', '111222333', 1),
('Bob Johnson', 'Manager', '444555666', 1),
('Carol White', 'Assistant', '777888999', 2),
('David Green', 'Archivist', '222333444', 2),
('Eve Adams', 'Technician', '333444555', 3),
('Frank Moore', 'Security', '999000111', 3);

--Members
INSERT INTO Member (FullName, Email, PhoneNumber, StartDate) VALUES
('Emma Taylor', 'emma@example.com', '999888777', '2023-01-10'),
('Liam Brown', 'liam@example.com', '888777666', '2023-02-15'),
('Olivia Wilson', 'olivia@example.com', '777666555', '2023-03-01'),
('Noah Davis', 'noah@example.com', '666555444', '2023-04-05'),
('Ava Clark', 'ava@example.com', '555444333', '2023-05-10'),
('Ethan Lewis', 'ethan@example.com', '444333222', '2023-06-12'),
('Sophia Hall', 'sophia@example.com', '333222111', '2023-07-01'),
('Mason King', 'mason@example.com', '222111000', '2023-07-15');



--Books
INSERT INTO Book (ISBN, Title, Genre, Price, ShelfLocation, LID) VALUES
('1111111111', 'The Great Gatsby', 'Fiction', 10.99, 'A1', 1),
('2222222222', 'Encyclopedia of Science', 'Reference', 25.50, 'B2', 1),
('3333333333', 'Green Eggs and Ham', 'Children', 7.99, 'C3', 1),
('4444444444', 'The Art of War', 'Non-fiction', 14.00, 'D4', 1),
('5555555555', 'Moby Dick', 'Fiction', 12.00, 'E5', 2),
('6666666666', 'Biology 101', 'Reference', 30.00, 'F6', 2),
('7777777777', 'Fairy Tales', 'Children', 8.50, 'G7', 2),
('8888888888', 'History of Earth', 'Non-fiction', 18.75, 'H8', 2),
('9999999999', 'To Kill a Mockingbird', 'Fiction', 11.25, 'I9', 1),
('0000000000', 'Algebra Made Easy', 'Reference', 20.00, 'J10', 1),
('1010101010', 'Cinderella', 'Children', 6.75, 'K11', 3),
('1212121212', 'Psychology Basics', 'Non-fiction', 22.00, 'L12', 3),
('1313131313', 'Modern Art Explained', 'Non-fiction', 19.99, 'M13', 3);

--Loans
INSERT INTO Loan (MID, BID, LoanDate, DueDate, ReturnDate, Status) VALUES
(1, 1, '2024-05-01', '2024-05-15', NULL, 'Issued'),
(2, 2, '2024-05-02', '2024-05-16', '2024-05-14', 'Returned'),
(3, 3, '2024-05-03', '2024-05-17', NULL, 'Overdue'),
(4, 4, '2024-05-04', '2024-05-18', '2024-05-20', 'Returned'),
(5, 5, '2024-05-05', '2024-05-19', NULL, 'Overdue'),
(6, 6, '2024-05-06', '2024-05-20', NULL, 'Issued'),
(1, 7, '2024-05-07', '2024-05-21', '2024-05-21', 'Returned'),
(2, 8, '2024-05-08', '2024-05-22', NULL, 'Issued'),
(7, 9, '2024-05-09', '2024-05-23', NULL, 'Issued'),
(6, 10, '2024-05-10', '2024-05-24', NULL, 'Issued'),
(8, 11, '2024-05-11', '2024-05-25', NULL, 'Issued');

--Payments
INSERT INTO Payment (PaymentDate, Amount, Method, MID, BID, LoanDate) VALUES
('2024-05-15', 5.00, 'Cash', 5, 5, '2024-05-05'),
('2024-05-21', 2.00, 'Card', 4, 4, '2024-05-04'),
('2024-05-14', 1.50, 'Cash', 2, 2, '2024-05-02'),
('2024-05-21', 3.00, 'Card', 1, 7, '2024-05-07'),
('2024-05-23', 4.00, 'Cash', 7, 9, '2024-05-09'),
('2024-05-25', 6.00, 'Card', 8, 11, '2024-05-11');

--Reviews
INSERT INTO Review (MID, BID, ReviewDate, Comments, Rating) VALUES
(1, 1, '2024-05-16', 'Another review for same book', 4),
(3, 3, '2024-05-17', 'Kids loved it!', 5),
(4, 4, '2024-05-18', 'A classic piece.', 4),
(6, 6, '2024-05-20', 'Detailed and clear.', 5),
(7, 9, '2024-05-25', 'Loved the message!', 5),
(8, 11, '2024-05-26', 'Beautiful story!', 5),
(5, 5, '2024-05-19', 'Tough read but rewarding.', 3);


------simulate real application behavior------

-- Mark book as returned
UPDATE Loan
SET ReturnDate = '2024-05-30', Status = 'Returned'
WHERE MID = 1 AND BID = 1 AND LoanDate = '2024-05-01';

-- Update loan status to overdue
UPDATE Loan
SET Status = 'Overdue'
WHERE MID = 3 AND BID = 3 AND LoanDate = '2024-05-03';

-- Delete a payment
DELETE FROM Payment
WHERE ID = 1;

-- Delete a review
DELETE FROM Review
WHERE MID = 5 AND BID = 5 AND ReviewDate = '2024-05-19';

-- Mark book as returned
UPDATE Loan
SET ReturnDate = '2024-05-30', Status = 'Returned'
WHERE MID = 1 AND BID = 1 AND LoanDate = '2024-05-01';

-- Update loan status to overdue
UPDATE Loan
SET Status = 'Overdue'
WHERE MID = 6 AND BID = 10 AND LoanDate = '2024-05-10';

-- Mark multiple books as returned
UPDATE Loan
SET ReturnDate = '2024-05-30', Status = 'Returned'
WHERE MID = 6 AND BID = 6 AND LoanDate = '2024-05-06';

-- Delete a payment
DELETE FROM Payment
WHERE ID = 1;

-- Delete a review
DELETE FROM Review
WHERE MID = 2 AND BID = 2 AND ReviewDate = '2024-05-16';

-- Extend loan due date
UPDATE Loan
SET DueDate = DATEADD(day, 7, DueDate)
WHERE MID = 8 AND BID = 11 AND LoanDate = '2024-05-11';

-- Change availability status of returned books
UPDATE Book
SET AvailabilityStatus = 1
WHERE ID IN (1, 6);

-- Mark book unavailable on issue
UPDATE Book
SET AvailabilityStatus = 0
WHERE ID = 8;

-- Add a new review
INSERT INTO Review (MID, BID, ReviewDate, Comments, Rating) VALUES
(2, 8, '2024-06-01', 'Very informative.', 4);

-- Add a new payment
INSERT INTO Payment (PaymentDate, Amount, Method, MID, BID, LoanDate) VALUES
('2024-05-28', 2.75, 'Cash', 6, 6, '2024-05-06');
 

 select *
 from Library

  select *
 from Staff

  select *
 from Member

  select *
 from Book

  select *
 from Loan

  select *
 from Payment

  select *
 from Review

--- Error-Based Learning 

DELETE FROM Member WHERE ID = 1;

DELETE FROM Member WHERE ID = 3;

DELETE FROM Book WHERE ID = 6;

DELETE FROM Book WHERE ID = 1;

INSERT INTO Loan (MID, BID, LoanDate, DueDate, ReturnDate, Status)
VALUES (999, 2, '2025-06-01', '2025-06-10', NULL, 'Issued');

INSERT INTO Loan (MID, BID, LoanDate, DueDate, ReturnDate, Status)
VALUES (1, 999, '2025-06-01', '2025-06-10', NULL, 'Issued');

UPDATE Book SET Genre = 'Sci-Fi' WHERE ID = 2;

INSERT INTO Payment (PaymentDate, Amount, Method, MID, BID, LoanDate)
VALUES ('2025-06-01', 0, 'Cash', 1, 1, '2024-05-01');

INSERT INTO Payment (PaymentDate, Amount, Method, MID, BID, LoanDate)
VALUES ('2025-06-01', 5.00, NULL, 1, 1, '2024-05-01');

INSERT INTO Review (MID, BID, ReviewDate, Comments, Rating)
VALUES (1, 999, '2025-06-01', 'Fake book', 3);

INSERT INTO Review (MID, BID, ReviewDate, Comments, Rating)
VALUES (999, 1, '2025-06-01', 'Ghost member review', 4);

UPDATE Loan SET MID = 999 WHERE MID = 1 AND BID = 1 AND LoanDate = '2024-05-01';

--- SELECT Queries 

-- GET /loans/overdue → List all overdue loans with member name, book title, due date 
SELECT M.FullName AS MemberName, B.Title AS BookTitle, L.DueDate
FROM Loan L JOIN Member M ON L.MID = M.ID
JOIN Book B ON L.BID = B.ID
WHERE L.Status = 'Issued' AND L.DueDate < GETDATE();

-- GET /books/unavailable → List books not available 
SELECT DISTINCT B.ID AS BookID, B.Title, B.Genre, B.ISBN
FROM Book B JOIN Loan L ON B.ID = L.BID
WHERE L.Status = 'Issued';

-- GET /members/top-borrowers → Members who borrowed >2 books
SELECT M.ID AS MemberID, M.FullName, COUNT(*) AS BorrowedBooks
FROM Loan L JOIN Member M ON L.MID = M.ID
GROUP BY M.ID, M.FullName
HAVING COUNT(*) > 2;


-- GET /books/:id/ratings → Show average rating per book 
SELECT B.ID AS BookID, B.Title, AVG(R.Rating) AS AverageRating
FROM Review R JOIN Book B ON R.BID = B.ID
WHERE  B.ID = 3
GROUP BY B.ID, B.Title;


-- GET /libraries/:id/genres → Count books by genre 
SELECT B.Genre, COUNT(*) AS BookCount
FROM Book B
WHERE B.LID = 1
GROUP BY B.Genre;


-- GET /members/inactive → List members with no loans 
SELECT M.ID AS MemberID, M.FullName, M.Email
FROM Member M LEFT JOIN Loan L ON M.ID = L.MID
WHERE L.LoanDate IS NULL;


-- GET /payments/summary → Total fine paid per member 
SELECT M.ID AS MemberID, M.FullName, SUM(P.Amount) AS TotalFinePaid
FROM Payment P JOIN Member M ON P.MID = M.ID
GROUP BY M.ID, M.FullName;



-- GET /reviews → Reviews with member and book info
SELECT M.FullName AS MemberName, B.Title AS BookTitle, R.ReviewDate, R.Comments, R.Rating
FROM Review R JOIN Member M ON R.MID = M.ID
JOIN Book B ON R.BID = B.ID;

---- reflect on: 
-- What part was the most difficult? 
--	Error-Based Learning 
-- Which SQL command (DDL, DML, DQL) did you learn the most from? 
--	SELECT Queries 
-- What did you discover from your error logs that made you think like a real developer?
--	how ON DELETE CASCADE ON UPDATE CASCADE work


--------------------------------------------------project part two----------------------------------------------------

-- Advance SELECT Queries

-- GET /books/popular → List top 3 books by number of times they were loaned 
SELECT TOP 3 B.ID AS BookID, B.Title, COUNT(*) AS LoanCount
FROM Loan L JOIN Book B ON L.BID = B.ID
GROUP BY B.ID, B.Title
ORDER BY LoanCount DESC;

-- GET /members/:id/history → Retrieve full loan history of a specific member including book title, loan & return dates 
SELECT B.Title, L.LoanDate, L.DueDate, L.ReturnDate, L.Status
FROM Loan L JOIN Book B ON L.BID = B.ID
WHERE L.MID = 5;

-- GET /books/:id/reviews → Show all reviews for a book with member name and comments 
SELECT M.FullName AS MemberName, R.Comments, R.Rating, R.ReviewDate
FROM Review R JOIN Member M ON R.MID = M.ID
WHERE R.BID = 4;

-- GET /libraries/:id/staff → List all staff working in a given library 
SELECT S.ID AS StaffID, S.FullName, S.Position, S.ContactNumber
FROM Staff S
WHERE S.LID = 3;

-- GET /books/price-range?min=5&max=15 → Show books whose prices fall within a given range 
SELECT ID AS BookID, Title, Price
FROM Book
WHERE Price BETWEEN 5 AND 15;

-- GET /loans/active → List all currently active loans (not yet returned) with member and book info 
SELECT M.FullName AS MemberName, B.Title AS BookTitle, L.LoanDate, L.DueDate
FROM Loan L JOIN Member M ON L.MID = M.ID
JOIN Book B ON L.BID = B.ID
WHERE L.ReturnDate IS NULL;

-- GET /members/with-fines → List members who have paid any fine 
SELECT DISTINCT M.ID AS MemberID, M.FullName
FROM Payment P JOIN  Member M ON P.MID = M.ID;

-- GET /books/never-reviewed →  List books that have never been reviewed 
SELECT B.ID AS BookID, B.Title
FROM Book B LEFT JOIN Review R ON B.ID = R.BID
WHERE R.BID IS NULL;

-- GET /members/:id/loan-history →Show a member’s loan history with book titles and loan status
SELECT B.Title, L.LoanDate, L.ReturnDate, L.Status
FROM Loan L JOIN Book B ON L.BID = B.ID
WHERE L.MID = 6;

-- GET /members/inactive →List all members who have never borrowed any book
SELECT M.ID AS MemberID, M.FullName
FROM Member M LEFT JOIN Loan L ON M.ID = L.MID
WHERE L.BID IS NULL;

-- GET /books/never-loaned → List books that were never loaned 
SELECT B.ID AS BookID, B.Title
FROM Book B LEFT JOIN Loan L ON B.ID = L.BID
WHERE L.BID IS NULL;

-- GET /payments →List all payments with member name and book title
SELECT P.ID AS PaymentID, M.FullName AS MemberName, B.Title AS BookTitle, P.Amount, P.Method, P.PaymentDate
FROM Payment P JOIN Member M ON P.MID = M.ID
JOIN Book B ON P.BID = B.ID;

-- GET /loans/overdue→ List all overdue loans with member and book details 
SELECT M.FullName AS MemberName, B.Title AS BookTitle, L.DueDate
FROM Loan L JOIN Member M ON L.MID = M.ID
JOIN Book B ON L.BID = B.ID
WHERE L.ReturnDate IS NULL AND L.DueDate < GETDATE();

-- GET /books/:id/loan-count → Show how many times a book has been loaned
SELECT B.ID AS BookID, B.Title, COUNT(*) AS LoanCount
FROM Loan L JOIN Book B ON L.BID = B.ID
WHERE B.ID = 1
GROUP BY B.ID, B.Title;

-- GET /members/:id/fines → Get total fines paid by a member across all loans
SELECT M.ID AS MemberID, M.FullName, SUM(P.Amount) AS TotalFines
FROM Payment P JOIN Member M ON P.MID = M.ID
WHERE M.ID = 8
GROUP BY M.ID, M.FullName;

-- GET /libraries/:id/book-stats → Show count of available and unavailable books in a library 
SELECT L.ID AS LibraryID, SUM(CASE WHEN Loan.BID IS NULL THEN 1 ELSE 0 END) AS AvailableBooks, SUM(CASE WHEN Loan.BID IS NOT NULL THEN 1 ELSE 0 END) AS UnavailableBooks
FROM Library L JOIN Book B ON L.ID = B.LID
LEFT JOIN (SELECT BID FROM Loan WHERE ReturnDate IS NULL) AS Loan ON B.ID = Loan.BID
WHERE L.ID = 3
GROUP BY L.ID;

-- GET /reviews/top-rated → Return books with more than 5 reviews and average rating > 4.5
SELECT B.ID AS BookID, B.Title, AVG(R.Rating) AS AvgRating, COUNT(R.BID) AS ReviewCount
FROM Review R JOIN Book B ON R.BID = B.ID
GROUP BY B.ID, B.Title
HAVING COUNT(R.BID) > 5 AND AVG(R.Rating) > 4.5;

-- Simple Views Practice

-- ViewAvailableBooks: A list of all books marked as available. 
CREATE VIEW ViewAvailableBooks AS
SELECT 
    ID AS BookID,
    Title,
    ISBN,
    Genre,
    Price,
    ShelfLocation,
    LID
FROM 
    Book
WHERE 
    AvailabilityStatus = 1;

-- test it
SELECT * FROM ViewAvailableBooks;

-- ViewActiveMembers: Members whose membership started in the past 12 months. 
CREATE VIEW ViewActiveMembers AS
SELECT 
    ID AS MemberID,
    FullName,
    Email,
    PhoneNumber,
    StartDate
FROM 
    Member
WHERE 
    StartDate >= DATEADD(MONTH, -12, GETDATE());

-- test it 
SELECT * FROM ViewActiveMembers;

-- ViewLibraryContacts: List of libraries and their contact numbers. 
CREATE VIEW ViewLibraryContacts AS
SELECT 
    ID AS LibraryID,
    Name AS LibraryName,
    ContactNumber
FROM 
    Library;

-- test it
SELECT * FROM ViewLibraryContacts;


-- Transactions & Aggregation Functions
-- Section A: Transactions Simulation 

BEGIN TRANSACTION;

BEGIN TRY
    -- A member borrows a book → a loan is inserted → book availability must be set to FALSE.

    -- Step 1: Insert a loan record
    INSERT INTO Loan (MID, BID, LoanDate, DueDate, ReturnDate, Status)
    VALUES (1, 4, '2025-06-02', '2025-06-16', NULL, 'Issued');

    -- Step 2: Update book availability to FALSE (0)
    UPDATE Book
    SET AvailabilityStatus = 0
    WHERE ID = 4;

    -- Step 3: Commit if both succeed
    COMMIT;
    PRINT 'Transaction committed successfully.';
END TRY

BEGIN CATCH
    -- Roll back everything if an error occurs
    ROLLBACK;
    PRINT 'Transaction failed. All changes rolled back.';

    -- Optional: Show error details for debugging
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

-- Section B: Aggregation Functions Practice 

-- Count Total Books in Each Genre
SELECT Genre, COUNT(*) AS TotalBooks
FROM Book
GROUP BY Genre;

-- Average Rating Per Book
SELECT BID AS BookID, AVG(Rating) AS AverageRating
FROM Review
GROUP BY BID;

-- Total Fine Paid by Each Member
SELECT MID AS MemberID, SUM(Amount) AS TotalFinePaid
FROM Payment
GROUP BY MID;

-- Highest Payment Ever Made
SELECT MAX(Amount) AS HighestPayment
FROM Payment;

-- Number of Loans Per Member
SELECT MID AS MemberID, COUNT(*) AS LoanCount
FROM Loan
GROUP BY MID;








