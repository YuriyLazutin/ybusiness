CREATE OR REPLACE PACKAGE BODY iPrimary_Filter IS

  -- Interface package for class 'Primary filter'

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

  -- Create a new instance of 'Primary filter'
  PROCEDURE AddObj(
    -- Identifier
     pnId          OUT BASE.Primary_Filter.id%TYPE
    -- Parent filter identifier
    ,pnIdParent    IN  BASE.Primary_Filter.idParent%TYPE DEFAULT NULL
    -- Filter name
    ,psName        IN  BASE.Primary_Filter.Name%TYPE
    -- Description
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.Primary_Filter (
       id          -- Identifier
      ,idParent    -- Parent filter identifier
      ,Name        -- Filter name
      ,Description -- Description
    ) VALUES (
       BASE.Primary_Filter_Id.NEXTVAL
      ,pnIdParent
      ,psName
      ,BASE.iBASE.AddDescription(psDescription)
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'Primary filter' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Primary_Filter%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'Primary_Filter');

    INSERT INTO BASE.Primary_Filter
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.id
    ;
  END AddObj;

  -- Delete object of 'Primary filter'
  PROCEDURE DelObj(
    -- Identifier
     pnId          IN  BASE.Primary_Filter.id%TYPE
  ) IS
  BEGIN
    DELETE
    FROM BASE.Primary_Filter t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'Primary filter' for editing
  PROCEDURE LockObj(
    -- Identifier
     pnId          IN  BASE.Primary_Filter.id%TYPE
  ) IS
    vnId BASE.Primary_Filter.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.Primary_Filter t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'Primary filter'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBASE.RefCursor
    -- Identifier
    ,pnId          IN  BASE.Primary_Filter.id%TYPE DEFAULT NULL
    -- Parent filter identifier
    ,pnIdParent    IN  BASE.Primary_Filter.idParent%TYPE DEFAULT NULL
    -- Filter name
    ,psName        IN  BASE.Primary_Filter.Name%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id          AS nId
        ,t.idParent    AS nidParent
        ,t.Name        AS sName
        ,t.Description AS idDescription
        ,BASE.iDescription.GetText(t.Description) AS cDescription
      FROM BASE.Primary_Filter t
      WHERE (t.id          = pnId OR pnId IS NULL)
        AND (t.idParent    = pnIdParent OR pnIdParent IS NULL)
        AND (t.Name        = psName OR psName IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
  ****************************************************/

  -- Set instance of 'Primary filter'
  PROCEDURE SetObj(
    -- Identifier
     pnId          IN  BASE.Primary_Filter.id%TYPE
    -- Parent filter identifier
    ,pnIdParent    IN  BASE.Primary_Filter.idParent%TYPE DEFAULT NULL
    -- Filter name
    ,psName        IN  BASE.Primary_Filter.Name%TYPE
    -- Description
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.Primary_Filter t
    SET
       t.idParent    = pnIdParent
      ,t.Name        = psName
      ,t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'Primary filter' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Primary_Filter%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.Primary_Filter t
    SET
       t.idParent    = pxObj.idParent
      ,t.Name        = pxObj.Name
      ,t.Description = pxObj.Description
    WHERE t.id = pxObj.id
    ;
  END SetObj;

  -- Set a value of property 'Parent filter identifier'
  PROCEDURE SetIdParent(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
    -- Parent filter identifier
    ,pnIdParent    IN BASE.Primary_Filter.idParent%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Primary_Filter t
    SET t.idParent = pnIdParent
    WHERE t.id = pnId
    ;
  END SetIdParent;

  -- Set a value of property 'Filter name'
  PROCEDURE SetName(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
    -- Filter name
    ,psName        IN BASE.Primary_Filter.Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Primary_Filter t
    SET t.Name = psName
    WHERE t.id = pnId
    ;
  END SetName;

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
    -- Description
    ,psDescription IN VARCHAR2
  ) IS
  BEGIN
    UPDATE BASE.Primary_Filter t
    SET t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetDescription;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return instance identifier of 'Primary filter'
  -- using index 'PRIMARY_FILTER_U1'
  FUNCTION GetId1(
    -- Filter name
     psName        IN  BASE.Primary_Filter.Name%TYPE
  ) RETURN BASE.Primary_Filter.id%TYPE IS
    vnId         BASE.Primary_Filter.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM
     BASE.Primary_Filter t
    WHERE t.Name = psName
    ;
    RETURN (vnId);
  END GetId1;

  -- Return a class instance of 'Primary filter'
  FUNCTION GetObj(
    -- Identifier
     pnId          IN  BASE.Primary_Filter.id%TYPE
  ) RETURN BASE.Primary_Filter%ROWTYPE IS
    vxRow BASE.Primary_Filter%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.Primary_Filter t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Parent filter identifier'
  FUNCTION GetIdParent(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
  ) RETURN BASE.Primary_Filter.idParent%TYPE IS
    -- Parent filter identifier
    vnIdParent    BASE.Primary_Filter.idParent%TYPE;
  BEGIN
    SELECT t.idParent INTO vnIdParent
    FROM
       BASE.Primary_Filter t
    WHERE t.id = pnId
    ;
    RETURN (vnIdParent);
  END GetIdParent;

  -- Return value of property 'Filter name'
  FUNCTION GetName(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
  ) RETURN BASE.Primary_Filter.Name%TYPE IS
    -- Filter name
    vsName        BASE.Primary_Filter.Name%TYPE;
  BEGIN
    SELECT t.Name INTO vsName
    FROM
       BASE.Primary_Filter t
    WHERE t.id = pnId
    ;
    RETURN (vsName);
  END GetName;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description
    vsDescription BASE.Description.Text%TYPE;
  BEGIN
    SELECT d.Text INTO vsDescription
    FROM
       BASE.Primary_Filter t
      ,BASE.Description d
    WHERE t.id = pnId
      AND t.Description = d.id(+)
    ;
    RETURN (vsDescription);
  END GetDescription;

  /*+GENERATOR(New getter)*/

END iPrimary_Filter;
/
