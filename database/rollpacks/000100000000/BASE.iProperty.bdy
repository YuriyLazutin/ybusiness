CREATE OR REPLACE PACKAGE BODY iProperty IS

  -- Interface package for class 'Class property'

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

  -- Create a new instance of 'Class property'
  PROCEDURE AddObj(
    -- Property identifier
     pnId          OUT BASE.Property.id%TYPE
    -- Property name
    ,psName        IN  BASE.Property.Name%TYPE
    -- Property type
    ,pnType        IN  BASE.Property.Type%TYPE
    -- Owner class
    ,pnClass       IN  BASE.Property.Class%TYPE
    -- Referencing table column
    ,psRefColumn   IN  BASE.Property.RefColumn%TYPE
    -- Description
    ,psDescription IN  VARCHAR2 DEFAULT NULL
    -- Widget
    ,pnWidget       IN  BASE.Property.Widget%TYPE DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.Property (
       id          -- Property identifier
      ,Name        -- Property name
      ,Type        -- Property type
      ,Class       -- Owner class
      ,RefColumn   -- Referencing table column
      ,Description -- Description
      ,Widget       -- Widget
    ) VALUES (
       BASE.Property_Id.NEXTVAL
      ,psName
      ,pnType
      ,pnClass
      ,psRefColumn
      ,BASE.iBASE.AddDescription(psDescription)
      ,pnWidget
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'Class property' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Property%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'Property');

    INSERT INTO BASE.Property
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.id
    ;
  END AddObj;

  -- Delete object of 'Class property'
  PROCEDURE DelObj(
    -- Property identifier
     pnId          IN  BASE.Property.id%TYPE
  ) IS
    vxRow BASE.Property%ROWTYPE;
  BEGIN
    vxRow := BASE.iProperty.GetObj(pnId);
    BASE.iDescription.DelObj(vxRow.Description);

    DELETE
    FROM BASE.Property t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'Class property' for editing
  PROCEDURE LockObj(
    -- Property identifier
     pnId          IN  BASE.Property.id%TYPE
  ) IS
    vnId BASE.Property.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.Property t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'Class property'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBASE.RefCursor
    -- Property identifier
    ,pnId          IN  BASE.Property.id%TYPE DEFAULT NULL
    -- Property name
    ,psName        IN  BASE.Property.Name%TYPE DEFAULT NULL
    -- Property type
    ,pnType        IN  BASE.Property.Type%TYPE DEFAULT NULL
    -- Owner class
    ,pnClass       IN  BASE.Property.Class%TYPE DEFAULT NULL
    -- Referencing table column
    ,psRefColumn   IN  BASE.Property.RefColumn%TYPE DEFAULT NULL
    -- Widget
    ,pnWidget       IN  BASE.Property.Widget%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id          AS nId
        ,t.Name        AS sName
        ,t.Type        AS nType
        ,t.Class       AS nClass
        ,t.RefColumn   AS sRefColumn
        ,t.Description AS idDescription
        ,BASE.iDescription.GetText(t.Description) AS cDescription
        ,t.Widget       AS nWidget
      FROM BASE.Property t
      WHERE (t.id          = pnId OR pnId IS NULL)
        AND (t.Name        = psName OR psName IS NULL)
        AND (t.Type        = pnType OR pnType IS NULL)
        AND (t.Class       = pnClass OR pnClass IS NULL)
        AND (t.RefColumn   = psRefColumn OR psRefColumn IS NULL)
        AND (t.Widget       = pnWidget OR pnWidget IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
  ****************************************************/

  -- Set instance of 'Class property'
  PROCEDURE SetObj(
    -- Property identifier
     pnId          IN  BASE.Property.id%TYPE
    -- Property name
    ,psName        IN  BASE.Property.Name%TYPE
    -- Property type
    ,pnType        IN  BASE.Property.Type%TYPE
    -- Owner class
    ,pnClass       IN  BASE.Property.Class%TYPE
    -- Referencing table column
    ,psRefColumn   IN  BASE.Property.RefColumn%TYPE
    -- Description
    ,psDescription IN  VARCHAR2 DEFAULT NULL
    -- Widget
    ,pnWidget       IN  BASE.Property.Widget%TYPE DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.Property t
    SET
       t.Name        = psName
      ,t.Type        = pnType
      ,t.Class       = pnClass
      ,t.RefColumn   = psRefColumn
      ,t.Description = BASE.iBASE.AddDescription(psDescription)
      ,t.Widget       = pnWidget
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'Class property' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Property%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.Property t
    SET
       t.Name        = pxObj.Name
      ,t.Type        = pxObj.Type
      ,t.Class       = pxObj.Class
      ,t.RefColumn   = pxObj.RefColumn
      ,t.Description = pxObj.Description
      ,t.Widget       = pxObj.Widget
    WHERE t.id = pxObj.id
    ;
  END SetObj;

  -- Set a value of property 'Property name'
  PROCEDURE SetName(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Property name
    ,psName        IN BASE.Property.Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Property t
    SET t.Name = psName
    WHERE t.id = pnId
    ;
  END SetName;

  -- Set a value of property 'Property type'
  PROCEDURE SetType(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Property type
    ,pnType        IN BASE.Property.Type%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Property t
    SET t.Type = pnType
    WHERE t.id = pnId
    ;
  END SetType;

  -- Set a value of property 'Owner class'
  PROCEDURE SetClass(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Owner class
    ,pnClass       IN BASE.Property.Class%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Property t
    SET t.Class = pnClass
    WHERE t.id = pnId
    ;
  END SetClass;

  -- Set a value of property 'Referencing table column'
  PROCEDURE SetRefColumn(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Referencing table column
    ,psRefColumn   IN BASE.Property.RefColumn%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Property t
    SET t.RefColumn = psRefColumn
    WHERE t.id = pnId
    ;
  END SetRefColumn;

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Description
    ,psDescription IN VARCHAR2
  ) IS
  BEGIN
    UPDATE BASE.Property t
    SET t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetDescription;

  -- Set a value of property 'Widget'
  PROCEDURE SetWidget(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Widget
    ,pnWidget       IN BASE.Property.Widget%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Property t
    SET t.Widget = pnWidget
    WHERE t.id = pnId
    ;
  END SetWidget;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return instance identifier of 'Class property'
  -- using index 'PROPERTY_U1'
  FUNCTION GetId1(
    -- Owner class
     pnClass       IN  BASE.Property.Class%TYPE
    -- Property name
    ,psName        IN  BASE.Property.Name%TYPE
  ) RETURN BASE.Property.id%TYPE IS
    vnId         BASE.Property.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM
     BASE.Property t
    WHERE t.Class = pnClass
      AND t.Name = psName
    ;
    RETURN (vnId);
  END GetId1;

  -- Return a class instance of 'Class property'
  FUNCTION GetObj(
    -- Property identifier
     pnId          IN  BASE.Property.id%TYPE
  ) RETURN BASE.Property%ROWTYPE IS
    vxRow BASE.Property%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.Property t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Property name'
  FUNCTION GetName(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Property.Name%TYPE IS
    -- Property name
    vsName        BASE.Property.Name%TYPE;
  BEGIN
    SELECT t.Name INTO vsName
    FROM
       BASE.Property t
    WHERE t.id = pnId
    ;
    RETURN (vsName);
  END GetName;

  -- Return value of property 'Property type'
  FUNCTION GetType(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Property.Type%TYPE IS
    -- Property type
    vnType        BASE.Property.Type%TYPE;
  BEGIN
    SELECT t.Type INTO vnType
    FROM
       BASE.Property t
    WHERE t.id = pnId
    ;
    RETURN (vnType);
  END GetType;

  -- Return value of property 'Owner class'
  FUNCTION GetClass(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Property.Class%TYPE IS
    -- Owner class
    vnClass       BASE.Property.Class%TYPE;
  BEGIN
    SELECT t.Class INTO vnClass
    FROM
       BASE.Property t
    WHERE t.id = pnId
    ;
    RETURN (vnClass);
  END GetClass;

  -- Return value of property 'Referencing table column'
  FUNCTION GetRefColumn(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Property.RefColumn%TYPE IS
    -- Referencing table column
    vsRefColumn   BASE.Property.RefColumn%TYPE;
  BEGIN
    SELECT t.RefColumn INTO vsRefColumn
    FROM
       BASE.Property t
    WHERE t.id = pnId
    ;
    RETURN (vsRefColumn);
  END GetRefColumn;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description
    vsDescription BASE.Description.Text%TYPE;
  BEGIN
    SELECT d.Text INTO vsDescription
    FROM
       BASE.Property t
      ,BASE.Description d
    WHERE t.id = pnId
      AND t.Description = d.id(+)
    ;
    RETURN (vsDescription);
  END GetDescription;

  -- Return value of property 'Widget'
  FUNCTION GetWidget(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Property.Widget%TYPE IS
    -- Widget
    vnWidget       BASE.Property.Widget%TYPE;
  BEGIN
    SELECT t.Widget INTO vnWidget
    FROM
       BASE.Property t
    WHERE t.id = pnId
    ;
    RETURN (vnWidget);
  END GetWidget;

  /*+GENERATOR(New getter)*/

END iProperty;
/
