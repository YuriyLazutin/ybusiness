CREATE OR REPLACE PACKAGE iProperty IS

  -- Interface package for class 'Class property'

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
  );

  -- Create a new instance of 'Class property' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Property%ROWTYPE
  );

  -- Delete object of 'Class property'
  PROCEDURE DelObj(
    -- Property identifier
     pnId          IN  BASE.Property.id%TYPE
  );

  -- Lock object of 'Class property' for editing
  PROCEDURE LockObj(
    -- Property identifier
     pnId          IN  BASE.Property.id%TYPE
  );

  -- Return a set of instances 'Class property'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet         OUT BASE.iBase.RefCursor
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
  );

  /****************************************************
  ***                   Setters                     ***
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
  );

  -- Set instance of 'Class property' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Property%ROWTYPE
  );

  -- Set a value of property 'Property name'
  PROCEDURE SetName(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Property name
    ,psName        IN BASE.Property.Name%TYPE
  );

  -- Set a value of property 'Property type'
  PROCEDURE SetType(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Property type
    ,pnType        IN BASE.Property.Type%TYPE
  );

  -- Set a value of property 'Owner class'
  PROCEDURE SetClass(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Owner class
    ,pnClass       IN BASE.Property.Class%TYPE
  );

  -- Set a value of property 'Referencing table column'
  PROCEDURE SetRefColumn(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Referencing table column
    ,psRefColumn   IN BASE.Property.RefColumn%TYPE
  );

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Description
    ,psDescription IN VARCHAR2
  );

  -- Set a value of property 'Widget'
  PROCEDURE SetWidget(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
    -- Widget
    ,pnWidget       IN BASE.Property.Widget%TYPE
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return instance identifier of 'Class property'
  -- using index 'PROPERTY_U1'
  FUNCTION GetId1(
    -- Owner class
     pnClass       IN  BASE.Property.Class%TYPE
    -- Property name
    ,psName        IN  BASE.Property.Name%TYPE
  ) RETURN BASE.Property.id%TYPE;

  -- Return a class instance of 'Class property'
  FUNCTION GetObj(
    -- Property identifier
     pnId          IN  BASE.Property.id%TYPE
  ) RETURN BASE.Property%ROWTYPE;

  -- Return value of property 'Property name'
  FUNCTION GetName(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Property.Name%TYPE;

  -- Return value of property 'Property type'
  FUNCTION GetType(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Property.Type%TYPE;

  -- Return value of property 'Owner class'
  FUNCTION GetClass(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Property.Class%TYPE;

  -- Return value of property 'Referencing table column'
  FUNCTION GetRefColumn(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Property.RefColumn%TYPE;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Description.Text%TYPE;

  -- Return value of property 'Widget'
  FUNCTION GetWidget(
    -- Property identifier
     pnId          IN BASE.Property.id%TYPE
  ) RETURN BASE.Property.Widget%TYPE;

END iProperty;
/
