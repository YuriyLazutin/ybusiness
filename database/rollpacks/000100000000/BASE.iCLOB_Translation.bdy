CREATE OR REPLACE PACKAGE BODY iCLOB_Translation IS

  -- Interface package for class 'Translations for CLOB fields in BASE schema'

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
  ) IS
  BEGIN
    INSERT INTO BASE.CLOB_Translation (
       Language -- Language identifier
      ,Value    -- Translation itself
      ,Class    -- Class identifier
      ,Object   -- Object identifier
      ,Property -- Object property
    ) VALUES (
       pnLanguage
      ,psValue
      ,pnClass
      ,pnObject
      ,pnProperty
    );
  END AddObj;

  -- Create a new instance of 'Translations for CLOB fields in BASE schema.' using ROWTYPE
  PROCEDURE AddObj(
    pxObj IN OUT NOCOPY BASE.CLOB_Translation%ROWTYPE
  ) IS
  BEGIN
    INSERT INTO BASE.CLOB_Translation
    VALUES pxObj;
  END AddObj;

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
  ) IS
  BEGIN
    DELETE
    FROM BASE.CLOB_Translation t
    WHERE t.language = pnLanguage
       AND t.class = pnClass
       AND t.object = pnObject
       AND t.property = pnProperty
    ;
  END DelObj;

  -- Lock object of 'Translations for CLOB fields in BASE schema' for editing
  PROCEDURE LockObj(
    -- Language identifier
     pnLanguage IN  BASE.CLOB_Translation.Language%TYPE
    -- Class identifier
    ,pnClass    IN  BASE.CLOB_Translation.Class%TYPE
    -- Object identifier
    ,pnObject   IN  BASE.CLOB_Translation.Object%TYPE
    -- Object property
    ,pnProperty IN  BASE.CLOB_Translation.Property%TYPE
  ) IS
    vnLock NUMBER;
  BEGIN
    SELECT 1 INTO vnLock
    FROM BASE.CLOB_Translation t
    WHERE t.language = pnLanguage
       AND t.class = pnClass
       AND t.object = pnObject
       AND t.property = pnProperty
    FOR UPDATE NOWAIT;
  EXCEPTION
    WHEN TIMEOUT_ON_RESOURCE
      THEN raise_application_error(-20000, 'Error! Object already locked by another user.');
  END LockObj;

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
  ) IS
  BEGIN
    OPEN pcSet FOR
      SELECT
         t.Language AS nLanguage
        ,t.Value    AS sValue
        ,t.Class    AS nClass
        ,t.Object   AS nObject
        ,t.Property AS nProperty
      FROM BASE.CLOB_Translation t
      WHERE (t.Language = pnLanguage OR pnLanguage IS NULL)
        AND (t.Class    = pnClass OR pnClass IS NULL)
        AND (t.Object   = pnObject OR pnObject IS NULL)
        AND (t.Property = pnProperty OR pnProperty IS NULL)
    ;
  END GetSet;

  /****************************************************
  ***                     Setters                   ***
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
  ) IS
  BEGIN
    UPDATE BASE.CLOB_Translation t
    SET
       t.Value    = psValue
    WHERE t.language = pnLanguage
       AND t.class = pnClass
       AND t.object = pnObject
       AND t.property = pnProperty
    ;
  END SetObj;

  -- Set instance of 'Translations for CLOB fields in BASE schema' using ROWTYPE
  PROCEDURE SetObj(
    pxObj IN OUT NOCOPY BASE.CLOB_Translation%ROWTYPE
  ) IS
  BEGIN
    UPDATE BASE.CLOB_Translation t
    SET
       t.Value    = pxObj.Value
    WHERE t.Language = pxObj.Language
      AND t.Class    = pxObj.Class
      AND t.Object   = pxObj.Object
      AND t.Property = pxObj.Property
    ;
  END SetObj;

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
  ) IS
  BEGIN
    UPDATE BASE.CLOB_Translation t
    SET t.Value = psValue
    WHERE t.language = pnLanguage
       AND t.class = pnClass
       AND t.object = pnObject
       AND t.property = pnProperty
    ;
  END SetValue;

  /*+GENERATOR(New setter)*/

  /****************************************************
  ***                     Getters                   ***
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
  ) RETURN BASE.CLOB_Translation%ROWTYPE IS
    vxRow BASE.CLOB_Translation%ROWTYPE;
  BEGIN
    SELECT * INTO vxRow
    FROM BASE.CLOB_Translation t
    WHERE t.language = pnLanguage
       AND t.class = pnClass
       AND t.object = pnObject
       AND t.property = pnProperty
    ;
    RETURN (vxRow);
  END GetObj;

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
  ) RETURN BASE.CLOB_Translation.Value%TYPE IS
    -- Translation itself
    vsValue    BASE.CLOB_Translation.Value%TYPE;
  BEGIN
    SELECT t.Value INTO vsValue
    FROM
       BASE.CLOB_Translation t
    WHERE t.language = pnLanguage
       AND t.class = pnClass
       AND t.object = pnObject
       AND t.property = pnProperty
    ;
    RETURN (vsValue);
  END GetValue;

  /*+GENERATOR(New getter)*/

END iCLOB_Translation;
/
