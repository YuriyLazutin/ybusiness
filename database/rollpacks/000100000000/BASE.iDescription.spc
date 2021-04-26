CREATE OR REPLACE PACKAGE iDescription IS

  -- Interface package for class 'Object descriptions'

  /****************************************************
  ***                     Types                     ***
  ****************************************************/

  /****************************************************
  ***                   Constants                   ***
  ****************************************************/

  /****************************************************
  ***                  Variables                    ***
  ****************************************************/

  /****************************************************
  ***           Functions and procedures            ***
  ****************************************************/

  -- Create a new instance of 'Object descriptions'
  PROCEDURE AddObj(
    -- Description identifier
     pnId   OUT BASE.Description.id%TYPE
    -- Description text
    ,psText IN  VARCHAR2 DEFAULT NULL
  );

  -- Create a new instance of 'Object descriptions' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Description%ROWTYPE
  );

  -- Delete object of 'Object descriptions'
  PROCEDURE DelObj(
    -- Description identifier
     pnId   IN  BASE.Description.id%TYPE
  );

  -- Lock object of 'Object descriptions' for editing
  PROCEDURE LockObj(
    -- Description identifier
     pnId   IN  BASE.Description.id%TYPE
  );

  -- Return a set of instances 'Object descriptions'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet  OUT BASE.iBase.RefCursor
    -- Description identifier
    ,pnId   IN  BASE.Description.id%TYPE DEFAULT NULL
  );

  /****************************************************
  ***                   Setters                     ***
  ****************************************************/

  -- Set instance of 'Object descriptions'
  PROCEDURE SetObj(
    -- Description identifier
     pnId   IN  BASE.Description.id%TYPE
    -- Description text
    ,psText IN  VARCHAR2 DEFAULT NULL
  );

  -- Set instance of 'Object descriptions' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Description%ROWTYPE
  );

  -- Set a value of property 'Description text'
  PROCEDURE SetText(
    -- Description identifier
     pnId   IN BASE.Description.id%TYPE
    -- Description text
    ,pcText IN BASE.Description.Text%TYPE
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return a class instance of 'Object descriptions'
  FUNCTION GetObj(
    -- Description identifier
     pnId   IN  BASE.Description.id%TYPE
  ) RETURN BASE.Description%ROWTYPE;

  -- Return value of property 'Description text'
  FUNCTION GetText(
    -- Description identifier
     pnId   IN BASE.Description.id%TYPE
  ) RETURN BASE.Description.Text%TYPE;

END iDescription;
/
