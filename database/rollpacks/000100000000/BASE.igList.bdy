CREATE OR REPLACE PACKAGE BODY igList IS

  -- Interface package for class 'List of objects'

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

  -- Create a new instance of 'List of objects'
  PROCEDURE AddObj(
    -- List identifier
     pnId          OUT BASE.gList.id%TYPE
    -- Parent list identifier
    ,pnIdParent    IN  BASE.gList.idParent%TYPE DEFAULT NULL
    -- List name
    ,psName        IN  BASE.gList.Name%TYPE
    -- Description identifier
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.gList (
       id          -- List identifier
      ,idParent    -- Parent list identifier
      ,Name        -- List name
      ,Description -- Description identifier
    ) VALUES (
       BASE.gList_Id.NEXTVAL
      ,pnIdParent
      ,psName
      ,BASE.iBASE.AddDescription(psDescription)
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'List of objects' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.gList%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'gList');

    INSERT INTO BASE.gList
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.id
    ;
  END AddObj;

  -- Delete object of 'List of objects'
  PROCEDURE DelObj(
    -- List identifier
     pnId          IN  BASE.gList.id%TYPE
  ) IS
  BEGIN
    DELETE
    FROM BASE.gList t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'List of objects' for editing
  PROCEDURE LockObj(
    -- List identifier
     pnId          IN  BASE.gList.id%TYPE
  ) IS
    vnId BASE.gList.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.gList t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'List of objects'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBASE.RefCursor
    -- List identifier
    ,pnId          IN  BASE.gList.id%TYPE DEFAULT NULL
    -- Parent list identifier
    ,pnIdParent    IN  BASE.gList.idParent%TYPE DEFAULT NULL
    -- List name
    ,psName        IN  BASE.gList.Name%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id          AS nId
        ,t.idParent    AS nidParent
        ,t.Name        AS sName
        ,t.Description AS idDescription
        ,BASE.iDescription.GetText(t.Description) AS cDescription
      FROM BASE.gList t
      WHERE (t.id          = pnId OR pnId IS NULL)
        AND (t.idParent    = pnIdParent OR pnIdParent IS NULL)
        AND (t.Name        = psName OR psName IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
  ****************************************************/

  -- Set instance of 'List of objects'
  PROCEDURE SetObj(
    -- List identifier
     pnId          IN  BASE.gList.id%TYPE
    -- Parent list identifier
    ,pnIdParent    IN  BASE.gList.idParent%TYPE DEFAULT NULL
    -- List name
    ,psName        IN  BASE.gList.Name%TYPE
    -- Description identifier
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.gList t
    SET
       t.idParent    = pnIdParent
      ,t.Name        = psName
      ,t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'List of objects' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.gList%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.gList t
    SET
       t.idParent    = pxObj.idParent
      ,t.Name        = pxObj.Name
      ,t.Description = pxObj.Description
    WHERE t.id = pxObj.id
    ;
  END SetObj;

  -- Set a value of property 'Parent list identifier'
  PROCEDURE SetIdParent(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
    -- Parent list identifier
    ,pnIdParent    IN BASE.gList.idParent%TYPE
  ) IS
  BEGIN
    UPDATE BASE.gList t
    SET t.idParent = pnIdParent
    WHERE t.id = pnId
    ;
  END SetIdParent;

  -- Set a value of property 'List name'
  PROCEDURE SetName(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
    -- List name
    ,psName        IN BASE.gList.Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.gList t
    SET t.Name = psName
    WHERE t.id = pnId
    ;
  END SetName;

  -- Set a value of property 'Description identifier'
  PROCEDURE SetDescription(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
    -- Description identifier
    ,psDescription IN VARCHAR2
  ) IS
  BEGIN
    UPDATE BASE.gList t
    SET t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetDescription;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return list identifier of 'List of objects'
  -- using index 'GLIST_U1'
  FUNCTION GetId1(
    -- List name
     psName        IN  BASE.gList.Name%TYPE
  ) RETURN BASE.gList.id%TYPE IS
    vnId         BASE.gList.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM
     BASE.gList t
    WHERE t.Name = psName
    ;
    RETURN (vnId);
  END GetId1;

  -- Return a class instance of 'List of objects'
  FUNCTION GetObj(
    -- List identifier
     pnId          IN  BASE.gList.id%TYPE
  ) RETURN BASE.gList%ROWTYPE IS
    vxRow BASE.gList%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.gList t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Parent list identifier'
  FUNCTION GetIdParent(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
  ) RETURN BASE.gList.idParent%TYPE IS
    -- Parent list identifier
    vnIdParent    BASE.gList.idParent%TYPE;
  BEGIN
    SELECT t.idParent INTO vnIdParent
    FROM
       BASE.gList t
    WHERE t.id = pnId
    ;
    RETURN (vnIdParent);
  END GetIdParent;

  -- Return value of property 'List name'
  FUNCTION GetName(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
  ) RETURN BASE.gList.Name%TYPE IS
    -- List name
    vsName        BASE.gList.Name%TYPE;
  BEGIN
    SELECT t.Name INTO vsName
    FROM
       BASE.gList t
    WHERE t.id = pnId
    ;
    RETURN (vsName);
  END GetName;

  -- Return value of property 'Description identifier'
  FUNCTION GetDescription(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description identifier
    vsDescription BASE.Description.Text%TYPE;
  BEGIN
    SELECT d.Text INTO vsDescription
    FROM
       BASE.gList t
      ,BASE.Description d
    WHERE t.id = pnId
      AND t.Description = d.id(+)
    ;
    RETURN (vsDescription);
  END GetDescription;

  /*+GENERATOR(New getter)*/

END igList;
/
