-- Create table
CREATE TABLE Description
(
   id   INTEGER NOT NULL
  ,Text CLOB
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
COMMENT ON TABLE Description IS
'Descriptions of system objects';
-- Add comments to the columns 
COMMENT ON COLUMN Description.id IS
'Description identifier';
COMMENT ON COLUMN Description.Text IS
'Description text';
-- Create/Recreate primary, unique and foreign key constraints 
ALTER TABLE Description
  ADD CONSTRAINT DESCRIPTION_P PRIMARY KEY (id)
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
