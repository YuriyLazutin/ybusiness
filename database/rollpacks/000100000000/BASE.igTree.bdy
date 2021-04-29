CREATE OR REPLACE PACKAGE BODY igTree IS

  -- Interface package for class 'Tree of objects'

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

  -- Create a new instance of 'Tree of objects'
  PROCEDURE AddObj(
    -- Tree identifier
     pnId          OUT BASE.gTree.id%TYPE
    -- Parent tree identifier
    ,pnIdParent    IN  BASE.gTree.idParent%TYPE DEFAULT NULL
    -- Tree name
    ,psName        IN  BASE.gTree.Name%TYPE
    -- Description identifier
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.gTree (
       id          -- Tree identifier
      ,idParent    -- Parent tree identifier
      ,Name        -- Tree name
      ,Description -- Description identifier
    ) VALUES (
       BASE.gTree_Id.NEXTVAL
      ,pnIdParent
      ,psName
      ,BASE.iBASE.AddDescription(psDescription)
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'Tree of objects' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.gTree%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'gTree');

    INSERT INTO BASE.gTree
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.id
    ;
  END AddObj;

  -- Delete object of 'Tree of objects'
  PROCEDURE DelObj(
    -- Tree identifier
     pnId          IN  BASE.gTree.id%TYPE
  ) IS
  BEGIN
    DELETE
    FROM BASE.gTree t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'Tree of objects' for editing
  PROCEDURE LockObj(
    -- Tree identifier
     pnId          IN  BASE.gTree.id%TYPE
  ) IS
    vnId BASE.gTree.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.gTree t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'Tree of objects'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBASE.RefCursor
    -- Tree identifier
    ,pnId          IN  BASE.gTree.id%TYPE DEFAULT NULL
    -- Parent tree identifier
    ,pnIdParent    IN  BASE.gTree.idParent%TYPE DEFAULT NULL
    -- Tree name
    ,psName        IN  BASE.gTree.Name%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id          AS nId
        ,t.idParent    AS nidParent
        ,t.Name        AS sName
        ,t.Description AS idDescription
        ,BASE.iDescription.GetText(t.Description) AS cDescription
      FROM BASE.gTree t
      WHERE (t.id          = pnId OR pnId IS NULL)
        AND (t.idParent    = pnIdParent OR pnIdParent IS NULL)
        AND (t.Name        = psName OR psName IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
  ****************************************************/

  -- Set instance of 'Tree of objects'
  PROCEDURE SetObj(
    -- Tree identifier
     pnId          IN  BASE.gTree.id%TYPE
    -- Parent tree identifier
    ,pnIdParent    IN  BASE.gTree.idParent%TYPE DEFAULT NULL
    -- Tree name
    ,psName        IN  BASE.gTree.Name%TYPE
    -- Description identifier
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.gTree t
    SET
       t.idParent    = pnIdParent
      ,t.Name        = psName
      ,t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'Tree of objects' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.gTree%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.gTree t
    SET
       t.idParent    = pxObj.idParent
      ,t.Name        = pxObj.Name
      ,t.Description = pxObj.Description
    WHERE t.id = pxObj.id
    ;
  END SetObj;

  -- Set a value of property 'Parent tree identifier'
  PROCEDURE SetIdParent(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
    -- Parent tree identifier
    ,pnIdParent    IN BASE.gTree.idParent%TYPE
  ) IS
  BEGIN
    UPDATE BASE.gTree t
    SET t.idParent = pnIdParent
    WHERE t.id = pnId
    ;
  END SetIdParent;

  -- Set a value of property 'Tree name'
  PROCEDURE SetName(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
    -- Tree name
    ,psName        IN BASE.gTree.Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.gTree t
    SET t.Name = psName
    WHERE t.id = pnId
    ;
  END SetName;

  -- Set a value of property 'Description identifier'
  PROCEDURE SetDescription(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
    -- Description identifier
    ,psDescription IN VARCHAR2
  ) IS
  BEGIN
    UPDATE BASE.gTree t
    SET t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetDescription;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return tree identifier of 'Tree of objects'
  -- using index 'GTREE_U1'
  FUNCTION GetId1(
    -- Tree name
     psName        IN  BASE.gTree.Name%TYPE
  ) RETURN BASE.gTree.id%TYPE IS
    vnId         BASE.gTree.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM
     BASE.gTree t
    WHERE t.Name = psName
    ;
    RETURN (vnId);
  END GetId1;

  -- Return a class instance of 'Tree of objects'
  FUNCTION GetObj(
    -- Tree identifier
     pnId          IN  BASE.gTree.id%TYPE
  ) RETURN BASE.gTree%ROWTYPE IS
    vxRow BASE.gTree%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.gTree t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Parent tree identifier'
  FUNCTION GetIdParent(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
  ) RETURN BASE.gTree.idParent%TYPE IS
    -- Parent tree identifier
    vnIdParent    BASE.gTree.idParent%TYPE;
  BEGIN
    SELECT t.idParent INTO vnIdParent
    FROM
       BASE.gTree t
    WHERE t.id = pnId
    ;
    RETURN (vnIdParent);
  END GetIdParent;

  -- Return value of property 'Tree name'
  FUNCTION GetName(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
  ) RETURN BASE.gTree.Name%TYPE IS
    -- Tree name
    vsName        BASE.gTree.Name%TYPE;
  BEGIN
    SELECT t.Name INTO vsName
    FROM
       BASE.gTree t
    WHERE t.id = pnId
    ;
    RETURN (vsName);
  END GetName;

  -- Return value of property 'Description identifier'
  FUNCTION GetDescription(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description identifier
    vsDescription BASE.Description.Text%TYPE;
  BEGIN
    SELECT d.Text INTO vsDescription
    FROM
       BASE.gTree t
      ,BASE.Description d
    WHERE t.id = pnId
      AND t.Description = d.id(+)
    ;
    RETURN (vsDescription);
  END GetDescription;

  /*+GENERATOR(New getter)*/

END igTree;
/
