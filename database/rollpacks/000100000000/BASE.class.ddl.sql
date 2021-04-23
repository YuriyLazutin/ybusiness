-- Create table
CREATE TABLE Class
(
   id               INTEGER NOT NULL
  ,Name             VARCHAR2(1024) NOT NULL
  ,Owner_Name       VARCHAR2(255)
  ,Table_Name       VARCHAR2(255)
  ,Interface        VARCHAR2(255)
  ,Description      INTEGER
  ,gForm            INTEGER
  ,gList            INTEGER
  ,gTree            INTEGER
  ,Primary_Filter   INTEGER
  ,Secondary_Filter INTEGER
)
TABLESPACE BASE
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255
  STORAGE
  (
    INITIAL 1M
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
-- Add comments to the table
COMMENT ON TABLE Class IS
'Classes';
-- Add comments to the columns
COMMENT ON COLUMN Class.id IS
'Class identifier';
COMMENT ON COLUMN Class.Name IS
'Class name';
COMMENT ON COLUMN Class.Owner_Name IS
'The name of the schema in which the class instances will be stored';
COMMENT ON COLUMN Class.Table_Name IS
'The name of table in which the class instances will be stored';
COMMENT ON COLUMN Class.Interface IS
'The name of the interface package that provides the service for the class and associated table';
COMMENT ON COLUMN Class.Description IS
'Description';
COMMENT ON COLUMN Class.gForm IS
'Identifier of form for class instances editing';
COMMENT ON COLUMN Class.gList IS
'List for presenting and editing class instances';
COMMENT ON COLUMN Class.gTree IS
'Tree for presenting and editing class instances';
COMMENT ON COLUMN Class.Primary_Filter IS
'Primary filter';
COMMENT ON COLUMN Class.Secondary_Filter IS
'Secondary filter';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE Class
  ADD CONSTRAINT CLASS_P PRIMARY KEY (id)
  USING INDEX
  TABLESPACE BASE
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 1M
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
ALTER TABLE Class
  ADD CONSTRAINT CLASS_U1 UNIQUE (Name)
  USING INDEX
  TABLESPACE BASE
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 5M
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
ALTER TABLE Class
  ADD CONSTRAINT CLASS_F1 FOREIGN KEY (gForm)
  REFERENCES gForm (id) ON DELETE SET NULL;
ALTER TABLE Class
  ADD CONSTRAINT CLASS_F2 FOREIGN KEY (gList)
  REFERENCES gList (id) ON DELETE SET NULL;
ALTER TABLE Class
  ADD CONSTRAINT CLASS_F3 FOREIGN KEY (gTree)
  REFERENCES gTree (id) ON DELETE SET NULL;
ALTER TABLE Class
  ADD CONSTRAINT CLASS_F4 FOREIGN KEY (Primary_Filter)
  REFERENCES Primary_Filter (id) ON DELETE SET NULL;
ALTER TABLE Class
  ADD CONSTRAINT CLASS_F5 FOREIGN KEY (Secondary_Filter)
  REFERENCES Secondary_Filter (id) ON DELETE SET NULL;
-- Grant/Revoke object privileges
GRANT REFERENCES ON Class TO COMMON;
