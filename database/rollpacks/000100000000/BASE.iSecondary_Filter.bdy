CREATE OR REPLACE PACKAGE BODY iSecondary_Filter IS

  -- Interface package for class 'Secondary filter'

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

  -- Create a new instance of 'Secondary filter'
  PROCEDURE AddObj(
    -- Identifier
     pnId          OUT BASE.Secondary_Filter.id%TYPE
    -- Parent filter identifier
    ,pnIdParent    IN  BASE.Secondary_Filter.idParent%TYPE DEFAULT NULL
    -- Filter name
    ,psName        IN  BASE.Secondary_Filter.Name%TYPE
    -- Description
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.Secondary_Filter (
       id          -- Identifier
      ,idParent    -- Parent filter identifier
      ,Name        -- Filter name
      ,Description -- Description
    ) VALUES (
       BASE.Secondary_Filter_Id.NEXTVAL
      ,pnIdParent
      ,psName
      ,BASE.iBASE.AddDescription(psDescription)
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'Secondary filter' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Secondary_Filter%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'Secondary_Filter');

    INSERT INTO BASE.Secondary_Filter
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.id
    ;
  END AddObj;

  -- Delete object of 'Secondary filter'
  PROCEDURE DelObj(
    -- Identifier
     pnId          IN  BASE.Secondary_Filter.id%TYPE
  ) IS
  BEGIN
    DELETE
    FROM BASE.Secondary_Filter t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'Secondary filter' for editing
  PROCEDURE LockObj(
    -- Identifier
     pnId          IN  BASE.Secondary_Filter.id%TYPE
  ) IS
    vnId BASE.Secondary_Filter.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.Secondary_Filter t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'Secondary filter'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBASE.RefCursor
    -- Identifier
    ,pnId          IN  BASE.Secondary_Filter.id%TYPE DEFAULT NULL
    -- Parent filter identifier
    ,pnIdParent    IN  BASE.Secondary_Filter.idParent%TYPE DEFAULT NULL
    -- Filter name
    ,psName        IN  BASE.Secondary_Filter.Name%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id          AS nId
        ,t.idParent    AS nidParent
        ,t.Name        AS sName
        ,t.Description AS idDescription
        ,BASE.iDescription.GetText(t.Description) AS cDescription
      FROM BASE.Secondary_Filter t
      WHERE (t.id          = pnId OR pnId IS NULL)
        AND (t.idParent    = pnIdParent OR pnIdParent IS NULL)
        AND (t.Name        = psName OR psName IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
  ****************************************************/

  -- Set instance of 'Secondary filter'
  PROCEDURE SetObj(
    -- Identifier
     pnId          IN  BASE.Secondary_Filter.id%TYPE
    -- Parent filter identifier
    ,pnIdParent    IN  BASE.Secondary_Filter.idParent%TYPE DEFAULT NULL
    -- Filter name
    ,psName        IN  BASE.Secondary_Filter.Name%TYPE
    -- Description
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.Secondary_Filter t
    SET
       t.idParent    = pnIdParent
      ,t.Name        = psName
      ,t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'Secondary filter' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Secondary_Filter%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.Secondary_Filter t
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
     pnId          IN BASE.Secondary_Filter.id%TYPE
    -- Parent filter identifier
    ,pnIdParent    IN BASE.Secondary_Filter.idParent%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Secondary_Filter t
    SET t.idParent = pnIdParent
    WHERE t.id = pnId
    ;
  END SetIdParent;

  -- Set a value of property 'Filter name'
  PROCEDURE SetName(
    -- Identifier
     pnId          IN BASE.Secondary_Filter.id%TYPE
    -- Filter name
    ,psName        IN BASE.Secondary_Filter.Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Secondary_Filter t
    SET t.Name = psName
    WHERE t.id = pnId
    ;
  END SetName;

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Identifier
     pnId          IN BASE.Secondary_Filter.id%TYPE
    -- Description
    ,psDescription IN VARCHAR2
  ) IS
  BEGIN
    UPDATE BASE.Secondary_Filter t
    SET t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetDescription;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return instance identifier of 'Secondary filter'
  -- using index 'SECONDARY_FILTER_U1'
  FUNCTION GetId1(
    -- Filter name
     psName        IN  BASE.Secondary_Filter.Name%TYPE
  ) RETURN BASE.Secondary_Filter.id%TYPE IS
    vnId         BASE.Secondary_Filter.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM
     BASE.Secondary_Filter t
    WHERE t.Name = psName
    ;
    RETURN (vnId);
  END GetId1;

  -- Return a class instance of 'Secondary filter'
  FUNCTION GetObj(
    -- Identifier
     pnId          IN  BASE.Secondary_Filter.id%TYPE
  ) RETURN BASE.Secondary_Filter%ROWTYPE IS
    vxRow BASE.Secondary_Filter%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.Secondary_Filter t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Parent filter identifier'
  FUNCTION GetIdParent(
    -- Identifier
     pnId          IN BASE.Secondary_Filter.id%TYPE
  ) RETURN BASE.Secondary_Filter.idParent%TYPE IS
    -- Parent filter identifier
    vnIdParent    BASE.Secondary_Filter.idParent%TYPE;
  BEGIN
    SELECT t.idParent INTO vnIdParent
    FROM
       BASE.Secondary_Filter t
    WHERE t.id = pnId
    ;
    RETURN (vnIdParent);
  END GetIdParent;

  -- Return value of property 'Filter name'
  FUNCTION GetName(
    -- Identifier
     pnId          IN BASE.Secondary_Filter.id%TYPE
  ) RETURN BASE.Secondary_Filter.Name%TYPE IS
    -- Filter name
    vsName        BASE.Secondary_Filter.Name%TYPE;
  BEGIN
    SELECT t.Name INTO vsName
    FROM
       BASE.Secondary_Filter t
    WHERE t.id = pnId
    ;
    RETURN (vsName);
  END GetName;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Identifier
     pnId          IN BASE.Secondary_Filter.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description
    vsDescription BASE.Description.Text%TYPE;
  BEGIN
    SELECT d.Text INTO vsDescription
    FROM
       BASE.Secondary_Filter t
      ,BASE.Description d
    WHERE t.id = pnId
      AND t.Description = d.id(+)
    ;
    RETURN (vsDescription);
  END GetDescription;

  /*+GENERATOR(New getter)*/

END iSecondary_Filter;
/
