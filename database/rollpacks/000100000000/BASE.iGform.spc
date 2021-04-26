CREATE OR REPLACE PACKAGE igForm IS

  -- Interface package for class 'Form'

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

  -- Create a new instance of 'Form'
  PROCEDURE AddObj(
    -- Form identifier
     pnId          OUT BASE.gForm.id%TYPE
    -- Parent form identifier
    ,pnIdParent    IN  BASE.gForm.IdParent%TYPE DEFAULT NULL
    -- Form name
    ,psName        IN  BASE.gForm.Name%TYPE
    -- Description identifier
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  );

  -- Create a new instance of 'Form' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.gForm%ROWTYPE
  );

  -- Delete object of 'Form'
  PROCEDURE DelObj(
    -- Form identifier
     pnId          IN  BASE.gForm.id%TYPE
  );

  -- Lock object of 'Form' for editing
  PROCEDURE LockObj(
    -- Form identifier
     pnId          IN  BASE.gForm.id%TYPE
  );

  -- Return a set of instances 'Form'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBase.RefCursor
    -- Form identifier
    ,pnId          IN  BASE.gForm.id%TYPE DEFAULT NULL
    -- Parent form identifier
    ,pnIdParent    IN  BASE.gForm.IdParent%TYPE DEFAULT NULL
    -- Form name
    ,psName        IN  BASE.gForm.Name%TYPE DEFAULT NULL
  );

  /****************************************************
  ***                   Setters                     ***
  ****************************************************/

  -- Set instance of 'Form'
  PROCEDURE SetObj(
    -- Form identifier
     pnId          IN  BASE.gForm.id%TYPE
    -- Parent form identifier
    ,pnIdParent    IN  BASE.gForm.IdParent%TYPE DEFAULT NULL
    -- Form name
    ,psName        IN  BASE.gForm.Name%TYPE
    -- Description identifier
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  );

  -- Set instance of 'Form' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.gForm%ROWTYPE
  );

  -- Set a value of property 'Parent form identifier'
  PROCEDURE SetIdParent(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
    -- Parent form identifier
    ,pnIdParent    IN BASE.gForm.IdParent%TYPE
  );

  -- Set a value of property 'Form name'
  PROCEDURE SetName(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
    -- Form name
    ,psName        IN BASE.gForm.Name%TYPE
  );

  -- Set a value of property 'Description identifier'
  PROCEDURE SetDescription(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
    -- Description identifier
    ,psDescription IN VARCHAR2
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return form identifier of 'Form'
  -- using index 'GFORM_U1'
  FUNCTION GetId1(
    -- Form name
     psName        IN  BASE.gForm.Name%TYPE
  ) RETURN BASE.gForm.id%TYPE;

  -- Return a class instance of 'Form'
  FUNCTION GetObj(
    -- Form identifier
     pnId          IN  BASE.gForm.id%TYPE
  ) RETURN BASE.gForm%ROWTYPE;

  -- Return value of property 'Parent form identifier'
  FUNCTION GetIdParent(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
  ) RETURN BASE.gForm.IdParent%TYPE;

  -- Return value of property 'Form name'
  FUNCTION GetName(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
  ) RETURN BASE.gForm.Name%TYPE;

  -- Return value of property 'Description identifier'
  FUNCTION GetDescription(
    -- Form identifier
     pnId          IN BASE.gForm.id%TYPE
  ) RETURN BASE.Description.Text%TYPE;

END igForm;
/
