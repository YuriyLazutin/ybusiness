CREATE OR REPLACE PACKAGE BODY Debug IS

  -- Private type declarations

  -- Private constant declarations

  -- Private variable declarations

  -- Function and procedure implementations
  PROCEDURE Add_SQL_Clob(
     psSQL          IN VARCHAR2 DEFAULT NULL
    ,psDescription  IN VARCHAR2 DEFAULT NULL
  ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    vxRow SQL_CLOB%ROWTYPE;
  BEGIN
    vxRow.ID := BASE.iBase.GetNewId('DEV', 'SQL_CLOB');
    vxRow.cSQL := psSQL;
    vxRow.Description := SUBSTR(psDescription, 1, 1024);
    INSERT INTO SQL_CLOB VALUES vxRow;
    COMMIT WORK;
  END Add_SQL_Clob;

  PROCEDURE Add_SQL_Clob(
     pcSQL          IN CLOB     DEFAULT NULL
    ,psDescription  IN VARCHAR2 DEFAULT NULL
  ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    vxRow SQL_CLOB%ROWTYPE;
  BEGIN
    vxRow.ID := BASE.iBase.GetNewId('DEV', 'SQL_CLOB');
    vxRow.cSQL := pcSQL;
    vxRow.Description := SUBSTR(psDescription, 1, 1024);
    INSERT INTO SQL_CLOB VALUES vxRow;
    COMMIT WORK;
  END Add_SQL_Clob;

  PROCEDURE Delete_SQL_Clob(
     pnId           IN NUMBER   DEFAULT NULL
    ,psDescription  IN VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    DELETE FROM SQL_CLOB t
    WHERE (t.id = pnId OR pnId IS NULL)
      AND (t.description = SUBSTR(psDescription, 1, 1024) OR psDescription IS NULL)
    ;
  END Delete_SQL_Clob;

END Debug;
/
