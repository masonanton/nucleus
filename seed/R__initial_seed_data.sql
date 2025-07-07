-- R__initial_seed_data.sql

-- 1) Roles
INSERT INTO `Role` (`Name`) VALUES
  ('Engineer'),
  ('Scientist'),
  ('Technician'),
  ('Administrator')
ON DUPLICATE KEY UPDATE
  `Name` = VALUES(`Name`);

-- 2) Facilities
INSERT INTO `Facility` (`Name`,`Location`,`Capacity`) VALUES
  ('Alpha Reactor Lab','Oak Ridge, TN, USA',80),
  ('Beta Test Facility','Hanford, WA, USA',50),
  ('Gamma Operations Center','Idaho Falls, ID, USA',40)
ON DUPLICATE KEY UPDATE
  `Location` = VALUES(`Location`),
  `Capacity` = VALUES(`Capacity`);

-- 3) Staff
INSERT INTO `Staff` (`FirstName`,`LastName`,`Email`,`DateHired`,`RoleID`,`FacilityID`) VALUES
  ('Alice','Wong','alice.wong@fissionco.com','2023-05-10',
    (SELECT RoleID FROM `Role` WHERE `Name`='Engineer'),
    (SELECT FacilityID FROM `Facility` WHERE `Name`='Alpha Reactor Lab')
  ),
  ('Bob','Smith','bob.smith@fissionco.com','2022-11-01',
    (SELECT RoleID FROM `Role` WHERE `Name`='Technician'),
    (SELECT FacilityID FROM `Facility` WHERE `Name`='Beta Test Facility')
  ),
  ('Carol','Nguyen','carol.nguyen@fissionco.com','2024-01-20',
    (SELECT RoleID FROM `Role` WHERE `Name`='Scientist'),
    (SELECT FacilityID FROM `Facility` WHERE `Name`='Alpha Reactor Lab')
  ),
  ('David','Patel','david.patel@fissionco.com','2023-08-15',
    (SELECT RoleID FROM `Role` WHERE `Name`='Administrator'),
    NULL
  ),
  ('Eve','Garcia','eve.garcia@fissionco.com','2024-03-05',
    (SELECT RoleID FROM `Role` WHERE `Name`='Engineer'),
    (SELECT FacilityID FROM `Facility` WHERE `Name`='Gamma Operations Center')
  )
ON DUPLICATE KEY UPDATE
  `Email`     = VALUES(`Email`),
  `DateHired` = VALUES(`DateHired`);

-- 4) Technology Types
INSERT INTO `TechnologyType` (`Name`) VALUES
  ('Reactor Module'),
  ('Control System'),
  ('Diagnostic Instrument'),
  ('Safety System')
ON DUPLICATE KEY UPDATE
  `Name` = VALUES(`Name`);

-- 5) Technologies
INSERT INTO `Technology` (`Name`,`Description`,`TypeID`,`Status`,`FacilityID`) VALUES
  (
    'Module MK-I',
    'Prototype small modular reactor core',
    (SELECT TypeID FROM `TechnologyType` WHERE `Name`='Reactor Module'),
    'Testing',
    (SELECT FacilityID FROM `Facility` WHERE `Name`='Alpha Reactor Lab')
  ),
  (
    'Control AI v2',
    'Automated reactor control and monitoring',
    (SELECT TypeID FROM `TechnologyType` WHERE `Name`='Control System'),
    'R&D',
    (SELECT FacilityID FROM `Facility` WHERE `Name`='Beta Test Facility')
  ),
  (
    'Neutron Flux Sensor',
    'High-precision neutron flux detector',
    (SELECT TypeID FROM `TechnologyType` WHERE `Name`='Diagnostic Instrument'),
    'Production',
    (SELECT FacilityID FROM `Facility` WHERE `Name`='Gamma Operations Center')
  ),
  (
    'Emergency Shutdown Valve',
    'Rapid-response SCRAM system',
    (SELECT TypeID FROM `TechnologyType` WHERE `Name`='Safety System'),
    'Testing',
    (SELECT FacilityID FROM `Facility` WHERE `Name`='Alpha Reactor Lab')
  )
ON DUPLICATE KEY UPDATE
  `Description` = VALUES(`Description`),
  `Status`      = VALUES(`Status`);

-- 6) StaffTechAccess
INSERT INTO `StaffTechAccess` (`StaffID`,`TechID`,`AccessLevel`) VALUES
  (
    (SELECT StaffID FROM `Staff` WHERE `Email`='alice.wong@fissionco.com'),
    (SELECT TechID  FROM `Technology` WHERE `Name`='Module MK-I'),
    'Operate'
  ),
  (
    (SELECT StaffID FROM `Staff` WHERE `Email`='bob.smith@fissionco.com'),
    (SELECT TechID  FROM `Technology` WHERE `Name`='Emergency Shutdown Valve'),
    'Maintain'
  ),
  (
    (SELECT StaffID FROM `Staff` WHERE `Email`='carol.nguyen@fissionco.com'),
    (SELECT TechID  FROM `Technology` WHERE `Name`='Neutron Flux Sensor'),
    'Access'
  ),
  (
    (SELECT StaffID FROM `Staff` WHERE `Email`='eve.garcia@fissionco.com'),
    (SELECT TechID  FROM `Technology` WHERE `Name`='Control AI v2'),
    'Operate'
  )
