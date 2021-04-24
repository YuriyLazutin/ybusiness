-- Create table
CREATE TABLE Solution
(
   id            INTEGER NOT NULL
  ,idParent      INTEGER
  ,Name          VARCHAR2(1024) NOT NULL
  ,Schema        VARCHAR2(255) NOT NULL
  ,Multilanguage CHAR(1) DEFAULT 'X' NOT NULL
  ,Help          CHAR(1) DEFAULT 'X' NOT NULL
  ,GUI           CHAR(1) DEFAULT 'X' NOT NULL
  ,Descriptions  CHAR(1) DEFAULT 'X' NOT NULL
  ,Signature     CHAR(1) DEFAULT 'X' NOT NULL
  ,Protection    CHAR(1) DEFAULT 'X' NOT NULL
  ,Description   INTEGER
)
TABLESPACE BASE
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
-- Add comments to the table
COMMENT ON TABLE Solution IS
'Business solution';
-- Add comments to the columns
COMMENT ON COLUMN Solution.id IS
'Solution identifier';
COMMENT ON COLUMN Solution.idParent IS
'Parent solution identifier';
COMMENT ON COLUMN Solution.Name IS
'Solution name';
COMMENT ON COLUMN Solution.Schema IS
'Database schema for solution';
COMMENT ON COLUMN Solution.Multilanguage IS
'Multilanguage support';
COMMENT ON COLUMN Solution.Help IS
'Help manuals support';
COMMENT ON COLUMN Solution.GUI IS
'Solution with graphic user interface';
COMMENT ON COLUMN Solution.Descriptions IS
'Descriptions support';
COMMENT ON COLUMN Solution.Signature IS
'Digital signatures support';
COMMENT ON COLUMN Solution.Protection IS
'Extended data protection';
COMMENT ON COLUMN Solution.Description IS
'Description';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE Solution
  ADD CONSTRAINT SOLUTION_P PRIMARY KEY (id)
  USING INDEX 
  TABLESPACE BASE
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
ALTER TABLE Solution
  ADD CONSTRAINT SOLUTION_U1 UNIQUE (Name)
  USING INDEX 
  TABLESPACE BASE
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
ALTER TABLE Solution
  ADD CONSTRAINT SOLUTION_F1 FOREIGN KEY (idParent)
  REFERENCES Solution (id) ON DELETE CASCADE;
-- Create/Recreate check constraints
ALTER TABLE Solution
  ADD CONSTRAINT SOLUTION_C1
  CHECK (Multilanguage IN ('Y', 'N', 'X'));
ALTER TABLE Solution
  ADD CONSTRAINT SOLUTION_C2
  CHECK (Help IN ('Y', 'N', 'X'));
ALTER TABLE Solution
  ADD CONSTRAINT SOLUTION_C3
  CHECK (GUI IN ('Y', 'N', 'X'));
ALTER TABLE Solution
  ADD CONSTRAINT SOLUTION_C4
  CHECK (Descriptions IN ('Y', 'N', 'X'));
ALTER TABLE Solution
  ADD CONSTRAINT SOLUTION_C5
  CHECK (Signature IN ('Y', 'N', 'X'));
ALTER TABLE Solution
  ADD CONSTRAINT SOLUTION_C6
  CHECK (Protection IN ('Y', 'N', 'X'));
/
-- Create/Recreate triggers
CREATE OR REPLACE TRIGGER Solution_AIU AFTER INSERT OR UPDATE ON Solution FOR EACH ROW
DECLARE
  -- local variables here
  v_id INTEGER;
BEGIN
  NULL;
END Solution_AIU;
/
CREATE OR REPLACE TRIGGER Solution_BD BEFORE DELETE ON Solution FOR EACH ROW
DECLARE
  -- local variables here
  v_id INTEGER;
BEGIN
  NULL;
END solution_bd;
/
