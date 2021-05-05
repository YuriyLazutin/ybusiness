CREATE OR REPLACE PACKAGE Debug IS

  -- Tools for debugging

  -- Public type declarations

  -- Public constant declarations

  -- Public variable declarations

  -- Public function and procedure declarations
  PROCEDURE Add_SQL_Clob(
     psSQL          IN VARCHAR2 DEFAULT NULL
    ,psDescription  IN VARCHAR2 DEFAULT NULL
  );

  PROCEDURE Add_SQL_Clob(
     pcSQL          IN CLOB     DEFAULT NULL
    ,psDescription  IN VARCHAR2 DEFAULT NULL
  );

  PROCEDURE Delete_SQL_Clob(
     pnId           IN NUMBER   DEFAULT NULL
    ,psDescription  IN VARCHAR2 DEFAULT NULL
  );

END Debug;
/
