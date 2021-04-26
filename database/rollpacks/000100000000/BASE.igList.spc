CREATE OR REPLACE PACKAGE igList IS

  -- Interface package for class 'List of objects'

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
  );

  -- Create a new instance of 'List of objects' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.gList%ROWTYPE
  );

  -- Delete object of 'List of objects'
  PROCEDURE DelObj(
    -- List identifier
     pnId          IN  BASE.gList.id%TYPE
  );

  -- Lock object of 'List of objects' for editing
  PROCEDURE LockObj(
    -- List identifier
     pnId          IN  BASE.gList.id%TYPE
  );

  -- Return a set of instances 'List of objects'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBase.RefCursor
    -- List identifier
    ,pnId          IN  BASE.gList.id%TYPE DEFAULT NULL
    -- Parent list identifier
    ,pnIdParent    IN  BASE.gList.idParent%TYPE DEFAULT NULL
    -- List name
    ,psName        IN  BASE.gList.Name%TYPE DEFAULT NULL
  );

  /****************************************************
  ***                   Setters                     ***
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
  );

  -- Set instance of 'List of objects' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.gList%ROWTYPE
  );

  -- Set a value of property 'Parent list identifier'
  PROCEDURE SetIdParent(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
    -- Parent list identifier
    ,pnIdParent    IN BASE.gList.idParent%TYPE
  );

  -- Set a value of property 'List name'
  PROCEDURE SetName(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
    -- List name
    ,psName        IN BASE.gList.Name%TYPE
  );

  -- Set a value of property 'Description identifier'
  PROCEDURE SetDescription(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
    -- Description identifier
    ,psDescription IN VARCHAR2
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return list identifier of 'List of objects'
  -- using index 'LIST_U1'
  FUNCTION GetId1(
    -- List name
     psName        IN  BASE.gList.Name%TYPE
  ) RETURN BASE.gList.id%TYPE;

  -- Return a class instance of 'List of objects'
  FUNCTION GetObj(
    -- List identifier
     pnId          IN  BASE.gList.id%TYPE
  ) RETURN BASE.gList%ROWTYPE;

  -- Return value of property 'Parent list identifier'
  FUNCTION GetIdparent(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
  ) RETURN BASE.gList.idParent%TYPE;

  -- Return value of property 'List name'
  FUNCTION GetName(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
  ) RETURN BASE.gList.Name%TYPE;

  -- Return value of property 'Description identifier'
  FUNCTION GetDescription(
    -- List identifier
     pnId          IN BASE.gList.id%TYPE
  ) RETURN BASE.Description.Text%TYPE;

END igList;
/
