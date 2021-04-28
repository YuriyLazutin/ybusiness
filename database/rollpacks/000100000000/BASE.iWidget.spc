CREATE OR REPLACE PACKAGE iWidget IS

  -- Interface package for class 'Widget'

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

  -- Create a new instance of 'Widget'
  PROCEDURE AddObj(
    -- Widget identifier
     pnId          OUT BASE.Widget.id%TYPE
    -- Parent widget identifier
    ,pnIdParent    IN  BASE.Widget.idParent%TYPE DEFAULT NULL
    -- Widget name
    ,psName        IN  BASE.Widget.Name%TYPE
    -- Description
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  );

  -- Create a new instance of 'Widget' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Widget%ROWTYPE
  );

  -- Delete object of 'Widget'
  PROCEDURE DelObj(
    -- Widget identifier
     pnId          IN  BASE.Widget.id%TYPE
  );

  -- Lock object of 'Widget' for editing
  PROCEDURE LockObj(
    -- Widget identifier
     pnId          IN  BASE.Widget.id%TYPE
  );

  -- Return a set of instances 'Widget'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBase.RefCursor
    -- Widget identifier
    ,pnId          IN  BASE.Widget.id%TYPE DEFAULT NULL
    -- Parent widget identifier
    ,pnIdParent    IN  BASE.Widget.idParent%TYPE DEFAULT NULL
    -- Widget name
    ,psName        IN  BASE.Widget.Name%TYPE DEFAULT NULL
  );

  /****************************************************
  ***                   Setters                     ***
  ****************************************************/

  -- Set instance of 'Widget'
  PROCEDURE SetObj(
    -- Widget identifier
     pnId          IN  BASE.Widget.id%TYPE
    -- Parent widget identifier
    ,pnIdParent    IN  BASE.Widget.idParent%TYPE DEFAULT NULL
    -- Widget name
    ,psName        IN  BASE.Widget.Name%TYPE
    -- Description
    ,psDescription IN  VARCHAR2 DEFAULT NULL
  );

  -- Set instance of 'Widget' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Widget%ROWTYPE
  );

  -- Set a value of property 'Parent widget identifier'
  PROCEDURE SetIdParent(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
    -- Parent widget identifier
    ,pnIdParent    IN BASE.Widget.idParent%TYPE
  );

  -- Set a value of property 'Widget name'
  PROCEDURE SetName(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
    -- Widget name
    ,psName        IN BASE.Widget.Name%TYPE
  );

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
    -- Description
    ,psDescription IN VARCHAR2
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return instance identifier of 'Widget'
  -- using index 'WIDGET_U1'
  FUNCTION GetId1(
    -- Widget name
     psName        IN  BASE.Widget.Name%TYPE
  ) RETURN BASE.Widget.id%TYPE;

  -- Return a class instance of 'Widget'
  FUNCTION GetObj(
    -- Widget identifier
     pnId          IN  BASE.Widget.id%TYPE
  ) RETURN BASE.Widget%ROWTYPE;

  -- Return value of property 'Parent widget identifier'
  FUNCTION GetIdParent(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
  ) RETURN BASE.Widget.idParent%TYPE;

  -- Return value of property 'Widget name'
  FUNCTION GetName(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
  ) RETURN BASE.Widget.Name%TYPE;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Widget identifier
     pnId          IN BASE.Widget.id%TYPE
  ) RETURN BASE.Description.Text%TYPE;

END iWidget;
/