ON DUPLICATE KEY UPDATE
  `AccessLevel` = VALUES(`AccessLevel`);

-- 7) Projects
INSERT INTO `Project` (`Name`,`StartDate`,`EndDate`,`Budget`) VALUES
  ('MK-I Development','2024-06-01','2025-12-31',1500000.00),
  ('Control AI Integration','2025-01-15',NULL,500000.00)
ON DUPLICATE KEY UPDATE
  `EndDate` = VALUES(`EndDate`),
  `Budget`  = VALUES(`Budget`);

-- 8) Material Batches
INSERT INTO `MaterialBatch` (`MaterialType`,`EnrichmentPct`,`Quantity`,`Supplier`,`ReceivedDate`) VALUES
  ('Uranium Oxide',5.00,2000.00,'Nucleon Supplies Ltd.','2024-07-20'),
  ('Stainless Steel',0.00,500.00,'SteelWorks Co.','2024-08-10'),
  ('Control Rod Alloy',0.00,150.00,'AlloyTech Inc.','2024-09-05')
ON DUPLICATE KEY UPDATE
  `Quantity` = VALUES(`Quantity`),
  `Supplier` = VALUES(`Supplier`);

-- 9) Tests
INSERT INTO `Test` (`TechnologyID`,`ProjectID`,`TestDate`,`LeadEngineerID`,`Outcome`) VALUES
  (
    (SELECT TechID    FROM `Technology`    WHERE `Name`='Module MK-I'),
    (SELECT ProjectID FROM `Project`       WHERE `Name`='MK-I Development'),
    '2024-10-01',
    (SELECT StaffID   FROM `Staff`         WHERE `Email`='alice.wong@fissionco.com'),
    'PASS'
  ),
  (
    (SELECT TechID    FROM `Technology`    WHERE `Name`='Emergency Shutdown Valve'),
    (SELECT ProjectID FROM `Project`       WHERE `Name`='MK-I Development'),
    '2024-11-15',
    (SELECT StaffID   FROM `Staff`         WHERE `Email`='bob.smith@fissionco.com'),
    'INCONCLUSIVE'
  ),
  (
    (SELECT TechID    FROM `Technology`    WHERE `Name`='Control AI v2'),
    (SELECT ProjectID FROM `Project`       WHERE `Name`='Control AI Integration'),
    '2025-03-10',
    (SELECT StaffID   FROM `Staff`         WHERE `Email`='eve.garcia@fissionco.com'),
    'NOT YET STARTED'
  )
ON DUPLICATE KEY UPDATE
  `Outcome` = VALUES(`Outcome`);

-- 10) Experiments
INSERT INTO `Experiment` (`TestID`,`BatchID`,`Parameters`,`Result`) VALUES
  (
    (SELECT TestID  FROM `Test` WHERE `TestDate`='2024-10-01'),
    (SELECT BatchID FROM `MaterialBatch` WHERE `MaterialType`='Uranium Oxide'),
    'power=50MW;coolantFlow=200L/min;pressure=150bar',
    'efficiency=0.85;leakDetected=false'
  ),
  (
    (SELECT TestID  FROM `Test` WHERE `TestDate`='2024-11-15'),
    (SELECT BatchID FROM `MaterialBatch` WHERE `MaterialType`='Stainless Steel'),
    'temp=900C;loadCycle=5;duration=4h',
    'stressOK=true;deformationPct=0.2'
  )
ON DUPLICATE KEY UPDATE
  `Result` = VALUES(`Result`);

-- 11) Project Expenses
INSERT INTO `ProjectExpense` (`ProjectID`,`ExpenseDate`,`Amount`,`TestID`,`ExperimentID`,`BatchID`,`StaffID`,`Description`) VALUES
  (
    (SELECT ProjectID FROM `Project` WHERE `Name`='MK-I Development'),
    '2024-09-01',250000.00,NULL,NULL,
    (SELECT BatchID FROM `MaterialBatch` WHERE `MaterialType`='Uranium Oxide'),
    NULL,
    'Initial purchase of uranium oxide for core loading'
  ),
  (
    (SELECT ProjectID FROM `Project` WHERE `Name`='MK-I Development'),
    '2024-10-01',12000.00,
    (SELECT TestID FROM `Test` WHERE `TestDate`='2024-10-01'),
    NULL,NULL,NULL,
    'Module MK-I core commissioning test costs'
  ),
  (
    (SELECT ProjectID FROM `Project` WHERE `Name`='MK-I Development'),
    '2024-10-01',5000.00,NULL,
    (SELECT ExperimentID FROM `Experiment` WHERE `TestID`=(SELECT TestID FROM `Test` WHERE `TestDate`='2024-10-01')),
    NULL,NULL,
    'Instrumentation rental for first experiment'
  ),
  (
    (SELECT ProjectID FROM `Project` WHERE `Name`='Control AI Integration'),
    '2025-02-15',80000.00,NULL,NULL,NULL,
    (SELECT StaffID FROM `Staff` WHERE `Email`='eve.garcia@fissionco.com'),
    'Engineer labor cost for AI integration phase'
  )
ON DUPLICATE KEY UPDATE
  `Amount`      = VALUES(`Amount`),
  `Description` = VALUES(`Description`);
