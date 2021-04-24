-- Create table
CREATE TABLE Text_Translation
(
   Language INTEGER NOT NULL
  ,Value    VARCHAR2(1024) NOT NULL
  ,Class    INTEGER NOT NULL
  ,Object   INTEGER NOT NULL
  ,Property INTEGER NOT NULL
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
COMMENT ON TABLE Text_Translation IS
'Foreign language translation for text properties';
-- Add comments to the columns
COMMENT ON COLUMN Text_Translation.Language IS
'Foreign language';
COMMENT ON COLUMN Text_Translation.Value IS
'Translation';
COMMENT ON COLUMN Text_Translation.Class IS
'Class identifier';
COMMENT ON COLUMN Text_Translation.Object IS
'Object instance';
COMMENT ON COLUMN Text_Translation.Property IS
'Object property';
-- Create/Recreate primary, unique and foreign key constraints
ALTER TABLE Text_Translation
  ADD CONSTRAINT TEXT_TRANSLATION_P PRIMARY KEY (Language, Class, Object, Property)
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
ALTER TABLE Text_Translation
  ADD CONSTRAINT TEXT_TRANSLATION_F2 FOREIGN KEY (Class)
  REFERENCES Class (id) ON DELETE CASCADE;
ALTER TABLE Text_Translation
  ADD CONSTRAINT TEXT_TRANSLATION_F3 FOREIGN KEY (Property)
  REFERENCES Property (id) ON DELETE CASCADE;
