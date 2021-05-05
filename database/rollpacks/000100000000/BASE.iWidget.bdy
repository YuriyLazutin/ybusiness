CREATE OR REPLACE PACKAGE BODY iWidget IS

  -- Interface package for class 'Widget'

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

  -- Create a new instance of 'Widget'
  PROCEDURE AddObj(
    -- Widget identifier
     pnId          OUT BASE.Widget.id%TYPE
    -- Parent widget identifier
    ,pnIdParent    IN  BASE.Widget.idParent%TYPE DEFAULT NULL
    -- Widget name
    ,psName        IN  BASE.Widget.Name%TYPE
    -- Description
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.Widget (
       id          -- Widget identifier
      ,idParent    -- Parent widget identifier
      ,Name        -- Widget name
      ,Description -- Description
    ) VALUES (
       BASE.Widget_Id.NEXTVAL
      ,pnIdParent
      ,psName
      ,BASE.iBASE.AddDescription(psDescription)
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'Widget' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Widget%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'Widget');

    INSERT INTO BASE.Widget
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.Id
    ;
  END AddObj;

  -- Delete object of 'Widget'
  PROCEDURE DelObj(
    -- Widget identifier
     pnId          IN  BASE.Widget.id%TYPE
  ) IS
  BEGIN
    DELETE
    FROM BASE.Widget t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'Widget' for editing
  PROCEDURE LockObj(
    -- Widget identifier
     pnId          IN  BASE.Widget.id%TYPE
  ) IS
    vnId BASE.Widget.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.Widget t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'Widget'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBASE.RefCursor
    -- Widget identifier
    ,pnId          IN  BASE.Widget.id%TYPE DEFAULT NULL
    -- Parent widget identifier
    ,pnIdParent    IN  BASE.Widget.idParent%TYPE DEFAULT NULL
    -- Widget name
    ,psName        IN  BASE.Widget.Name%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id          AS nId
        ,t.idParent    AS nIdParent
        ,t.Name        AS sName
        ,t.Description AS idDescription
        ,BASE.iDescription.GetText(t.Description) AS cDescription
      FROM BASE.Widget t
      WHERE (t.id          = pnId OR pnId IS NULL)
        AND (t.idParent    = pnIdParent OR pnIdParent IS NULL)
        AND (t.Name        = psName OR psName IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
  ****************************************************/

  -- Set instance of 'Widget'
  PROCEDURE SetObj(
    -- Widget identifier
     pnId          IN  BASE.Widget.id%TYPE
    -- Parent widget identifier
    ,pnIdParent    IN  BASE.Widget.idParent%TYPE DEFAULT NULL
    -- Widget name
    ,psName        IN  BASE.Widget.Name%TYPE
    -- Description
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.Widget t
    SET
       t.idParent    = pnIdParent
      ,t.Name        = psName
      ,t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'Widget' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Widget%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.Widget t
    SET
       t.idParent    = pxObj.idParent
      ,t.Name        = pxObj.Name
      ,t.Description = pxObj.Description
    WHERE t.id = pxObj.id
    ;
  END SetObj;

  -- Set a value of property 'Parent widget identifier'
  PROCEDURE SetIdParent(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
    -- Parent widget identifier
    ,pnIdParent    IN BASE.Widget.idParent%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Widget t
    SET t.idParent = pnIdParent
    WHERE t.id = pnId
    ;
  END SetIdParent;

  -- Set a value of property 'Widget name'
  PROCEDURE SetName(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
    -- Widget name
    ,psName        IN BASE.Widget.Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Widget t
    SET t.Name = psName
    WHERE t.id = pnId
    ;
  END SetName;

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
    -- Description
    ,psDescription IN VARCHAR2
  ) IS
  BEGIN
    UPDATE BASE.Widget t
    SET t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetDescription;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return instance identifier of 'Widget'
  -- using index 'WIDGET_U1'
  FUNCTION GetId1(
    -- Widget name
     psName        IN  BASE.Widget.Name%TYPE
  ) RETURN BASE.Widget.id%TYPE IS
    vnId         BASE.Widget.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM
     BASE.Widget t
    WHERE t.Name = psName
    ;
    RETURN (vnId);
  END GetId1;

  -- Return a class instance of 'Widget'
  FUNCTION GetObj(
    -- Widget identifier
     pnId          IN  BASE.Widget.id%TYPE
  ) RETURN BASE.Widget%ROWTYPE IS
    vxRow BASE.Widget%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.Widget t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Parent widget identifier'
  FUNCTION GetIdParent(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
  ) RETURN BASE.Widget.idParent%TYPE IS
    -- Parent widget identifier
    vnIdParent    BASE.Widget.idParent%TYPE;
  BEGIN
    SELECT t.idParent INTO vnIdParent
    FROM
       BASE.Widget t
    WHERE t.id = pnId
    ;
    RETURN (vnIdParent);
  END GetIdParent;

  -- Return value of property 'Widget name'
  FUNCTION GetName(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
  ) RETURN BASE.Widget.Name%TYPE IS
    -- Widget name
    vsName        BASE.Widget.Name%TYPE;
  BEGIN
    SELECT t.Name INTO vsName
    FROM
       BASE.Widget t
    WHERE t.id = pnId
    ;
    RETURN (vsName);
  END GetName;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description
    vsDescription BASE.Description.Text%TYPE;
  BEGIN
    SELECT d.Text INTO vsDescription
    FROM
       BASE.Widget t
      ,BASE.Description d
    WHERE t.id = pnId
      AND t.Description = d.Id(+)
    ;
    RETURN (vsDescription);
  END GetDescription;

  /*+GENERATOR(New getter)*/

END iWidget;
/
