-- list all facilites and their locations
SELECT `Name`, `Location` FROM Facility;

-- show the names and email addresses of all staff
SELECT `FirstName`, `LastName`, `Email` FROM Staff;

-- retrieve all techs that are currently in "TESTING"
SELECT `Name`, `Status` FROM Technology
WHERE `Status` = 'TESTING';

-- list all materials received after January 1, 2025
SELECT `MaterialType`, `ReceivedDate` FROM MaterialBatch
WHERE `ReceivedDate` > '2025-01-01';

-- display all tests with a "pass" outcome
SELECT * FROM Test
WHERE `Outcome` = 'PASS';

-- show the number of technologies by each status
SELECT COUNT(*) AS `Count`, `Status` FROM Technology
GROUP BY `Status`;

-- get all projects with a budget greater than $100,000
SELECT `Name`, `Budget` FROM Project
WHERE `Budget` > 100000;

-- get all staff hired in the last year
SELECT `FirstName`, `LastName`, `DateHired` FROM Staff
WHERE DATEDIFF(CURDATE(), `DateHired`) < 365;

-- get counts of how many staff members have access to each technology
SELECT t.Name AS Technology, COUNT(s.StaffID) AS StaffCount
FROM Technology t
JOIN StaffTechAccess s ON t.TechID = s.TechID
GROUP BY t.TechID, t.Name;

