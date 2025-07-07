CREATE TABLE IF NOT EXISTS `Role` (
    `RoleID`   INT AUTO_INCREMENT PRIMARY KEY,
    `Name`     ENUM('Engineer', 'Scientist', 'Technician', 'Administrator') NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Facility` (
    `FacilityID` INT AUTO_INCREMENT PRIMARY KEY,
    `Name`       VARCHAR(100) NOT NULL UNIQUE,
    `Location`   VARCHAR(255) NOT NULL,
    `Capacity`   INT NOT NULL CHECK (`Capacity` > 0)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Staff` (
    `StaffID`   INT AUTO_INCREMENT PRIMARY KEY,
    `FirstName` VARCHAR(50) NOT NULL,
    `LastName`  VARCHAR(50) NOT NULL,
    `Email`     VARCHAR(100) NOT NULL UNIQUE,
    `DateHired` DATE NOT NULL,
    `RoleID`    INT NOT NULL,
    `FacilityID` INT NULL,
    FOREIGN KEY (`RoleID`) REFERENCES `Role`(`RoleID`) ON DELETE RESTRICT,
    FOREIGN KEY (`FacilityID`) REFERENCES `Facility`(`FacilityID`) ON DELETE SET NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `TechnologyType` (
    `TypeID`    INT AUTO_INCREMENT PRIMARY KEY,
    `Name`      VARCHAR(100) NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Technology` (
    `TechID`        INT AUTO_INCREMENT PRIMARY KEY,
    `Name`          VARCHAR(100) NOT NULL UNIQUE,
    `Description`   TEXT,
    `TypeID`        INT NOT NULL,
    `Status`        ENUM('R&D', 'Testing', 'Production') NOT NULL DEFAULT 'R&D',
    `FacilityID`    INT,
    FOREIGN KEY (`TypeID`) REFERENCES `TechnologyType`(`TypeID`) ON DELETE RESTRICT,
    FOREIGN KEY (`FacilityID`) REFERENCES `Facility`(`FacilityID`) ON DELETE SET NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `StaffTechAccess` (
    `StaffID`     INT NOT NULL,
    `TechID`      INT NOT NULL,
    `AccessLevel` ENUM('View', 'Access', 'Operate', 'Maintain') NOT NULL DEFAULT 'View',
    PRIMARY KEY (`StaffID`, `TechID`),
    FOREIGN KEY (`StaffID`) REFERENCES `Staff`(`StaffID`) ON DELETE CASCADE,
    FOREIGN KEY (`TechID`) REFERENCES `Technology`(`TechID`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `Project` (
    `ProjectID`  INT AUTO_INCREMENT PRIMARY KEY,
    `Name`       VARCHAR(150) NOT NULL UNIQUE,
    `StartDate`  DATE NOT NULL,
    `EndDate`    DATE,
    `Budget`     DECIMAL(15, 2) NOT NULL CHECK (`Budget` >= 0)    
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `MaterialBatch` (
    `BatchID`      INT AUTO_INCREMENT PRIMARY KEY,
    `MaterialType` VARCHAR(100) NOT NULL,
    `EnrichmentPct`  DECIMAL(5, 2) NOT NULL CHECK (`EnrichmentPct` >= 0 AND `EnrichmentPct` <= 100),
    `Quantity`     DECIMAL(15, 2),
    `Supplier`     VARCHAR(100) NOT NULL,
    `ReceivedDate` DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `Test` (
    `TestID`         INT AUTO_INCREMENT PRIMARY KEY,
    `TechnologyID`   INT NOT NULL,
    `ProjectID`      INT NOT NULL,
    `TestDate`       DATE NOT NULL,
    `LeadEngineerID` INT NOT NULL,
    `Outcome`        ENUM('NOT YET STARTED', 'PASS','FAIL','INCONCLUSIVE') DEFAULT 'NOT YET STARTED',
    FOREIGN KEY (`TechnologyID`) REFERENCES `Technology`(`TechID`) ON DELETE RESTRICT,
    FOREIGN KEY (`ProjectID`) REFERENCES `Project`(`ProjectID`) ON DELETE RESTRICT,
    FOREIGN KEY (`LeadEngineerID`) REFERENCES `Staff`(`StaffID`) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `Experiment` (
    `ExperimentID` INT AUTO_INCREMENT PRIMARY KEY,
    `TestID`       INT NOT NULL,
    `BatchID`      INT NOT NULL,
    `Parameters`   TEXT,
    `Result`       TEXT,
    FOREIGN KEY (`TestID`) REFERENCES `Test`(`TestID`) ON DELETE RESTRICT,
    FOREIGN KEY (`BatchID`) REFERENCES `MaterialBatch`(`BatchID`) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `ProjectExpense` (
  `ExpenseID`      INT          AUTO_INCREMENT PRIMARY KEY,
  `ProjectID`      INT          NOT NULL,
  `ExpenseDate`    DATE         NOT NULL,
  `Amount`         DECIMAL(15,2) NOT NULL,
  `TestID`         INT  NULL,
  `ExperimentID`   INT  NULL,
  `BatchID`        INT  NULL,
  `StaffID`        INT  NULL,
  `Description`    TEXT NULL,

  CONSTRAINT checkk_one_reference_only CHECK (
    (TestID       IS NOT NULL) +
    (ExperimentID IS NOT NULL) +
    (BatchID      IS NOT NULL) +
    (StaffID      IS NOT NULL)
    = 1
  ),

  FOREIGN KEY (`ProjectID`)    REFERENCES `Project`(`ProjectID`)      ON DELETE RESTRICT,
  FOREIGN KEY (`TestID`)       REFERENCES `Test`(`TestID`)            ON DELETE RESTRICT,
  FOREIGN KEY (`ExperimentID`) REFERENCES `Experiment`(`ExperimentID`) ON DELETE RESTRICT,
  FOREIGN KEY (`BatchID`)      REFERENCES `MaterialBatch`(`BatchID`)   ON DELETE RESTRICT,
  FOREIGN KEY (`StaffID`)      REFERENCES `Staff`(`StaffID`)           ON DELETE RESTRICT
) ENGINE=InnoDB;










