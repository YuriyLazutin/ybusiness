-- Create table
CREATE TABLE gTree
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
COMMENT ON TABLE gTree IS
'Trees for presenting and editing class instances';
-- Add comments to the columns
COMMENT ON COLUMN gTree.id IS
'Tree identifier';
COMMENT ON COLUMN gTree.idParent IS
'Parent tree identifier';
COMMENT ON COLUMN gTree.name IS
'Tree name';
COMMENT ON COLUMN gTree.description IS
'Description';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE gTree
  ADD CONSTRAINT GTREE_P PRIMARY KEY (id)
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
ALTER TABLE gTree
  ADD CONSTRAINT GTREE_U1 UNIQUE (Name)
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
ALTER TABLE gTree
  ADD CONSTRAINT GTREE_F1 FOREIGN KEY (idParent)
  REFERENCES gTree (id) ON DELETE CASCADE
;
