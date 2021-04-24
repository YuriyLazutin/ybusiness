-- Create table
CREATE TABLE Subset
(
   id              INTEGER NOT NULL
  ,Name             VARCHAR2(1024) NOT NULL
  ,Owner_Name       VARCHAR2(255) NOT NULL
  ,View_Name        VARCHAR2(255) NOT NULL
  ,Primary_Filter   INTEGER
  ,Secondary_Filter INTEGER
  ,Description      INTEGER
)
TABLESPACE BASE
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255;
-- Add comments to the table
COMMENT ON TABLE Subset IS
'Subset of class instances';
-- Add comments to the columns
COMMENT ON COLUMN Subset.id IS
'Subset identifier';
COMMENT ON COLUMN Subset.Name IS
'Subset name';
COMMENT ON COLUMN Subset.Owner_Name IS
'Subset owner (schema)';
COMMENT ON COLUMN Subset.View_Name IS
'View to show subset';
COMMENT ON COLUMN Subset.Primary_Filter IS
'Primary filter';
COMMENT ON COLUMN Subset.Secondary_Filter IS
'Secondary filter';
COMMENT ON COLUMN Subset.Description IS
'Description';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE Subset
  ADD CONSTRAINT SUBSET_P PRIMARY KEY (id)
  USING INDEX 
  TABLESPACE BASE
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255;
ALTER TABLE Subset
  ADD CONSTRAINT SUBSET_U1 UNIQUE (Name)
  USING INDEX 
  TABLESPACE BASE
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255;
ALTER TABLE Subset
  ADD CONSTRAINT SUBSET_F1 FOREIGN KEY (Primary_Filter)
  REFERENCES Primary_Filter (id) ON DELETE SET NULL;
ALTER TABLE Subset
  ADD CONSTRAINT SUBSET_F2 FOREIGN KEY (Secondary_Filter)
  REFERENCES Secondary_Filter (id) ON DELETE SET NULL;
