CREATE OR REPLACE PACKAGE iSolution IS

  -- Interface package for class 'Solution'

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

  -- Create a new instance of 'Solution'
  PROCEDURE AddObj(
    -- Identifier
     pnId            OUT BASE.Solution.id%TYPE
    -- Parent solution identifier
    ,pnIdParent      IN  BASE.Solution.idParent%TYPE DEFAULT NULL
    -- Solution name
    ,psName          IN  BASE.Solution.Name%TYPE
    -- Solution owner
    ,psSchema        IN  BASE.Solution.Schema%TYPE
    -- Multilanguage support
    ,psMultilanguage IN  BASE.Solution.Multilanguage%TYPE
    -- Help support
    ,psHelp          IN  BASE.Solution.Help%TYPE
    -- Graphic user interface support
    ,psGui           IN  BASE.Solution.Gui%TYPE
    -- Descriptions support
    ,psDescriptions   IN  BASE.Solution.Descriptions%TYPE
    -- Signatures support
    ,psSignature     IN  BASE.Solution.Signature%TYPE
    -- Extended data protection support
    ,psProtection    IN  BASE.Solution.Protection%TYPE
    -- Description
    ,psDescription   IN  VARCHAR2 DEFAULT NULL
  );

  -- Create a new instance of 'Solution' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Solution%ROWTYPE
  );

  -- Delete object of 'Solution'
  PROCEDURE DelObj(
    -- Identifier
     pnId            IN  BASE.Solution.id%TYPE
  );

  -- Lock object of 'Solution' for editing
  PROCEDURE LockObj(
    -- Identifier
     pnId            IN  BASE.Solution.id%TYPE
  );

  -- Return a set of instances 'Solution'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet           OUT BASE.iBase.RefCursor
    -- Identifier
    ,pnId            IN  BASE.Solution.id%TYPE DEFAULT NULL
    -- Parent solution identifier
    ,pnIdParent      IN  BASE.Solution.idParent%TYPE DEFAULT NULL
    -- Solution name
    ,psName          IN  BASE.Solution.Name%TYPE DEFAULT NULL
    -- Solution owner
    ,psSchema        IN  BASE.Solution.Schema%TYPE DEFAULT NULL
    -- Multilanguage support
    ,psMultilanguage IN  BASE.Solution.Multilanguage%TYPE DEFAULT NULL
    -- Help support
    ,psHelp          IN  BASE.Solution.Help%TYPE DEFAULT NULL
    -- Graphic user interface support
    ,psGui           IN  BASE.Solution.Gui%TYPE DEFAULT NULL
    -- Descriptions support
    ,psDescriptions   IN  BASE.Solution.Descriptions%TYPE DEFAULT NULL
    -- Signatures support
    ,psSignature     IN  BASE.Solution.Signature%TYPE DEFAULT NULL
    -- Extended data protection support
    ,psProtection    IN  BASE.Solution.Protection%TYPE DEFAULT NULL
  );

  /****************************************************
  ***                   Setters                     ***
  ****************************************************/

  -- Set instance of 'Solution'
  PROCEDURE SetObj(
    -- Identifier
     pnId            IN  BASE.Solution.id%TYPE
    -- Parent solution identifier
    ,pnIdParent      IN  BASE.Solution.idParent%TYPE DEFAULT NULL
    -- Solution name
    ,psName          IN  BASE.Solution.Name%TYPE
    -- Solution owner
    ,psSchema        IN  BASE.Solution.Schema%TYPE
    -- Multilanguage support
    ,psMultilanguage IN  BASE.Solution.Multilanguage%TYPE
    -- Help support
    ,psHelp          IN  BASE.Solution.Help%TYPE
    -- Graphic user interface support
    ,psGui           IN  BASE.Solution.Gui%TYPE
    -- Descriptions support
    ,psDescriptions   IN  BASE.Solution.Descriptions%TYPE
    -- Signatures support
    ,psSignature     IN  BASE.Solution.Signature%TYPE
    -- Extended data protection support
    ,psProtection    IN  BASE.Solution.Protection%TYPE
    -- Description
    ,psDescription   IN  VARCHAR2 DEFAULT NULL
  );

  -- Set instance of 'Solution' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Solution%ROWTYPE
  );

  -- Set a value of property 'Parent solution identifier'
  PROCEDURE SetIdParent(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Parent solution identifier
    ,pnIdParent      IN BASE.Solution.idParent%TYPE
  );

  -- Set a value of property 'Solution name'
  PROCEDURE SetName(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Solution name
    ,psName          IN BASE.Solution.Name%TYPE
  );

  -- Set a value of property 'Solution owner'
  PROCEDURE SetSchema(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Solution owner
    ,psSchema        IN BASE.Solution.Schema%TYPE
  );

  -- Set a value of property 'Multilanguage support'
  PROCEDURE SetMultilanguage(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Multilanguage support
    ,psMultilanguage IN BASE.Solution.Multilanguage%TYPE
  );

  -- Set a value of property 'Help support'
  PROCEDURE SetHelp(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Help support
    ,psHelp          IN BASE.Solution.Help%TYPE
  );

  -- Set a value of property 'Graphic user interface support'
  PROCEDURE SetGui(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Graphic user interface support
    ,psGui           IN BASE.Solution.Gui%TYPE
  );

  -- Set a value of property 'Descriptions support'
  PROCEDURE SetDescriptions(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Descriptions support
    ,psDescriptions   IN BASE.Solution.Descriptions%TYPE
  );

  -- Set a value of property 'Signatures support'
  PROCEDURE SetSignature(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Signatures support
    ,psSignature     IN BASE.Solution.Signature%TYPE
  );

  -- Set a value of property 'Extended data protection support'
  PROCEDURE SetProtection(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Extended data protection support
    ,psProtection    IN BASE.Solution.Protection%TYPE
  );

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Description
    ,psDescription   IN VARCHAR2
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return instance identifier of 'Solution'
  -- using index 'Solution_U1'
  FUNCTION GetId1(
    -- Solution name
     psName          IN  BASE.Solution.Name%TYPE
  ) RETURN BASE.Solution.id%TYPE;

  -- Return a class instance of 'Solution'
  FUNCTION GetObj(
    -- Identifier
     pnId            IN  BASE.Solution.id%TYPE
  ) RETURN BASE.Solution%ROWTYPE;

  -- Return value of property 'Parent solution identifier'
  FUNCTION GetIdParent(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.idParent%TYPE;

  -- Return value of property 'Solution name'
  FUNCTION GetName(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Name%TYPE;

  -- Return value of property 'Solution owner'
  FUNCTION GetSchema(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Schema%TYPE;

  -- Return value of property 'Multilanguage support'
  FUNCTION GetMultilanguage(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Multilanguage%TYPE;

  -- Return value of property 'Help support'
  FUNCTION GetHelp(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Help%TYPE;

  -- Return value of property 'Graphic user interface support'
  FUNCTION GetGui(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Gui%TYPE;

  -- Return value of property 'Descriptions support'
  FUNCTION GetDescriptions(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Descriptions%TYPE;

  -- Return value of property 'Signatures support'
  FUNCTION GetSignature(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Signature%TYPE;

  -- Return value of property 'Extended data protection support'
  FUNCTION GetProtection(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Protection%TYPE;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Description.Text%TYPE;

END iSolution;
/
