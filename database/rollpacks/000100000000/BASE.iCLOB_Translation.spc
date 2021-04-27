CREATE OR REPLACE PACKAGE iCLOB_Translation IS

  -- Interface package for class 'Translations for CLOB fields in BASE schema'

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

  -- Create a new instance of 'Translations for CLOB fields in BASE schema'
  PROCEDURE AddObj(
    -- Language identifier
     pnLanguage IN  BASE.CLOB_Translation.Language%TYPE
    -- Translation itself
    ,psValue    IN  BASE.CLOB_Translation.Value%TYPE
    -- Class identifier
    ,pnClass    IN  BASE.CLOB_Translation.Class%TYPE
    -- Object identifier
    ,pnObject   IN  BASE.CLOB_Translation.Object%TYPE
    -- Object property
    ,pnProperty IN  BASE.CLOB_Translation.Property%TYPE
  );

  -- Create a new instance of 'Translations for CLOB fields in BASE schema' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.CLOB_Translation%ROWTYPE
  );

  -- Delete object of 'Translations for CLOB fields in BASE schema'
  PROCEDURE DelObj(
    -- Language identifier
     pnLanguage IN  BASE.CLOB_Translation.Language%TYPE
    -- Class identifier
    ,pnClass    IN  BASE.CLOB_Translation.Class%TYPE
    -- Object identifier
    ,pnObject   IN  BASE.CLOB_Translation.Object%TYPE
    -- Object property
    ,pnProperty IN  BASE.CLOB_Translation.Property%TYPE
  );

  -- Lock object of 'Translations for CLOB fields in BASE schema.' for editing
  PROCEDURE LockObj(
    -- Language identifier
     pnLanguage IN  BASE.CLOB_Translation.Language%TYPE
    -- Class identifier
    ,pnClass    IN  BASE.CLOB_Translation.Class%TYPE
    -- Object identifier
    ,pnObject   IN  BASE.CLOB_Translation.Object%TYPE
    -- Object property
    ,pnProperty IN  BASE.CLOB_Translation.Property%TYPE
  );

  -- Return a set of instances 'Translations for CLOB fields in BASE schema'
  PROCEDURE GetSet(
    -- Result cursor
     pcSet      OUT BASE.iBase.RefCursor
    -- Language identifier
    ,pnLanguage IN  BASE.CLOB_Translation.Language%TYPE DEFAULT NULL
    -- Class identifier
    ,pnClass    IN  BASE.CLOB_Translation.Class%TYPE DEFAULT NULL
    -- Object identifier
    ,pnObject   IN  BASE.CLOB_Translation.Object%TYPE DEFAULT NULL
    -- Object property
    ,pnProperty IN  BASE.CLOB_Translation.Property%TYPE DEFAULT NULL
  );

  /****************************************************
  ***                   Setters                     ***
  ****************************************************/

  -- Set instance of 'Translations for CLOB fields in BASE schema'
  PROCEDURE SetObj(
    -- Language identifier
     pnLanguage IN  BASE.CLOB_Translation.Language%TYPE
    -- Translation itself
    ,psValue    IN  BASE.CLOB_Translation.Value%TYPE
    -- Class identifier
    ,pnClass    IN  BASE.CLOB_Translation.Class%TYPE
    -- Object identifier
    ,pnObject   IN  BASE.CLOB_Translation.Object%TYPE
    -- Object property
    ,pnProperty IN  BASE.CLOB_Translation.Property%TYPE
  );

  -- Set instance of 'Translations for CLOB fields in BASE schema' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.CLOB_Translation%ROWTYPE
  );

  -- Set a value of property 'Translation itself'
  PROCEDURE SetValue(
    -- Language identifier
     pnLanguage IN  BASE.CLOB_Translation.Language%TYPE
    -- Class identifier
    ,pnClass    IN  BASE.CLOB_Translation.Class%TYPE
    -- Object identifier
    ,pnObject   IN  BASE.CLOB_Translation.Object%TYPE
    -- Object property
    ,pnProperty IN  BASE.CLOB_Translation.Property%TYPE
    -- Translation itself
    ,psValue    IN BASE.CLOB_Translation.Value%TYPE
  );

  /****************************************************
  ***                   Getters                     ***
  ****************************************************/

  -- Return a class instance of 'Translations for CLOB fields in BASE schema'
  FUNCTION GetObj(
    -- Language identifier
     pnLanguage IN  BASE.CLOB_Translation.Language%TYPE
    -- Class identifier
    ,pnClass    IN  BASE.CLOB_Translation.Class%TYPE
    -- Object identifier
    ,pnObject   IN  BASE.CLOB_Translation.Object%TYPE
    -- Object property
    ,pnProperty IN  BASE.CLOB_Translation.Property%TYPE
  ) RETURN BASE.CLOB_Translation%ROWTYPE;

  -- Return value of property 'Translation itself'
  FUNCTION GetValue(
    -- Language identifier
     pnLanguage IN  BASE.CLOB_Translation.Language%TYPE
    -- Class identifier
    ,pnClass    IN  BASE.CLOB_Translation.Class%TYPE
    -- Object identifier
    ,pnObject   IN  BASE.CLOB_Translation.Object%TYPE
    -- Object property
    ,pnProperty IN  BASE.CLOB_Translation.Property%TYPE
  ) RETURN BASE.CLOB_Translation.Value%TYPE;

END iCLOB_Translation;
/
