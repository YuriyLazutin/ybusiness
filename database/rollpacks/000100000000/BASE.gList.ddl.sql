-- Create table
CREATE TABLE gList
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
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
-- Add comments to the table
COMMENT ON TABLE gList IS
'Lists for presenting and editing class instances';
-- Add comments to the columns
COMMENT ON COLUMN gList.id IS
'List identifier';
COMMENT ON COLUMN gList.idParent IS
'Parent list identifier';
COMMENT ON COLUMN gList.Name IS
'List name';
COMMENT ON COLUMN gList.Description IS
'Description';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE gList
  ADD CONSTRAINT GLIST_P PRIMARY KEY (id)
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
ALTER TABLE gList
  ADD CONSTRAINT GLIST_U1 UNIQUE (Name)
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
ALTER TABLE gList
  ADD CONSTRAINT GLIST_F1 FOREIGN KEY (idParent)
  REFERENCES GLIST (id) ON DELETE CASCADE
;
