CREATE OR REPLACE PACKAGE iPrimary_Filter IS

  -- Interface package for class 'Primary filter'

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
  ***           Functions and procedures            ***
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
  );

  -- Create a new instance of 'Primary filter' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Primary_Filter%ROWTYPE
  );

  -- Delete object of 'Primary filter'
  PROCEDURE DelObj(
    -- Identifier
     pnId          IN  BASE.Primary_Filter.id%TYPE
  );

  -- Lock object of 'Primary filter' for editing
  PROCEDURE LockObj(
    -- Identifier
     pnId          IN  BASE.Primary_Filter.id%TYPE
  );

  -- Return a set of instances 'Primary filter'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBase.RefCursor
    -- Identifier
    ,pnId          IN  BASE.Primary_Filter.id%TYPE DEFAULT NULL
    -- Parent filter identifier
    ,pnIdParent    IN  BASE.Primary_Filter.idParent%TYPE DEFAULT NULL
    -- Filter name
    ,psName        IN  BASE.Primary_Filter.Name%TYPE DEFAULT NULL
  );

  /****************************************************
  ***                   Setters                     ***
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
  );

  -- Set instance of 'Primary filter' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Primary_Filter%ROWTYPE
  );

  -- Set a value of property 'Parent filter identifier'
  PROCEDURE SetIdParent(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
    -- Parent filter identifier
    ,pnIdParent    IN BASE.Primary_Filter.idParent%TYPE
  );

  -- Set a value of property 'Filter name'
  PROCEDURE SetName(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
    -- Filter name
    ,psName        IN BASE.Primary_Filter.Name%TYPE
  );

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
    -- Description
    ,psDescription IN VARCHAR2
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return instance identifier of 'Primary filter'
  -- using index 'PRIMARY_FILTER_U1'
  FUNCTION GetId1(
    -- Filter name
     psName        IN  BASE.Primary_Filter.Name%TYPE
  ) RETURN BASE.Primary_Filter.id%TYPE;

  -- Return a class instance of 'Primary filter'
  FUNCTION GetObj(
    -- Identifier
     pnId          IN  BASE.Primary_Filter.id%TYPE
  ) RETURN BASE.Primary_Filter%ROWTYPE;

  -- Return value of property 'Parent filter identifier'
  FUNCTION GetIdParent(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
  ) RETURN BASE.Primary_Filter.idParent%TYPE;

  -- Return value of property 'Filter name'
  FUNCTION GetName(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
  ) RETURN BASE.Primary_Filter.Name%TYPE;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Identifier
     pnId          IN BASE.Primary_Filter.id%TYPE
  ) RETURN BASE.Description.Text%TYPE;

END iPrimary_Filter;
/
