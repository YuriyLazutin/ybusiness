-- Create table
CREATE TABLE SQL_CLOB
(
   id          NUMBER
  ,cSQL        CLOB
  ,Description VARCHAR2(1024)
)
TABLESPACE DEV
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
-- Add comments to the columns 
COMMENT ON COLUMN SQL_CLOB.id IS
'Identifier';
COMMENT ON COLUMN SQL_CLOB.cSQL IS
'Stored SQL or PL/SQL';
COMMENT ON COLUMN SQL_CLOB.Description IS
'Description text for SQL (to clarify content)';

