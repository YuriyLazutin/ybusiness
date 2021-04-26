CREATE OR REPLACE PACKAGE igTree IS

  -- Interface package for class 'Tree of objects'

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
  );

  -- Create a new instance of 'Tree of objects' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.gTree%ROWTYPE
  );

  -- Delete object of 'Tree of objects'
  PROCEDURE DelObj(
    -- Tree identifier
     pnId          IN  BASE.gTree.id%TYPE
  );

  -- Lock object of 'Tree of objects' for editing
  PROCEDURE LockObj(
    -- Tree identifier
     pnId          IN  BASE.gTree.id%TYPE
  );

  -- Return a set of instances 'Tree of objects'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBase.RefCursor
    -- Tree identifier
    ,pnId          IN  BASE.gTree.id%TYPE DEFAULT NULL
    -- Parent tree identifier
    ,pnIdParent    IN  BASE.gTree.idParent%TYPE DEFAULT NULL
    -- Tree name
    ,psName        IN  BASE.gTree.Name%TYPE DEFAULT NULL
  );

  /****************************************************
  ***                   Setters                     ***
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
  );

  -- Set instance of 'Tree of objects' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.gTree%ROWTYPE
  );

  -- Set a value of property 'Parent tree identifier'
  PROCEDURE SetIdParent(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
    -- Parent tree identifier
    ,pnIdParent    IN BASE.gTree.idParent%TYPE
  );

  -- Set a value of property 'Tree name'
  PROCEDURE SetName(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
    -- Tree name
    ,psName        IN BASE.gTree.Name%TYPE
  );

  -- Set a value of property 'Description identifier'
  PROCEDURE SetDescription(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
    -- Description identifier
    ,psDescription IN VARCHAR2
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return tree identifier of 'Tree of objects'
  -- using index 'GTREE_U1'
  FUNCTION GetId1(
    -- Tree name
     psName        IN  BASE.gTree.Name%TYPE
  ) RETURN BASE.gTree.id%TYPE;

  -- Return a class instance of 'Tree of objects'
  FUNCTION GetObj(
    -- Tree identifier
     pnId          IN  BASE.gTree.id%TYPE
  ) RETURN BASE.gTree%ROWTYPE;

  -- Return value of property 'Parent tree identifier'
  FUNCTION GetIdParent(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
  ) RETURN BASE.gTree.idParent%TYPE;

  -- Return value of property 'Tree name'
  FUNCTION GetName(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
  ) RETURN BASE.gTree.Name%TYPE;

  -- Return value of property 'Description identifier'
  FUNCTION GetDescription(
    -- Tree identifier
     pnId          IN BASE.gTree.id%TYPE
  ) RETURN BASE.Description.Text%TYPE;

END igTree;
/
