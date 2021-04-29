CREATE OR REPLACE PACKAGE BODY iDescription IS

  -- Interface package for class 'Object descriptions'

  /****************************************************
  ***                     Types                     ***
  ****************************************************/

  /****************************************************
  ***                   Constants                   ***
  ****************************************************/

  /****************************************************
  ***                   Variables                   ***
  ****************************************************/

  /****************************************************
  ***             Functions and procedures          ***
  ****************************************************/

  -- Create a new instance of 'Object descriptions'
  PROCEDURE AddObj(
    -- Description identifier
     pnId   OUT BASE.Description.id%TYPE
    -- Description text
    ,psText IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.Description (
       id   -- Description identifier
      ,Text -- Description text
    ) VALUES (
       BASE.Description_Id.NEXTVAL
      ,psText
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'Object descriptions' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Description%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'Description');

    INSERT INTO BASE.Description
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.id
    ;
  END AddObj;

  -- Delete object of 'Object descriptions'
  PROCEDURE DelObj(
    -- Description identifier
     pnId   IN  BASE.Description.id%TYPE
  ) IS
  BEGIN
    DELETE
    FROM BASE.Description t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'Object descriptions' for editing
  PROCEDURE LockObj(
    -- Description identifier
     pnId   IN  BASE.Description.id%TYPE
  ) IS
    vnId BASE.Description.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.Description t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'Object descriptions'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet  OUT BASE.iBASE.RefCursor
    -- Description identifier
    ,pnId   IN  BASE.Description.id%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id   AS nId
        ,t.Text AS cText
      FROM BASE.Description t
      WHERE t.id   = NVL(pnId, t.Id)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
  ****************************************************/

  -- Set instance of 'Object descriptions'
  PROCEDURE SetObj(
    -- Description identifier
     pnId   IN  BASE.Description.id%TYPE
    -- Description text
    ,psText IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.Description t
    SET
       t.Text = psText
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'Object descriptions' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Description%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.Description t
    SET
       t.Text = pxObj.Text
    WHERE t.id = pxObj.id
    ;
  END SetObj;

  -- Set a value of property 'Description text'
  PROCEDURE SetText(
    -- Description identifier
     pnId   IN BASE.Description.id%TYPE
    -- Description text
    ,pcText IN BASE.Description.Text%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Description t
    SET t.Text = pcText
    WHERE t.id = pnId
    ;
  END SetText;

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return a class instance of 'Object descriptions'
  FUNCTION GetObj(
    -- Description identifier
     pnId   IN  BASE.Description.id%TYPE
  ) RETURN BASE.Description%ROWTYPE IS
    vxRow BASE.Description%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.Description t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Description text'
  FUNCTION GetText(
    -- Description identifier
     pnId   IN BASE.Description.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description text
    vcText BASE.Description.Text%TYPE;
  BEGIN
    SELECT t.Text INTO vcText
    FROM
       BASE.Description t
    WHERE t.id = pnId
    ;
    RETURN (vcText);
  END GetText;

END iDescription;
/
