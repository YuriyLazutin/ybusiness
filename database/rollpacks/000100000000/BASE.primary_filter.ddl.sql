-- Create table
CREATE TABLE Primary_Filter
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
COMMENT ON TABLE Primary_Filter IS
'Primary filter';
-- Add comments to the columns
COMMENT ON COLUMN Primary_Filter.id IS
'Primary filter identifier';
COMMENT ON COLUMN Primary_Filter.idParent IS
'Parent filter identifier';
COMMENT ON COLUMN Primary_Filter.Name IS
'Primary filter name';
COMMENT ON COLUMN Primary_Filter.Description IS
'Description';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE Primary_Filter
  ADD CONSTRAINT PRIMARY_FILTER_P PRIMARY KEY (id)
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
ALTER TABLE Primary_Filter
  ADD CONSTRAINT PRIMARY_FILTER_U1 UNIQUE (Name)
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
ALTER TABLE Primary_Filter
  ADD CONSTRAINT PRIMARY_FILTER_F1 FOREIGN KEY (idParent)
  REFERENCES Primary_Filter (id) ON DELETE CASCADE
;
