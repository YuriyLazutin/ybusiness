CREATE OR REPLACE PACKAGE iSubset IS

  -- Interface package for class 'Class instance subset'

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
  );

  -- Create a new instance of 'Class instance subset' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Subset%ROWTYPE
  );

  -- Delete object of 'Class instance subset'
  PROCEDURE DelObj(
    -- Subset identifier
     pnId            IN  BASE.Subset.id%TYPE
  );

  -- Lock object of 'Class instance subset' for editing
  PROCEDURE LockObj(
    -- Subset identifier
     pnId            IN  BASE.Subset.id%TYPE
  );

  -- Return a set of instances 'Class instance subset'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet           OUT BASE.iBase.RefCursor
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
  );

  /****************************************************
  ***                   Setters                     ***
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
  );

  -- Set instance of 'Class instance subset' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Subset%ROWTYPE
  );

  -- Set a value of property 'Subset name'
  PROCEDURE SetName(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Subset name
    ,psName          IN BASE.Subset.Name%TYPE
  );

  -- Set a value of property 'Subset owner'
  PROCEDURE SetOwner_Name(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Subset owner
    ,psOwner_Name    IN BASE.Subset.Owner_Name%TYPE
  );

  -- Set a value of property 'Subset view'
  PROCEDURE SetView_Name(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Subset view
    ,psView_Name     IN BASE.Subset.View_Name%TYPE
  );

  -- Set a value of property 'Primary filter'
  PROCEDURE SetPrimary_Filter(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Primary filter
    ,pnPrimary_Filter IN BASE.Subset.Primary_Filter%TYPE
  );

  -- Set a value of property 'Secondary filter'
  PROCEDURE SetSecondary_Filter(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Secondary filter
    ,pnSecondary_Filter  IN BASE.Subset.Secondary_Filter%TYPE
  );

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
    -- Description
    ,psDescription   IN VARCHAR2
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return instance identifier of 'Class instance subset'
  -- using index 'SUBSET_U1'
  FUNCTION GetId1(
    -- Subset name
     psName          IN  BASE.Subset.Name%TYPE
  ) RETURN BASE.Subset.id%TYPE;

  -- Return a class instance of 'Class instance subset'
  FUNCTION GetObj(
    -- Subset identifier
     pnId            IN  BASE.Subset.id%TYPE
  ) RETURN BASE.Subset%ROWTYPE;

  -- Return value of property 'Subset name'
  FUNCTION GetName(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Subset.Name%TYPE;

  -- Return value of property 'Subset owner'
  FUNCTION GetOwner_Name(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Subset.Owner_Name%TYPE;

  -- Return value of property 'Subset view'
  FUNCTION GetView_Name(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Subset.View_Name%TYPE;

  -- Return value of property 'Primary filter'
  FUNCTION GetPrimary_Filter(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Subset.Primary_Filter%TYPE;

  -- Return value of property 'Secondary filter'
  FUNCTION GetSecondary_Filter(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Subset.Secondary_Filter%TYPE;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Subset identifier
     pnId            IN BASE.Subset.id%TYPE
  ) RETURN BASE.Description.Text%TYPE;

END iSubset;
/
