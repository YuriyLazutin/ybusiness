-- Create table
CREATE TABLE Secondary_Filter
(
   id          INTEGER NOT NULL
  ,idParent    INTEGER
  ,Name        VARCHAR2(1024) NOT NULL
  ,Description INTEGER
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
COMMENT ON TABLE Secondary_Filter IS
'Secondary filter';
-- Add comments to the columns
COMMENT ON COLUMN Secondary_Filter.id IS
'Secondary filter identifier';
COMMENT ON COLUMN Secondary_Filter.idParent IS
'Parent filter identifier';
COMMENT ON COLUMN Secondary_Filter.Name IS
'Secondary filter name';
COMMENT ON COLUMN Secondary_Filter.Description IS
'Description';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE Secondary_Filter
  ADD CONSTRAINT SECONDARY_FILTER_P PRIMARY KEY (id)
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
ALTER TABLE Secondary_Filter
  ADD CONSTRAINT SECONDARY_FILTER_U1 UNIQUE (Name)
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
ALTER TABLE Secondary_Filter
  ADD CONSTRAINT SECONDARY_FILTER_F1 FOREIGN KEY (idParent)
  REFERENCES Secondary_Filter (id) ON DELETE CASCADE
;
