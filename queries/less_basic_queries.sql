-- which facility has the most staff?
SELECT f.Name as Facility, COUNT (s.StaffID) AS StaffCount
FROM Facility f
JOIN Staff s ON f.FacilityID = s.FacilityID
GROUP BY f.FacilityID, f.Name
ORDER BY COUNT(s.StaffID) DESC
LIMIT 1;

-- list the three most expensive projects based on total projectexpense
SELECT p.Name as Project, SUM(pe.Amount) AS TotalExpense
FROM Project p 
JOIN ProjectExpense pe ON p.ProjectID = pe.ProjectID
GROUP BY p.ProjectID
ORDER BY TotalExpense DESC
LIMIT 3;

-- list each project and its total expense
SELECT p.Name as Project, SUM(pe.Amount) AS TotalExpense
FROM Project p
JOIN ProjectExpense pe ON p.ProjectID = pe.ProjectID
GROUP BY p.ProjectID
ORDER BY TotalExpense DESC;

-- find the staff member with the most tests
SELECT s.FirstName, s.LastName, COUNT(*) AS Tests
FROM Staff s
JOIN Test t ON s.StaffID = t.LeadEngineerID
GROUP BY s.StaffID
ORDER BY Tests DESC;

-- which material type has the highest average enrichment?
SELECT MaterialType, EnrichmentPct 
FROM MaterialBatch
ORDER BY EnrichmentPct DESC
LIMIT 1;

-- for each project, show the number of tests and experiments conducted
SELECT p.Name, COUNT(DISTINCT(t.testID)) as Tests, COUNT(e.ExperimentID) as Experiments
FROM Project p
JOIN Test t on p.ProjectID = t.ProjectID
JOIN Experiment e on e.TestID = t.TestID
GROUP BY p.Name
ORDER BY p.ProjectID;

-- list all techs grouped by type, showing a count per type
SELECT tt.Name as Type, COUNT(*) AS TechCount
FROM Technology t
JOIN TechnologyType tt ON t.TypeID = tt.TypeID
GROUP BY tt.Name;

-- for each role, list all staff members who currently hold that role
SELECT r.Name AS Role, s.FirstName, s.LastName, s.Email
FROM Role r
JOIN Staff s ON r.RoleID = s.RoleID
ORDER BY r.Name, s.LastName, s.FirstName;

-- list projects that have ended but incurred expenses after their end date
SELECT DISTINCT p.ProjectID, p.Name, p.EndDate
FROM Project p
JOIN ProjectExpense pe ON p.ProjectID = pe.ProjectID
WHERE pe.ExpenseDate > p.EndDate;

-- Show all engineers who led at least one test that failed
SELECT DISTINCT s.StaffID, s.FirstName, s.LastName, s.Email
FROM Staff s
JOIN Test t ON s.StaffID = t.LeadEngineerID
WHERE t.Outcome = 'FAIL';

