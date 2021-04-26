CREATE OR REPLACE PACKAGE iBase AS

  TYPE RefCursor  IS REF CURSOR;
  TYPE int_array  IS TABLE OF INTEGER;
  TYPE v255_array IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;

  FUNCTION GetNewId(
     psOwner     IN VARCHAR2 DEFAULT NULL
    ,psTableName IN VARCHAR2
  ) RETURN NUMBER;

  FUNCTION AddDescription(
     psDescription IN VARCHAR2 DEFAULT NULL
  ) RETURN Description.id%TYPE;

  FUNCTION GetBaseType(
     psOwner            IN  VARCHAR2
    ,psTable            IN  VARCHAR2
  ) RETURN Class.id%TYPE;

PROCEDURE RegisterClass(
     psClassName        IN  VARCHAR2
    ,psOwner            IN  VARCHAR2 DEFAULT NULL
    ,psTable            IN  VARCHAR2
    ,psInterfacePackage IN  VARCHAR2 DEFAULT NULL
    ,psDescription      IN  VARCHAR2 DEFAULT NULL
  );

PROCEDURE UnregisterClass(
     pnId        IN  BASE.Class.id%TYPE
  );

  PROCEDURE AssertGrantes(
     psOwner     IN VARCHAR2 DEFAULT NULL
    ,psTableName IN VARCHAR2
  );

  FUNCTION ParseSeparatedList(
     psSeparatedList IN VARCHAR2
    ,psSeparator     IN VARCHAR2
  ) RETURN v255_array;

  -- Adds multilingual support for the schema
  -- 1) Add table Text_Translation
  -- 2) Add table CLOB_Translation
  PROCEDURE AddMultilanguageSupport(
     psOwner            IN  VARCHAR2
  );

END iBase;
/
