-- Create table
CREATE TABLE Property
(
   id          INTEGER NOT NULL
  ,Name        VARCHAR2(1024) NOT NULL
  ,Type        INTEGER NOT NULL
  ,Class       INTEGER NOT NULL
  ,RefColumn   VARCHAR2(255) NOT NULL
  ,Description INTEGER
  ,Widget      INTEGER
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
COMMENT ON TABLE Property IS
'Class properties';
-- Add comments to the columns
COMMENT ON COLUMN Property.id IS
'Property identifier';
COMMENT ON COLUMN Property.Name IS
'Property name';
COMMENT ON COLUMN Property.Type IS
'Property type (class identifier)';
COMMENT ON COLUMN Property.Class IS
'Owner class';
COMMENT ON COLUMN Property.RefColumn IS
'Table column storing a property or class reference';
COMMENT ON COLUMN Property.Description IS
'Description';
COMMENT ON COLUMN Property.Widget IS
'Widget to show this property';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE Property
  ADD CONSTRAINT PROPERTY_P PRIMARY KEY (id)
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
ALTER TABLE Property
  ADD CONSTRAINT PROPERTY_U1 UNIQUE (Class, Name)
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
ALTER TABLE Property
  ADD CONSTRAINT PROPERTY_F1 FOREIGN KEY (Type)
  REFERENCES Class (id) ON DELETE SET NULL;
ALTER TABLE Property
  ADD CONSTRAINT PROPERTY_F2 FOREIGN KEY (Class)
  REFERENCES Class (id) ON DELETE CASCADE;
ALTER TABLE Property
  ADD CONSTRAINT PROPERTY_F3 FOREIGN KEY (Widget)
  REFERENCES Widget (id) ON DELETE SET NULL;
-- Grant/Revoke object privileges
GRANT REFERENCES ON Property TO COMMON;
