-- Create table
CREATE TABLE gForm
(
   id            INTEGER NOT NULL
  ,idParent      INTEGER
  ,Name          VARCHAR2(1024) NOT NULL
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
COMMENT ON TABLE gForm IS
'Form for editing a class instance';
-- Add comments to the columns
COMMENT ON COLUMN gForm.id IS
'Form identifier';
COMMENT ON COLUMN gForm.idparent IS
'Parent form identifier';
COMMENT ON COLUMN gForm.name IS
'Form name';
COMMENT ON COLUMN gForm.description IS
'Description';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE gForm
  ADD CONSTRAINT GFORM_P PRIMARY KEY (id)
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
ALTER TABLE gForm
  ADD CONSTRAINT GFORM_U1 UNIQUE (Name)
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
ALTER TABLE gForm
  ADD CONSTRAINT GFORM_F1 FOREIGN KEY (idParent)
  REFERENCES gForm (id) ON DELETE CASCADE
;
