CREATE OR REPLACE PACKAGE BODY iSolution IS

  -- Interface package for class 'Solution'

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
    ,psGUI           IN  BASE.Solution.GUI%TYPE
    -- Descriptions support
    ,psDescriptions   IN  BASE.Solution.Descriptions%TYPE
    -- Signatures support
    ,psSignature     IN  BASE.Solution.Signature%TYPE
    -- Extended data protection support
    ,psProtection    IN  BASE.Solution.Protection%TYPE
    -- Description
    ,psDescription   IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO BASE.Solution (
       id            -- Identifier
      ,idParent      -- Parent solution identifier
      ,Name          -- Solution name
      ,Schema        -- Solution owner
      ,Multilanguage -- Multilanguage support
      ,Help          -- Help support
      ,GUI           -- Graphic user interface support
      ,Descriptions   -- Descriptions support
      ,Signature     -- Signatures support
      ,Protection    -- Extended data protection support
      ,Description   -- Description
    ) VALUES (
       BASE.Solution_Id.NEXTVAL
      ,pnIdParent
      ,psName
      ,psSchema
      ,psMultilanguage
      ,psHelp
      ,psGUI
      ,psDescriptions
      ,psSignature
      ,psProtection
      ,BASE.iBASE.AddDescription(psDescription)
    ) RETURNING
       id
    INTO
       pnId
    ;
  END AddObj;

  -- Create a new instance of 'Solution' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.Solution%ROWTYPE
  ) IS
  BEGIN
    pxObj.id := BASE.iBASE.GetNewId('BASE', 'Solution');

    INSERT INTO BASE.Solution
    VALUES pxObj
    RETURNING
       id
    INTO
       pxObj.id
    ;
  END AddObj;

  -- Delete object of 'Solution'
  PROCEDURE DelObj(
    -- Identifier
     pnId            IN  BASE.Solution.id%TYPE
  ) IS
    vxRow BASE.Solution%ROWTYPE;
  BEGIN
    vxRow := BASE.iSolution.GetObj(pnId);
    BASE.iDescription.DelObj(vxRow.Description);

    DELETE
    FROM BASE.Solution t
    WHERE t.id = pnId
    ;
  END DelObj;

  -- Lock object of 'Solution' for editing
  PROCEDURE LockObj(
    -- Identifier
     pnId            IN  BASE.Solution.id%TYPE
  ) IS
    vnId BASE.Solution.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM BASE.Solution t
    WHERE t.id = pnId
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

  -- Return a set of instances 'Solution'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet           OUT BASE.iBASE.RefCursor
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
    ,psGUI           IN  BASE.Solution.GUI%TYPE DEFAULT NULL
    -- Descriptions support
    ,psDescriptions   IN  BASE.Solution.Descriptions%TYPE DEFAULT NULL
    -- Signatures support
    ,psSignature     IN  BASE.Solution.Signature%TYPE DEFAULT NULL
    -- Extended data protection support
    ,psProtection    IN  BASE.Solution.Protection%TYPE DEFAULT NULL
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.id            AS nId
        ,t.idParent      AS nidParent
        ,t.Name          AS sName
        ,t.Schema        AS sSchema
        ,t.Multilanguage AS sMultilanguage
        ,t.Help          AS sHelp
        ,t.GUI           AS sGUI
        ,t.Descriptions  AS sDescriptions
        ,t.Signature     AS sSignature
        ,t.Protection    AS sProtection
        ,t.Description   AS idDescription
        ,BASE.iDescription.GetText(t.Description) AS cDescription
      FROM BASE.Solution t
      WHERE (t.id            = pnId OR pnId IS NULL)
        AND (t.idParent      = pnIdParent OR pnIdParent IS NULL)
        AND (t.Name          = psName OR psName IS NULL)
        AND (t.Schema        = psSchema OR psSchema IS NULL)
        AND (t.Multilanguage = psMultilanguage OR psMultilanguage IS NULL)
        AND (t.Help          = psHelp OR psHelp IS NULL)
        AND (t.GUI           = psGUI OR psGUI IS NULL)
        AND (t.Descriptions  = psDescriptions OR psDescriptions IS NULL)
        AND (t.Signature     = psSignature OR psSignature IS NULL)
        AND (t.Protection    = psProtection OR psProtection IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
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
    ,psGUI           IN  BASE.Solution.GUI%TYPE
    -- Descriptions support
    ,psDescriptions  IN  BASE.Solution.Descriptions%TYPE
    -- Signatures support
    ,psSignature     IN  BASE.Solution.Signature%TYPE
    -- Extended data protection support
    ,psProtection    IN  BASE.Solution.Protection%TYPE
    -- Description
    ,psDescription   IN  VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET
       t.idParent      = pnIdParent
      ,t.Name          = psName
      ,t.Schema        = psSchema
      ,t.Multilanguage = psMultilanguage
      ,t.Help          = psHelp
      ,t.GUI           = psGUI
      ,t.Descriptions  = psDescriptions
      ,t.Signature     = psSignature
      ,t.Protection    = psProtection
      ,t.Description   = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetObj;

  -- Set instance of 'Solution' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.Solution%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET
       t.idParent      = pxObj.idParent
      ,t.Name          = pxObj.Name
      ,t.Schema        = pxObj.Schema
      ,t.Multilanguage = pxObj.Multilanguage
      ,t.Help          = pxObj.Help
      ,t.GUI           = pxObj.GUI
      ,t.Descriptions  = pxObj.Descriptions
      ,t.Signature     = pxObj.Signature
      ,t.Protection    = pxObj.Protection
      ,t.Description   = pxObj.Description
    WHERE t.id = pxObj.id
    ;
  END SetObj;

  -- Set a value of property 'Parent solution identifier'
  PROCEDURE SetIdParent(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Parent solution identifier
    ,pnIdParent      IN BASE.Solution.idParent%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET t.idParent = pnIdParent
    WHERE t.id = pnId
    ;
  END SetIdParent;

  -- Set a value of property 'Solution name'
  PROCEDURE SetName(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Solution name
    ,psName          IN BASE.Solution.Name%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET t.Name = psName
    WHERE t.id = pnId
    ;
  END SetName;

  -- Set a value of property 'Solution owner'
  PROCEDURE SetSchema(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Solution owner
    ,psSchema        IN BASE.Solution.Schema%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET t.Schema = psSchema
    WHERE t.id = pnId
    ;
  END SetSchema;

  -- Set a value of property 'Multilanguage support'
  PROCEDURE SetMultilanguage(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Multilanguage support
    ,psMultilanguage IN BASE.Solution.Multilanguage%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET t.Multilanguage = psMultilanguage
    WHERE t.id = pnId
    ;
  END SetMultilanguage;

  -- Set a value of property 'Help support'
  PROCEDURE SetHelp(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Help support
    ,psHelp          IN BASE.Solution.Help%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET t.Help = psHelp
    WHERE t.id = pnId
    ;
  END SetHelp;

  -- Set a value of property 'Graphic user interface support'
  PROCEDURE SetGUI(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Graphic user interface support
    ,psGUI           IN BASE.Solution.GUI%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET t.GUI = psGUI
    WHERE t.id = pnId
    ;
  END SetGUI;

  -- Set a value of property 'Descriptions support'
  PROCEDURE SetDescriptions(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Descriptions support
    ,psDescriptions   IN BASE.Solution.Descriptions%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET t.Descriptions = psDescriptions
    WHERE t.id = pnId
    ;
  END SetDescriptions;

  -- Set a value of property 'Signatures support'
  PROCEDURE SetSignature(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Signatures support
    ,psSignature     IN BASE.Solution.Signature%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET t.Signature = psSignature
    WHERE t.id = pnId
    ;
  END SetSignature;

  -- Set a value of property 'Extended data protection support'
  PROCEDURE SetProtection(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Extended data protection support
    ,psProtection    IN BASE.Solution.Protection%TYPE
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET t.Protection = psProtection
    WHERE t.id = pnId
    ;
  END SetProtection;

  -- Set a value of property 'Description'
  PROCEDURE SetDescription(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
    -- Description
    ,psDescription   IN VARCHAR2
  ) IS
  BEGIN
    UPDATE BASE.Solution t
    SET t.Description = BASE.iBASE.AddDescription(psDescription)
    WHERE t.id = pnId
    ;
  END SetDescription;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
  ****************************************************/

  -- Return instance identifier of 'Solution'
  -- using index 'Solution_U1'
  FUNCTION GetId1(
    -- Solution name
     psName          IN  BASE.Solution.Name%TYPE
  ) RETURN BASE.Solution.id%TYPE IS
    vnId           BASE.Solution.id%TYPE;
  BEGIN
    SELECT t.id INTO vnId
    FROM
     BASE.Solution t
    WHERE t.Name = psName
    ;
    RETURN (vnId);
  END GetId1;

  -- Return a class instance of 'Solution'
  FUNCTION GetObj(
    -- Identifier
     pnId            IN  BASE.Solution.id%TYPE
  ) RETURN BASE.Solution%ROWTYPE IS
    vxRow BASE.Solution%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.Solution t
    WHERE t.id = pnId
    ;
    RETURN (vxRow);
  END GetObj;

  -- Return value of property 'Parent solution identifier'
  FUNCTION GetIdParent(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.idParent%TYPE IS
    -- Parent solution identifier
    vnIdParent      BASE.Solution.idParent%TYPE;
  BEGIN
    SELECT t.idParent INTO vnIdParent
    FROM
       BASE.Solution t
    WHERE t.id = pnId
    ;
    RETURN (vnIdParent);
  END GetIdParent;

  -- Return value of property 'Solution name'
  FUNCTION GetName(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Name%TYPE IS
    -- Solution name
    vsName          BASE.Solution.Name%TYPE;
  BEGIN
    SELECT t.Name INTO vsName
    FROM
       BASE.Solution t
    WHERE t.id = pnId
    ;
    RETURN (vsName);
  END GetName;

  -- Return value of property 'Solution owner'
  FUNCTION GetSchema(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Schema%TYPE IS
    -- Solution owner
    vsSchema        BASE.Solution.Schema%TYPE;
  BEGIN
    SELECT t.Schema INTO vsSchema
    FROM
       BASE.Solution t
    WHERE t.id = pnId
    ;
    RETURN (vsSchema);
  END GetSchema;

  -- Return value of property 'Multilanguage support'
  FUNCTION GetMultilanguage(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Multilanguage%TYPE IS
    -- Multilanguage support
    vsMultilanguage BASE.Solution.Multilanguage%TYPE;
  BEGIN
    SELECT t.Multilanguage INTO vsMultilanguage
    FROM
       BASE.Solution t
    WHERE t.id = pnId
    ;
    RETURN (vsMultilanguage);
  END GetMultilanguage;

  -- Return value of property 'Help support'
  FUNCTION GetHelp(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Help%TYPE IS
    -- Help support
    vsHelp          BASE.Solution.Help%TYPE;
  BEGIN
    SELECT t.Help INTO vsHelp
    FROM
       BASE.Solution t
    WHERE t.id = pnId
    ;
    RETURN (vsHelp);
  END GetHelp;

  -- Return value of property 'Graphic user interface support'
  FUNCTION GetGUI(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.GUI%TYPE IS
    -- Graphic user interface support
    vsGUI           BASE.Solution.GUI%TYPE;
  BEGIN
    SELECT t.GUI INTO vsGUI
    FROM
       BASE.Solution t
    WHERE t.id = pnId
    ;
    RETURN (vsGUI);
  END GetGUI;

  -- Return value of property 'Descriptions support'
  FUNCTION GetDescriptions(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Descriptions%TYPE IS
    -- Descriptions support
    vsDescriptions   BASE.Solution.Descriptions%TYPE;
  BEGIN
    SELECT t.Descriptions INTO vsDescriptions
    FROM
       BASE.Solution t
    WHERE t.id = pnId
    ;
    RETURN (vsDescriptions);
  END GetDescriptions;

  -- Return value of property 'Signatures support'
  FUNCTION GetSignature(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Signature%TYPE IS
    -- Signatures support
    vsSignature     BASE.Solution.Signature%TYPE;
  BEGIN
    SELECT t.Signature INTO vsSignature
    FROM
       BASE.Solution t
    WHERE t.id = pnId
    ;
    RETURN (vsSignature);
  END GetSignature;

  -- Return value of property 'Extended data protection support'
  FUNCTION GetProtection(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Solution.Protection%TYPE IS
    -- Extended data protection support
    vsProtection    BASE.Solution.Protection%TYPE;
  BEGIN
    SELECT t.Protection INTO vsProtection
    FROM
       BASE.Solution t
    WHERE t.id = pnId
    ;
    RETURN (vsProtection);
  END GetProtection;

  -- Return value of property 'Description'
  FUNCTION GetDescription(
    -- Identifier
     pnId            IN BASE.Solution.id%TYPE
  ) RETURN BASE.Description.Text%TYPE IS
    -- Description
    vsDescription   BASE.Description.Text%TYPE;
  BEGIN
    SELECT d.Text INTO vsDescription
    FROM
       BASE.Solution t
      ,BASE.Description d
    WHERE t.id = pnId
      AND t.Description = d.id(+)
    ;
    RETURN (vsDescription);
  END GetDescription;

  /*+GENERATOR(New getter)*/

END iSolution;
/
