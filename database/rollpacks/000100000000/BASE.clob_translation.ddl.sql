-- Create table
CREATE TABLE CLOB_Translation
(
   Language INTEGER NOT NULL
  ,Value    CLOB NOT NULL
  ,Class    INTEGER NOT NULL
  ,Object   INTEGER NOT NULL
  ,Property INTEGER NOT NULL
)
TABLESPACE BASE
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255;
-- Add comments to the table
COMMENT ON TABLE CLOB_Translation IS
'Foreign language translation for CLOB';
-- Add comments to the columns
COMMENT ON COLUMN CLOB_Translation.Language IS
'Foreign language';
COMMENT ON COLUMN CLOB_Translation.Value IS
'Translation';
COMMENT ON COLUMN CLOB_Translation.Class IS
'Class identifier';
COMMENT ON COLUMN CLOB_Translation.Object IS
'Object instance';
COMMENT ON COLUMN CLOB_Translation.Property IS
'Object property';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE CLOB_Translation
  ADD CONSTRAINT CLOB_TRANSLATION_P PRIMARY KEY (Language, Class, Object, Property)
  USING INDEX 
  TABLESPACE BASE
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255;
ALTER TABLE CLOB_Translation
  ADD CONSTRAINT CLOB_TRANSLATION_F2 FOREIGN KEY (Class)
  REFERENCES Class (id) ON DELETE CASCADE;
ALTER TABLE CLOB_Translation
  ADD CONSTRAINT CLOB_TRANSLATION_F3 FOREIGN KEY (Property)
  REFERENCES Property (id) ON DELETE CASCADE;
