CREATE OR REPLACE PACKAGE iClass IS

  -- Interface package for class 'Business object'

  /****************************************************
  ***                     Types                     ***
  ****************************************************/

  /****************************************************
  ***                   Constants                   ***
  ****************************************************/

  /****************************************************
  ***                  Variables                    ***
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
  );

  -- Create new object of 'Business object' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Class%ROWTYPE
  );

  -- Delete object of 'Business object'
  PROCEDURE DelObj(
    -- Class identifier
     pnId               IN  BASE.Class.id%TYPE
  );

  -- Lock object of 'Business object' for editing
  PROCEDURE LockObj(
    -- Class identifier
     pnId               IN  BASE.Class.id%TYPE
  );

  -- Return a set of 'Business object' objects
  PROCEDURE GetSet(
    -- Result cursor
     pcSet              OUT BASE.iBase.RefCursor
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
  );

  /****************************************************
  ***                   Setters                     ***
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
  );

  -- Set instance of 'Business object' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Class%ROWTYPE
  );

  -- Set a value of property 'Class name'
  PROCEDURE SetName(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Class name
    ,psName             IN BASE.Class.Name%TYPE
  );

  -- Set a value of property 'Schema name'
  PROCEDURE SetOwner_Name(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Schema name
    ,psOwner_Name        IN BASE.Class.Owner_Name%TYPE
  );

  -- Set a value of property 'Table name'
  PROCEDURE SetTable_Name(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Table name
    ,psTable_Name        IN BASE.Class.Table_Name%TYPE
  );

  -- Set a value of property 'Interface package'
  PROCEDURE SetInterface(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Interface package
    ,psInterface        IN BASE.Class.Interface%TYPE
  );

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Description
    ,psDescription      IN VARCHAR2
  );

  -- Set a value of property 'Form for object editing'
  PROCEDURE SetgForm(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Form for object editing
    ,pngForm            IN BASE.Class.gForm%TYPE
  );

  -- Set a value of property 'List for object editing'
  PROCEDURE SetgList(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- List for object editing
    ,pngList            IN BASE.Class.gList%TYPE
  );

  -- Set a value of property 'Tree for object editing'
  PROCEDURE SetgTree(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Tree for object editing
    ,pngTree            IN BASE.Class.gTree%TYPE
  );

  -- Set a value of property 'Primary filter'
  PROCEDURE SetPrimary_Filter(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Primary filter
    ,pnPrimary_Filter   IN BASE.Class.Primary_Filter%TYPE
  );

  -- Set a value of property 'Secondary filter'
  PROCEDURE SetSecondary_Filter(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
    -- Secondary filter
    ,pnSecondary_Filter IN BASE.Class.Secondary_Filter%TYPE
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return class identifier of 'Business object'
  -- using index 'CLASS_U1'.
  FUNCTION GetId1(
    -- Class name
     psName             IN  BASE.Class.Name%TYPE
  ) RETURN BASE.Class.id%TYPE;

  -- Return a class instance of 'Business object'
  FUNCTION GetObj(
    -- Class identifier
     pnId               IN  BASE.Class.id%TYPE
  ) RETURN BASE.Class%ROWTYPE;

  -- Return value of property 'Class name'
  FUNCTION GetName(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Name%TYPE;

  -- Return value of property 'Schema name'
  FUNCTION GetOwner_Name(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Owner_Name%TYPE;

  -- Return value of property 'Table name'
  FUNCTION GetTable_Name(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Table_Name%TYPE;

  -- Return value of property 'Interface package'
  FUNCTION GetInterface(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Interface%TYPE;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Description.Text%TYPE;

  -- Return value of property 'Form for object editing'
  FUNCTION GetgForm(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.gForm%TYPE;

  -- Return value of property 'List for object editing'
  FUNCTION GetgList(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.gList%TYPE;

  -- Return value of property 'Tree for object editing'
  FUNCTION GetgTree(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.gTree%TYPE;

  -- Return value of property 'Primary filter'
  FUNCTION GetPrimary_Filter(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Primary_Filter%TYPE;

  -- Return value of property 'Secondary filter'
  FUNCTION GetSecondary_Filter(
    -- Class identifier
     pnId               IN BASE.Class.id%TYPE
  ) RETURN BASE.Class.Secondary_Filter%TYPE;

END iClass;
/
