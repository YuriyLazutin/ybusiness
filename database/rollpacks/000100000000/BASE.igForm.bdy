CREATE OR REPLACE PACKAGE BODY igForm IS

  -- Interface package for class 'Forms for object editing'

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

  -- Create a new instance of 'Forms for object editing'
  PROCEDURE AddObj(
    -- Form identifier
     pnId          OUT BASE.gForm.id%TYPE
    -- Parent form identifier
    ,pnIdParent    IN  BASE.gForm.idParent%TYPE DEFAULT NULL
    -- Form name
    ,psName        IN  BASE.gForm.Name%TYPE
    -- Description identifier
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.gForm (
       id          -- Form identifier
      ,idParent    -- Parent form identifier
      ,Name        -- Form name
      ,Description -- Description identifier
    ) VALUES (
       BASE.gForm_Id.NEXTVAL
      ,pnIdParent
      ,psName
      ,BASE.iBASE.AddDescription(psDescription)
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'Forms for object editing' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.gForm%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'gForm');

    INSERT INTO BASE.gForm
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.id
    ;
  END AddObj;

  -- Delete object of 'Forms for object editing'
  PROCEDURE DelObj(
    -- Form identifier
     pnId          IN  BASE.gForm.id%TYPE
  ) IS
  BEGIN
    DELETE
    FROM BASE.gForm t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'Forms for object editing' for editing
  PROCEDURE LockObj(
    -- Form identifier
     pnId          IN  BASE.gForm.id%TYPE
  ) IS
    vnId BASE.gForm.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.gForm t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'Forms for object editing'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBASE.RefCursor
    -- Form identifier
    ,pnId          IN  BASE.gForm.id%TYPE DEFAULT NULL
    -- Parent form identifier
    ,pnIdParent    IN  BASE.gForm.idParent%TYPE DEFAULT NULL
    -- Form name
    ,psName        IN  BASE.gForm.Name%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id          AS nId
        ,t.idParent    AS nidParent
        ,t.Name        AS sName
        ,t.Description AS idDescription
        ,BASE.iDescription.GetText(t.Description) AS cDescription
      FROM BASE.gForm t
      WHERE (t.id          = pnId OR pnId IS NULL)
        AND (t.idParent    = pnIdParent OR pnIdParent IS NULL)
        AND (t.Name        = psName OR psName IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
  ****************************************************/

  -- Set instance of 'Forms for object editing'
  PROCEDURE SetObj(
    -- Form identifier
     pnId          IN  BASE.gForm.id%TYPE
    -- Parent form identifier
    ,pnIdParent    IN  BASE.gForm.idParent%TYPE DEFAULT NULL
    -- Form name
    ,psName        IN  BASE.gForm.Name%TYPE
    -- Description identifier
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.gForm t
    SET
       t.idParent    = pnIdParent
      ,t.Name        = psName
      ,t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'Forms for object editing' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.gForm%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.gForm t
    SET
       t.idParent    = pxObj.idParent
      ,t.Name        = pxObj.Name
      ,t.Description = pxObj.Description
    WHERE t.id = pxObj.id
    ;
  END SetObj;

  -- Set a value of property 'Parent form identifier'
  PROCEDURE SetIdParent(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
    -- Parent form identifier
    ,pnIdParent    IN BASE.gForm.idParent%TYPE
  ) IS
  BEGIN
    UPDATE BASE.gForm t
    SET t.idParent = pnIdParent
    WHERE t.id = pnId
    ;
  END SetIdParent;

  -- Set a value of property 'Form name'
  PROCEDURE SetName(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
    -- Form name
    ,psName        IN BASE.gForm.Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.gForm t
    SET t.Name = psName
    WHERE t.id = pnId
    ;
  END SetName;

  -- Set a value of property 'Description identifier'
  PROCEDURE SetDescription(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
    -- Description identifier
    ,psDescription IN VARCHAR2
  ) IS
  BEGIN
    UPDATE BASE.gForm t
    SET t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetDescription;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return form identifier of 'Form'
  -- using index 'GFORM_U1'
  FUNCTION GetId1(
    -- Form name
     psName        IN  BASE.gForm.Name%TYPE
  ) RETURN BASE.gForm.id%TYPE IS
    vnId         BASE.gForm.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM
     BASE.gForm t
    WHERE t.Name = psName
    ;
    RETURN (vnId);
  END GetId1;

  -- Return a class instance of 'Forms for object editing'
  FUNCTION GetObj(
    -- Form identifier
     pnId          IN  BASE.gForm.id%TYPE
  ) RETURN BASE.gForm%ROWTYPE IS
    vxRow BASE.gForm%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.gForm t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Parent form identifier'
  FUNCTION GetIdParent(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
  ) RETURN BASE.gForm.idParent%TYPE IS
    -- Parent form identifier
    vnIdParent    BASE.gForm.idParent%TYPE;
  BEGIN
    SELECT t.idParent INTO vnIdParent
    FROM
       BASE.gForm t
    WHERE t.id = pnId
    ;
    RETURN (vnIdParent);
  END GetIdParent;

  -- Return value of property 'Form name'
  FUNCTION GetName(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
  ) RETURN BASE.gForm.Name%TYPE IS
    -- Form name
    vsName        BASE.gForm.Name%TYPE;
  BEGIN
    SELECT t.Name INTO vsName
    FROM
       BASE.gForm t
    WHERE t.id = pnId
    ;
    RETURN (vsName);
  END GetName;

  -- Return value of property 'Description identifier'
  FUNCTION GetDescription(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description identifier
    vsDescription BASE.Description.Text%TYPE;
  BEGIN
    SELECT d.Text INTO vsDescription
    FROM
       BASE.gForm t
      ,BASE.Description d
    WHERE t.id = pnId
      AND t.Description = d.id(+)
    ;
    RETURN (vsDescription);
  END GetDescription;

  /*+GENERATOR(New getter)*/

END igForm;
/
