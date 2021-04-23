-- Create table
CREATE TABLE Widget
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
COMMENT ON TABLE Widget IS
'User interface element';
-- Add comments to the columns
COMMENT ON COLUMN Widget.id IS
'Widget identifier';
COMMENT ON COLUMN Widget.idParent IS
'Parent widget identifier';
COMMENT ON COLUMN Widget.Name IS
'Widget name';
COMMENT ON COLUMN Widget.Description IS
'Description';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE Widget
  ADD CONSTRAINT WIDGET_P PRIMARY KEY (id)
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
ALTER TABLE Widget
  ADD CONSTRAINT WIDGET_U1 UNIQUE (Name)
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
ALTER TABLE Widget
  ADD CONSTRAINT WIDGET_F1 FOREIGN KEY (idParent)
  REFERENCES Widget (id) ON DELETE CASCADE;
