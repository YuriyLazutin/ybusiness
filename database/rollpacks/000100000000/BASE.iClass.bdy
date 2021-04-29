CREATE OR REPLACE PACKAGE BODY iClass IS

  -- Interface package for class 'Business object'

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

  -- Create a new instance of 'Business object'
  PROCEDURE AddObj(
    -- Class identifier
     pnId               OUT BASE.Class.id%TYPE
    -- Class name
    ,psName             IN  BASE.Class.Name%TYPE
    -- Schema name
    ,psOwner_Name        IN  BASE.Class.Owner_Name%TYPE DEFAULT NULL
    -- Table name
    ,psTable_Name        IN  BASE.Class.Table_Name%TYPE DEFAULT NULL
    -- Interface package
    ,psInterface        IN  BASE.Class.Interface%TYPE DEFAULT NULL
    -- Description
    ,psDescription      IN  VARCHAR2 DEFAULT NULL
    -- Form for object editing
    ,pngForm            IN  BASE.Class.gForm%TYPE DEFAULT NULL
    -- List for object editing
    ,pngList            IN  BASE.Class.gList%TYPE DEFAULT NULL
    -- Tree for object editing
    ,pngTree            IN  BASE.Class.gTree%TYPE DEFAULT NULL
    -- Primary filter
    ,pnPrimary_Filter   IN  BASE.Class.Primary_Filter%TYPE DEFAULT NULL
    -- Secondary filter
    ,pnSecondary_Filter IN  BASE.Class.Secondary_Filter%TYPE DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.Class (
       id               -- Class identifier
      ,Name             -- Class name
      ,Owner_Name       -- Schema name
      ,Table_Name       -- Table name
      ,Interface        -- Interface package
      ,Description      -- Description
      ,gForm            -- Form for object editing
      ,gList            -- List for object editing
      ,gTree            -- Tree for object editing
      ,Primary_Filter   -- Primary filter
      ,Secondary_Filter -- Secondary filter
    ) VALUES (
       BASE.Class_Id.NEXTVAL
      ,psName
      ,UPPER(psOwner_Name)
      ,UPPER(psTable_Name)
      ,psInterface
      ,BASE.iBASE.AddDescription(psDescription)
      ,pngForm
      ,pngList
      ,pngTree
      ,pnPrimary_Filter
      ,pnSecondary_Filter
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'Business object' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Class%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'Class');

    INSERT INTO BASE.Class
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.id
    ;
  END AddObj;

  -- Delete object of 'Business object'
  PROCEDURE DelObj(
    -- Class identifier
     pnId               IN  BASE.Class.id%TYPE
  ) IS
    vxRow BASE.Class%ROWTYPE;
  BEGIN
    vxRow := BASE.iClass.GetObj(pnId);
    BASE.iDescription.DelObj(vxRow.Description);

    DELETE
    FROM BASE.Class t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'Business object' for editing
  PROCEDURE LockObj(
    -- Class identifier
     pnId               IN  BASE.Class.id%TYPE
  ) IS
    vnId BASE.Class.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.Class t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'Business object'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet              OUT BASE.iBASE.RefCursor
    -- Class identifier
    ,pnId               IN  BASE.Class.id%TYPE DEFAULT NULL
    -- Class name
    ,psName             IN  BASE.Class.Name%TYPE DEFAULT NULL
    -- Schema name
    ,psOwner_Name        IN  BASE.Class.Owner_Name%TYPE DEFAULT NULL
    -- Table name
    ,psTable_Name        IN  BASE.Class.Table_Name%TYPE DEFAULT NULL
    -- Interface package
    ,psInterface        IN  BASE.Class.Interface%TYPE DEFAULT NULL
    -- Form for object editing
    ,pngForm            IN  BASE.Class.gForm%TYPE DEFAULT NULL
    -- List for object editing
    ,pngList            IN  BASE.Class.gList%TYPE DEFAULT NULL
    -- Tree for object editing
    ,pngTree            IN  BASE.Class.gTree%TYPE DEFAULT NULL
    -- Primary filter
    ,pnPrimary_Filter   IN  BASE.Class.Primary_Filter%TYPE DEFAULT NULL
    -- Secondary filter
    ,pnSecondary_Filter IN  BASE.Class.Secondary_Filter%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id               AS nId
        ,t.Name             AS sName
        ,t.Owner_Name       AS sOwner_Name
        ,t.Table_Name       AS sTable_Name
        ,t.Interface        AS sInterface
        ,t.Description      AS idDescription
        ,BASE.iDescription.GetText(t.Description) AS cDescription
        ,t.gForm            AS ngForm
        ,t.gList            AS ngList
        ,t.gTree            AS ngTree
        ,t.Primary_Filter   AS nPrimary_Filter
        ,t.Secondary_Filter AS nSecondary_Filter
      FROM BASE.Class t
      WHERE (t.id               = pnId OR pnId IS NULL)
        AND (t.Name             = psName OR psName IS NULL)
        AND (t.Owner_Name        = psOwner_Name OR psOwner_Name IS NULL)
        AND (t.Table_Name        = psTable_Name OR psTable_Name IS NULL)
        AND (t.Interface        = psInterface OR psInterface IS NULL)
        AND (t.gForm            = pngForm OR pngForm IS NULL)
        AND (t.gList            = pngList OR pngList IS NULL)
        AND (t.gTree            = pngTree OR pngTree IS NULL)
        AND (t.Primary_Filter   = pnPrimary_Filter OR pnPrimary_Filter IS NULL)
        AND (t.Secondary_Filter = pnSecondary_Filter OR pnSecondary_Filter IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
  ****************************************************/

  -- Set instance of 'Business object'
  PROCEDURE SetObj(
    -- Class identifier
     pnId               IN  BASE.Class.id%TYPE
    -- Class name
    ,psName             IN  BASE.Class.Name%TYPE
    -- Schema name
    ,psOwner_Name        IN  BASE.Class.Owner_Name%TYPE DEFAULT NULL
    -- Table name
    ,psTable_Name        IN  BASE.Class.Table_Name%TYPE DEFAULT NULL
    -- Interface package
    ,psInterface        IN  BASE.Class.Interface%TYPE DEFAULT NULL
    -- Description
    ,psDescription      IN  VARCHAR2 DEFAULT NULL
    -- Form for object editing
    ,pngForm            IN  BASE.Class.gForm%TYPE DEFAULT NULL
    -- List for object editing
    ,pngList            IN  BASE.Class.gList%TYPE DEFAULT NULL
    -- Tree for object editing
    ,pngTree            IN  BASE.Class.gTree%TYPE DEFAULT NULL
    -- Primary filter
    ,pnPrimary_Filter   IN  BASE.Class.Primary_Filter%TYPE DEFAULT NULL
    -- Secondary filter
    ,pnSecondary_Filter IN  BASE.Class.Secondary_Filter%TYPE DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET
       t.Name             = psName
      ,t.Owner_Name       = psOwner_Name
      ,t.Table_Name       = psTable_Name
      ,t.Interface        = psInterface
      ,t.Description      = BASE.iBASE.AddDescription(psDescription)
      ,t.gForm            = pngForm
      ,t.gList            = pngList
      ,t.gTree            = pngTree
      ,t.Primary_Filter   = pnPrimary_Filter
      ,t.Secondary_Filter = pnSecondary_Filter
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'Business object' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Class%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET
       t.Name             = pxObj.Name
      ,t.Owner_Name       = pxObj.Owner_Name
      ,t.Table_Name       = pxObj.Table_Name
      ,t.Interface        = pxObj.Interface
      ,t.Description      = pxObj.Description
      ,t.gForm            = pxObj.gForm
      ,t.gList            = pxObj.gList
      ,t.gTree            = pxObj.gTree
      ,t.Primary_Filter   = pxObj.Primary_Filter
      ,t.Secondary_Filter = pxObj.Secondary_Filter
    WHERE t.id = pxObj.id
    ;
  END SetObj;

  -- Set a value of property 'Class name'
  PROCEDURE SetName(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Class name
    ,psName             IN BASE.Class.Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET t.Name = psName
    WHERE t.id = pnId
    ;
  END SetName;

  -- Set a value of property 'Schema name'
  PROCEDURE SetOwner_Name(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Schema name
    ,psOwner_Name        IN BASE.Class.Owner_Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET t.Owner_Name = psOwner_Name
    WHERE t.id = pnId
    ;
  END SetOwner_Name;

  -- Set a value of property 'Table name'
  PROCEDURE SetTable_Name(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Table name
    ,psTable_Name        IN BASE.Class.Table_Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET t.Table_Name = psTable_Name
    WHERE t.id = pnId
    ;
  END SetTable_Name;

  -- Set a value of property 'Interface package'
  PROCEDURE SetInterface(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Interface package
    ,psInterface        IN BASE.Class.Interface%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET t.Interface = psInterface
    WHERE t.id = pnId
    ;
  END SetInterface;

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Description
    ,psDescription      IN VARCHAR2
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetDescription;

  -- Set a value of property 'Form for object editing'
  PROCEDURE SetgForm(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Form for object editing
    ,pngForm            IN BASE.Class.gForm%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET t.gForm = pngForm
    WHERE t.id = pnId
    ;
  END SetgForm;

  -- Set a value of property 'List for object editing'
  PROCEDURE SetgList(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- List for object editing
    ,pngList            IN BASE.Class.gList%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET t.gList = pngList
    WHERE t.id = pnId
    ;
  END SetgList;

  -- Set a value of property 'Tree for object editing'
  PROCEDURE SetgTree(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Tree for object editing
    ,pngTree            IN BASE.Class.gTree%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET t.gTree = pngTree
    WHERE t.id = pnId
    ;
  END SetgTree;

  -- Set a value of property 'Primary filter'
  PROCEDURE SetPrimary_Filter(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Primary filter
    ,pnPrimary_Filter   IN BASE.Class.Primary_Filter%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET t.Primary_Filter = pnPrimary_Filter
    WHERE t.id = pnId
    ;
  END SetPrimary_Filter;

  -- Set a value of property 'Secondary filter'
  PROCEDURE SetSecondary_Filter(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Secondary filter
    ,pnSecondary_Filter IN BASE.Class.Secondary_Filter%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Class t
    SET t.Secondary_Filter = pnSecondary_Filter
    WHERE t.id = pnId
    ;
  END SetSecondary_Filter;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return class identifier of 'Business object'
  -- using index 'CLASS_U1'.
  FUNCTION GetId1(
    -- Class name
     psName             IN  BASE.Class.Name%TYPE
  ) RETURN BASE.Class.id%TYPE IS
    vnId              BASE.Class.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM
     BASE.Class t
    WHERE t.Name = psName
    ;
    RETURN (vnId);
  END GetId1;

  -- Return a class instance of 'Business object'
  FUNCTION GetObj(
    -- Class identifier
     pnId               IN  BASE.Class.id%TYPE
  ) RETURN BASE.Class%ROWTYPE IS
    vxRow BASE.Class%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.Class t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Class name'
  FUNCTION GetName(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Name%TYPE IS
    -- Class name
    vsName             BASE.Class.Name%TYPE;
  BEGIN
    SELECT t.Name INTO vsName
    FROM
       BASE.Class t
    WHERE t.id = pnId
    ;
    RETURN (vsName);
  END GetName;

  -- Return value of property 'Schema name'
  FUNCTION GetOwner_Name(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Owner_Name%TYPE IS
    -- Schema name
    vsOwner_Name        BASE.Class.Owner_Name%TYPE;
  BEGIN
    SELECT t.Owner_Name INTO vsOwner_Name
    FROM
       BASE.Class t
    WHERE t.id = pnId
    ;
    RETURN (vsOwner_Name);
  END GetOwner_Name;

  -- Return value of property 'Table name'
  FUNCTION GetTable_Name(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Table_Name%TYPE IS
    -- Table name
    vsTable_Name        BASE.Class.Table_Name%TYPE;
  BEGIN
    SELECT t.Table_Name INTO vsTable_Name
    FROM
       BASE.Class t
    WHERE t.id = pnId
    ;
    RETURN (vsTable_Name);
  END GetTable_Name;

  -- Return value of property 'Interface package'
  FUNCTION GetInterface(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Interface%TYPE IS
    -- Interface package
    vsInterface        BASE.Class.Interface%TYPE;
  BEGIN
    SELECT t.Interface INTO vsInterface
    FROM
       BASE.Class t
    WHERE t.id = pnId
    ;
    RETURN (vsInterface);
  END GetInterface;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description
    vsDescription      BASE.Description.Text%TYPE;
  BEGIN
    SELECT d.Text INTO vsDescription
    FROM
       BASE.Class t
      ,BASE.Description d
    WHERE t.id = pnId
      AND t.Description = d.id(+)
    ;
    RETURN (vsDescription);
  END GetDescription;

  -- Return value of property 'Form for object editing'.
  FUNCTION GetgForm(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.gForm%TYPE IS
    -- Form for object editing
    vngForm            BASE.Class.gForm%TYPE;
  BEGIN
    SELECT t.gForm INTO vngForm
    FROM
       BASE.Class t
    WHERE t.id = pnId
    ;
    RETURN (vngForm);
  END GetgForm;

  -- Return value of property 'List for object editing'
  FUNCTION GetgList(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.gList%TYPE IS
    -- List for object editing
    vngList            BASE.Class.gList%TYPE;
  BEGIN
    SELECT t.gList INTO vngList
    FROM
       BASE.Class t
    WHERE t.id = pnId
    ;
    RETURN (vngList);
  END GetgList;

  -- Return value of property 'Tree for object editing'
  FUNCTION GetgTree(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.gTree%TYPE IS
    -- Tree for object editing
    vngTree            BASE.Class.gTree%TYPE;
  BEGIN
    SELECT t.gTree INTO vngTree
    FROM
       BASE.Class t
    WHERE t.id = pnId
    ;
    RETURN (vngTree);
  END GetgTree;

  -- Return value of property 'Primary filter'
  FUNCTION GetPrimary_Filter(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Primary_Filter%TYPE IS
    -- Primary filter
    vnPrimary_Filter   BASE.Class.Primary_Filter%TYPE;
  BEGIN
    SELECT t.Primary_Filter INTO vnPrimary_Filter
    FROM
       BASE.Class t
    WHERE t.id = pnId
    ;
    RETURN (vnPrimary_Filter);
  END GetPrimary_Filter;

  -- Return value of property 'Secondary filter'
  FUNCTION GetSecondary_Filter(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Secondary_Filter%TYPE IS
    -- Secondary filter
    vnSecondary_Filter BASE.Class.Secondary_Filter%TYPE;
  BEGIN
    SELECT t.Secondary_Filter INTO vnSecondary_Filter
    FROM
       BASE.Class t
    WHERE t.id = pnId
    ;
    RETURN (vnSecondary_Filter);
  END GetSecondary_Filter;

  /*+GENERATOR(New getter)*/

END iClass;
/
