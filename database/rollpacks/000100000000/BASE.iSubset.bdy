CREATE OR REPLACE PACKAGE BODY iSubset IS

  -- Interface package for class 'Class instance subset'

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

  -- Create a new instance of 'Class instance subset'
  PROCEDURE AddObj(
    -- Subset identifier
     pnId            OUT BASE.Subset.id%TYPE
    -- Subset name
    ,psName          IN  BASE.Subset.Name%TYPE
    -- Subset owner
    ,psOwner_Name    IN  BASE.Subset.Owner_Name%TYPE
    -- Subset view
    ,psView_Name     IN  BASE.Subset.View_Name%TYPE
    -- Primary filter
    ,pnPrimary_Filter IN  BASE.Subset.Primary_Filter%TYPE DEFAULT NULL
    -- Secondary filter
    ,pnSecondary_Filter  IN  BASE.Subset.Secondary_Filter%TYPE DEFAULT NULL
    -- Description
    ,psDescription   IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.Subset (
       id            -- Subset identifier
      ,Name          -- Subset name
      ,Owner_Name    -- Subset owner
      ,View_Name     -- Subset view
      ,Primary_Filter -- Primary filter
      ,Secondary_Filter  -- Secondary filter
      ,Description   -- Description
    ) VALUES (
       BASE.Subset_Id.NEXTVAL
      ,psName
      ,psOwner_Name
      ,psView_Name
      ,pnPrimary_Filter
      ,pnSecondary_Filter
      ,BASE.iBASE.AddDescription(psDescription)
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'Class instance subset' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Subset%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'Subset');

    INSERT INTO BASE.Subset
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.id
    ;
  END AddObj;

  -- Delete object of 'Class instance subset'
  PROCEDURE DelObj(
    -- Subset identifier
     pnId            IN  BASE.Subset.id%TYPE
  ) IS
  BEGIN
    DELETE
    FROM BASE.Subset t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'Class instance subset' for editing
  PROCEDURE LockObj(
    -- Subset identifier
     pnId            IN  BASE.Subset.id%TYPE
  ) IS
    vnId BASE.Subset.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.Subset t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'Class instance subset'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet           OUT BASE.iBASE.RefCursor
    -- Subset identifier
    ,pnId            IN  BASE.Subset.id%TYPE DEFAULT NULL
    -- Subset name
    ,psName          IN  BASE.Subset.Name%TYPE DEFAULT NULL
    -- Subset owner
    ,psOwner_Name    IN  BASE.Subset.Owner_Name%TYPE DEFAULT NULL
    -- Subset view
    ,psView_Name     IN  BASE.Subset.View_Name%TYPE DEFAULT NULL
    -- Primary filter
    ,pnPrimary_Filter IN  BASE.Subset.Primary_Filter%TYPE DEFAULT NULL
    -- Secondary filter
    ,pnSecondary_Filter  IN  BASE.Subset.Secondary_Filter%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id            AS nId
        ,t.Name          AS sName
        ,t.Owner_Name    AS sOwner_Name
        ,t.View_Name     AS sView_Name
        ,t.Primary_Filter AS nPrimary_Filter
        ,t.Secondary_Filter  AS nSecondary_Filter
        ,t.Description   AS idDescription
        ,BASE.iDescription.GetText(t.Description) AS cDescription
      FROM BASE.Subset t
      WHERE (t.id            = pnId OR pnId IS NULL)
        AND (t.Name          = psName OR psName IS NULL)
        AND (t.Owner_Name    = psOwner_Name OR psOwner_Name IS NULL)
        AND (t.View_Name     = psView_Name OR psView_Name IS NULL)
        AND (t.Primary_Filter = pnPrimary_Filter OR pnPrimary_Filter IS NULL)
        AND (t.Secondary_Filter  = pnSecondary_Filter OR pnSecondary_Filter IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
  ****************************************************/

  -- Set instance of 'Class instance subset'
  PROCEDURE SetObj(
    -- Subset identifier
     pnId            IN  BASE.Subset.id%TYPE
    -- Subset name
    ,psName          IN  BASE.Subset.Name%TYPE
    -- Subset owner
    ,psOwner_Name    IN  BASE.Subset.Owner_Name%TYPE
    -- Subset view
    ,psView_Name     IN  BASE.Subset.View_Name%TYPE
    -- Primary filter
    ,pnPrimary_Filter IN  BASE.Subset.Primary_Filter%TYPE DEFAULT NULL
    -- Secondary filter
    ,pnSecondary_Filter  IN  BASE.Subset.Secondary_Filter%TYPE DEFAULT NULL
    -- Description
    ,psDescription   IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.Subset t
    SET
       t.Name          = psName
      ,t.Owner_Name    = psOwner_Name
      ,t.View_Name     = psView_Name
      ,t.Primary_Filter = pnPrimary_Filter
      ,t.Secondary_Filter  = pnSecondary_Filter
      ,t.Description   = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'Class instance subset' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Subset%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.Subset t
    SET
       t.Name          = pxObj.Name
      ,t.Owner_Name    = pxObj.Owner_Name
      ,t.View_Name     = pxObj.View_Name
      ,t.Primary_Filter = pxObj.Primary_Filter
      ,t.Secondary_Filter  = pxObj.Secondary_Filter
      ,t.Description   = pxObj.Description
    WHERE t.id = pxObj.id
    ;
  END SetObj;

  -- Set a value of property 'Subset name'
  PROCEDURE SetName(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Subset name
    ,psName          IN BASE.Subset.Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Subset t
    SET t.Name = psName
    WHERE t.id = pnId
    ;
  END SetName;

  -- Set a value of property 'Subset owner'
  PROCEDURE SetOwner_Name(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Subset owner
    ,psOwner_Name    IN BASE.Subset.Owner_Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Subset t
    SET t.Owner_Name = psOwner_Name
    WHERE t.id = pnId
    ;
  END SetOwner_Name;

  -- Set a value of property 'Subset view'
  PROCEDURE SetView_Name(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Subset view
    ,psView_Name     IN BASE.Subset.View_Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Subset t
    SET t.View_Name = psView_Name
    WHERE t.id = pnId
    ;
  END SetView_Name;

  -- Set a value of property 'Primary filter'
  PROCEDURE SetPrimary_Filter(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Primary filter
    ,pnPrimary_Filter IN BASE.Subset.Primary_Filter%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Subset t
    SET t.Primary_Filter = pnPrimary_Filter
    WHERE t.id = pnId
    ;
  END SetPrimary_Filter;

  -- Set a value of property 'Secondary filter'
  PROCEDURE SetSecondary_Filter(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Secondary filter
    ,pnSecondary_Filter  IN BASE.Subset.Secondary_Filter%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Subset t
    SET t.Secondary_Filter = pnSecondary_Filter
    WHERE t.id = pnId
    ;
  END SetSecondary_Filter;

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Description
    ,psDescription   IN VARCHAR2
  ) IS
  BEGIN
    UPDATE BASE.Subset t
    SET t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetDescription;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return instance identifier of 'Class instance subset'
  -- using index 'SUBSET_U1'
  FUNCTION GetId1(
    -- Subset name
     psName          IN  BASE.Subset.Name%TYPE
  ) RETURN BASE.Subset.id%TYPE IS
    vnId           BASE.Subset.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM
     BASE.Subset t
    WHERE t.Name = psName
    ;
    RETURN (vnId);
  END GetId1;

  -- Return a class instance of 'Class instance subset'
  FUNCTION GetObj(
    -- Subset identifier
     pnId            IN  BASE.Subset.id%TYPE
  ) RETURN BASE.Subset%ROWTYPE IS
    vxRow BASE.Subset%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.Subset t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Subset name'
  FUNCTION GetName(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Subset.Name%TYPE IS
    -- Subset name
    vsName          BASE.Subset.Name%TYPE;
  BEGIN
    SELECT t.Name INTO vsName
    FROM
       BASE.Subset t
    WHERE t.id = pnId
    ;
    RETURN (vsName);
  END GetName;

  -- Return value of property 'Subset owner'
  FUNCTION GetOwner_Name(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Subset.Owner_Name%TYPE IS
    -- Subset owner
    vsOwner_Name    BASE.Subset.Owner_Name%TYPE;
  BEGIN
    SELECT t.Owner_Name INTO vsOwner_Name
    FROM
       BASE.Subset t
    WHERE t.id = pnId
    ;
    RETURN (vsOwner_Name);
  END GetOwner_Name;

  -- Return value of property 'Subset view'
  FUNCTION GetView_Name(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Subset.View_Name%TYPE IS
    -- Subset view
    vsView_Name     BASE.Subset.View_Name%TYPE;
  BEGIN
    SELECT t.View_Name INTO vsView_Name
    FROM
       BASE.Subset t
    WHERE t.id = pnId
    ;
    RETURN (vsView_Name);
  END GetView_Name;

  -- Return value of property 'Primary filter'
  FUNCTION GetPrimary_Filter(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Subset.Primary_Filter%TYPE IS
    -- Primary filter
    vnPrimary_Filter BASE.Subset.Primary_Filter%TYPE;
  BEGIN
    SELECT t.Primary_Filter INTO vnPrimary_Filter
    FROM
       BASE.Subset t
    WHERE t.id = pnId
    ;
    RETURN (vnPrimary_Filter);
  END GetPrimary_Filter;

  -- Return value of property 'Secondary filter'
  FUNCTION GetSecondary_Filter(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Subset.Secondary_Filter%TYPE IS
    -- Secondary filter
    vnSecondary_Filter  BASE.Subset.Secondary_Filter%TYPE;
  BEGIN
    SELECT t.Secondary_Filter INTO vnSecondary_Filter
    FROM
       BASE.Subset t
    WHERE t.id = pnId
    ;
    RETURN (vnSecondary_Filter);
  END GetSecondary_Filter;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description
    vsDescription   BASE.Description.Text%TYPE;
  BEGIN
    SELECT d.Text INTO vsDescription
    FROM
       BASE.Subset t
      ,BASE.Description d
    WHERE t.id = pnId
      AND t.Description = d.id(+)
    ;
    RETURN (vsDescription);
  END GetDescription;

  /*+GENERATOR(New getter)*/

END iSubset;
/
