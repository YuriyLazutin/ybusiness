CREATE OR REPLACE PACKAGE BODY Generators IS

  PROCEDURE AddClass(
     psClassName        IN  VARCHAR2
    ,psOwner            IN  VARCHAR2
    ,psTableName        IN  VARCHAR2
    ,psInterfacePackage IN  VARCHAR2 DEFAULT NULL
    ,psDescription      IN  VARCHAR2 DEFAULT NULL
    ,pbPackageMode      IN  BOOLEAN  DEFAULT FALSE
  ) IS
    vcPackage CLOB;
  BEGIN
    BASE.iBase.AssertGrantes(
       psOwner     => psOwner
      ,psTableName => psTableName
    );

    BASE.iBase.RegisterClass(
       psClassName        => psClassName
      ,psOwner            => psOwner
      ,psTable            => psTableName
      ,psInterfacePackage => psInterfacePackage
      ,psDescription      => psDescription
    );

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vTableParamSet := AnalyzeTable(psOwner, psTableName);
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
    END IF;

    DEV.Generators.Create_Class_Sequence(
       psOwner            => psOwner
      ,psTableName        => psTableName
      ,pbPackageMode      => TRUE
    );

    vcPackage := DEV.Generators.Create_Interface_Specification(
       psOwner       => psOwner
      ,psTableName   => psTableName
      ,psPackageName => psInterfacePackage
      ,pbPackageMode => TRUE
    );
    EXECUTE IMMEDIATE TO_CHAR(vcPackage);

    vcPackage := DEV.Generators.Create_Interface_Realization(
       psOwner       => psOwner
      ,psTableName   => psTableName
      ,psPackageName => psInterfacePackage
      ,pbPackageMode => TRUE
    );
    EXECUTE IMMEDIATE TO_CHAR(vcPackage);

  END AddClass;

  FUNCTION  AnalyzeColumn(
     psOwner      IN VARCHAR2
    ,psTableName  IN VARCHAR2
    ,psColumnName IN VARCHAR2
  ) RETURN ColumnParamSet IS
    tResult ColumnParamSet;
  BEGIN
    tResult.FullColumnName := vTableParamSet.FullTableName || '.' || UPPER(psColumnName);
    tResult.ColumnComment  := Get_ColumnComment(psOwner, psTableName, psColumnName);
    tResult.DataType       := Get_ColumnDataType(psOwner, psTableName, psColumnName);
    tResult.PropertyId     := Get_Property_Id(vTableParamSet.Class.Id, psColumnName);
    tResult.PropertyName   := BASE.iProperty.GetName(tResult.PropertyId);

    RETURN (tResult);
  END AnalyzeColumn;

  FUNCTION  AnalyzeTable(
     psOwner     IN VARCHAR2
    ,psTableName IN VARCHAR2
  ) RETURN TableParamSet IS
    tResult TableParamSet;
  BEGIN
    tResult.FullTableName    := Get_FullTableName(psOwner, psTableName);
    IF (psOwner IS NOT NULL) THEN
      tResult.Owner := UPPER(psOwner);
    ELSE
      tResult.Owner := Get_TableOwner(psTableName);
    END IF;
    tResult.TableComment     := Get_TableComment(psOwner, psTableName);
    tResult.Col_Cnt          := Get_Column_Count(psOwner, psTableName);
    tResult.PK_Cnt           := Get_Constraint_Count(psOwner, psTableName, NULL, 'P');
    tResult.UK_Cnt           := Get_Constraint_Count(psOwner, psTableName, NULL, 'U');
    tResult.CHK_Cnt          := Get_Constraint_Count(psOwner, psTableName, NULL, 'C');
    tResult.IX_Cnt           := Get_Index_Count(psOwner, psTableName);
    tResult.UIX_Cnt          := Get_Index_Count(psOwner, psTableName, NULL, NULL, 'UNIQUE');
    tResult.MaxColNameLength := Get_MaxColNameLength(psOwner, psTableName);
    tResult.DescriptionFlag  := Get_DescriptionFlag(psOwner, psTableName);
    tResult.Class            := Get_Class(psOwner, psTableName);
    RETURN (tResult);
  END AnalyzeTable;

  PROCEDURE IncDisplacement IS
  BEGIN
    vs_Displacement := vs_Displacement || '  ';
  END IncDisplacement;

  PROCEDURE DecDisplacement IS
  BEGIN
    vs_Displacement := SUBSTR(vs_Displacement, 1, LENGTH(vs_Displacement) - 2);
  END DecDisplacement;

  FUNCTION Create_Interface_Package(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psPackageName IN VARCHAR2 DEFAULT NULL
  ) RETURN CLOB IS
    vsResult         CLOB;
  BEGIN
    vSolutionParamSet := Get_SolutionParamSet(psOwner);
    vTableParamSet    := AnalyzeTable(psOwner, psTableName);

    vsResult := vsResult || Create_Interface_Specification(vTableParamSet.Owner, psTableName, psPackageName, TRUE);
    vsResult := vsResult || '/' || chr(10);
    vsResult := vsResult || Create_Interface_Realization(vTableParamSet.Owner, psTableName, psPackageName, TRUE);
    vsResult := vsResult || '/' || chr(10);

    RETURN (vsResult);
  END Create_Interface_Package;

  FUNCTION Create_Interface_Specification(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psPackageName IN VARCHAR2 DEFAULT NULL
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS
    vsResult         CLOB;
  BEGIN
    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
    END IF;

    vTableParamSet.Class.Interface := COALESCE(psPackageName, vTableParamSet.Class.Interface, 'i' || INITCAP(psTableName));

    vsResult := 'CREATE OR REPLACE PACKAGE ';
    IF (UPPER(psOwner) = 'DEV') THEN
      vsResult := vsResult || vTableParamSet.Class.Interface || ' IS' || chr(10);
    ELSE 
      vsResult := vsResult || UPPER(psOwner) || '.' || vTableParamSet.Class.Interface || ' IS' || chr(10);
    END IF;

    vsResult := vsResult || chr(10);
    IncDisplacement;
    vsResult := vsResult || vs_Displacement ||
    '-- Autor         : YBusiness Generator' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '-- Create date   : ' || TO_CHAR(SYSDATE, 'DD.MM.YYYY HH24:MI:SS') || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '-- Purpose    : Interface for class ''' || vTableParamSet.Class.Name || '''' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***                     Types                      ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***                   Constants                   ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***                  Variables                   ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***             Functions and procedures               ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || Create_AddRow_Spc(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || Create_DelRow_Spc(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || Create_LockRow_Spc(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || Create_GetSet_Spc(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***                   Setters                     ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || Create_SetRow_Spc(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    FOR i IN AllTabColumns(psOwner, psTableName) LOOP
      IF (i.column_name NOT IN ('ID')) THEN
        vsResult := vsResult || Create_Setter_Spc(psOwner, psTableName, i.column_name, TRUE);
        vsResult := vsResult || chr(10);
      END IF;
    END LOOP;
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***                   Getters                     ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    FOR i IN AllConstraints(vTableParamSet.Owner, psTableName, 'U') LOOP
      vsResult := vsResult || Create_Ind_Getter_Spc(psOwner, psTableName, i.index_name, TRUE);
      vsResult := vsResult || chr(10);
    END LOOP;

    vsResult := vsResult || Create_GetRow_Spc(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    FOR i IN AllTabColumns(psOwner, psTableName) LOOP
      IF (i.column_name NOT IN ('ID')) THEN
        vsResult := vsResult || Create_Getter_Spc(psOwner, psTableName, i.column_name, TRUE);
        vsResult := vsResult || chr(10);
      END IF;
    END LOOP;

    DecDisplacement;
    vsResult := vsResult || 'END ' || vTableParamSet.Class.Interface || ';' || chr(10);
    RETURN (vsResult);
  END Create_Interface_Specification;

  FUNCTION Create_Interface_Realization(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psPackageName IN VARCHAR2 DEFAULT NULL
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS
    vsResult         CLOB;
  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vTableParamSet.Class.Interface := COALESCE(psPackageName, vTableParamSet.Class.Interface, 'i' || INITCAP(psTableName));

    vsResult := 'CREATE OR REPLACE PACKAGE BODY ';
    IF (UPPER(psOwner) = 'DEV') THEN
      vsResult := vsResult || vTableParamSet.Class.Interface || ' IS' || chr(10);
    ELSE 
      vsResult := vsResult || UPPER(psOwner) || '.' || vTableParamSet.Class.Interface || ' IS' || chr(10);
    END IF;
    vsResult := vsResult || chr(10);
    IncDisplacement;
    vsResult := vsResult || vs_Displacement ||
    '-- Autor         : YBusiness Generator' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '-- Create date   : ' || TO_CHAR(SYSDATE, 'DD.MM.YYYY HH24:MI:SS') || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '-- Purpose    : Inteface for class ''' || vTableParamSet.Class.Name || '''.' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***                     Types                      ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***                   Constants                   ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***                   Variables                  ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***               Functions and procedures             ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || Create_AddRow(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || Create_DelRow(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || Create_LockRow(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || Create_GetSet(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***                     Setters                   ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || Create_SetRow(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    FOR i IN AllTabColumns(psOwner, psTableName) LOOP
      IF (i.column_name NOT IN ('ID')) THEN
        vsResult := vsResult || Create_Setter(psOwner, psTableName, i.column_name, TRUE);
        vsResult := vsResult || chr(10);
      END IF;
    END LOOP;
    vsResult := vsResult || vs_Displacement || '/*+GENERATOR(New setter)*/' || chr(10);
    vsResult := vsResult || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '/****************************************************' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '***                     Getters                   ***' || chr(10);
    vsResult := vsResult || vs_Displacement ||
    '****************************************************/' || chr(10);
    vsResult := vsResult || chr(10);
    FOR i IN AllConstraints(vTableParamSet.Owner, psTableName, 'U') LOOP
      vsResult := vsResult || Create_Ind_Getter(psOwner, psTableName, i.index_name, TRUE);
      vsResult := vsResult || chr(10);
    END LOOP;

    vsResult := vsResult || Create_GetRow(psOwner, psTableName, TRUE);
    vsResult := vsResult || chr(10);
    FOR i IN AllTabColumns(psOwner, psTableName) LOOP
      IF (i.column_name NOT IN ('ID')) THEN
        vsResult := vsResult || Create_Getter(psOwner, psTableName, i.column_name, TRUE);
        vsResult := vsResult || chr(10);
      END IF;
    END LOOP;
    vsResult := vsResult || vs_Displacement || '/*+GENERATOR(New getter)*/' || chr(10);
    vsResult := vsResult || chr(10);

    DecDisplacement;
    vsResult := vsResult || 'END ' || vTableParamSet.Class.Interface || ';' || chr(10);
    RETURN (vsResult);
  END Create_Interface_Realization;

  FUNCTION Create_AddRow_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1  CLOB;  -- version 1
    vsResult2  CLOB;  -- version 2 (ROWTYPE)
    vn_Cnt1    PLS_INTEGER;

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    -- Add comments
    vsResult1 := vs_Displacement || '-- Create new class instance ''' || INITCAP(vTableParamSet.Class.Name) || '''' || chr(10);
    vsResult2 := vs_Displacement || '-- Create new class instance ''' || INITCAP(vTableParamSet.Class.Name) || ''' using ROWTYPE' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE AddRow(' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'PROCEDURE AddRow(' || chr(10);
    IncDisplacement;

    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      vn_Cnt1 := vn_Cnt1 + 1;

      IF (i.comments IS NOT NULL) THEN
        vsResult1 := vsResult1 || vs_Displacement || '-- ' || i.comments || chr(10);
      END IF;

      vsResult1 := vsResult1 || vs_Displacement;

      IF (vn_Cnt1 <> 1) THEN
        vsResult1 := vsResult1 || ',p';
      ELSE
        vsResult1 := vsResult1 || ' p';
      END IF;

      CASE
        WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
          THEN vsResult1 := vsResult1 || 'd';
        WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB') OR i.column_name IN ('DESCRIPTION')
          THEN vsResult1 := vsResult1 || 's';
        WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
          THEN vsResult1 := vsResult1 || 'n';
        ELSE
          vsResult1 := vsResult1 || '?';
      END CASE;

      vsResult1 := vsResult1 || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ');
      IF (i.column_name != 'ID') THEN
        vsResult1 := vsResult1 || ' IN  ';
      ELSE
        vsResult1 := vsResult1 || ' OUT ';
      END IF;

      IF (i.column_name != 'DESCRIPTION') THEN
        vsResult1 := vsResult1 || vTableParamSet.FullTableName || '.' || INITCAP(i.column_name) || '%TYPE';
      ELSE
        vsResult1 := vsResult1 || 'VARCHAR2';
      END IF;

      IF (i.NULLABLE = 'Y') THEN
        vsResult1 := vsResult1 || ' DEFAULT NULL';
      END IF;
      vsResult1 := vsResult1 || chr(10);
    END LOOP;

    vsResult2 := vsResult2 || vs_Displacement || 'pxRow IN OUT NOCOPY ' || vTableParamSet.FullTableName || '%ROWTYPE' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ');' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || ');' || chr(10);

    RETURN (vsResult1 || chr(10) || vsResult2);

  END Create_AddRow_Spc;

  FUNCTION Create_AddRow(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1  CLOB;  -- version 1
    vsResult2  CLOB;  -- version 2 (ROWTYPE)
    vn_Cnt1    PLS_INTEGER;

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    -- Add comments
    vsResult1 := vs_Displacement || '-- Create new class instance ''' || INITCAP(vTableParamSet.Class.Name) || '''' || chr(10);
    vsResult2 := vs_Displacement || '-- Create new class instance ''' || INITCAP(vTableParamSet.Class.Name) || ''' using ROWTYPE' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE AddRow(' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'PROCEDURE AddRow(' || chr(10);
    IncDisplacement;

    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      vn_Cnt1 := vn_Cnt1 + 1;

      IF (i.comments IS NOT NULL) THEN
        vsResult1 := vsResult1 || vs_Displacement || '-- ' || i.comments || chr(10);
      END IF;

      IF (vn_Cnt1 <> 1) THEN
        vsResult1 := vsResult1 || vs_Displacement || ',p';
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ' p';
      END IF;

      CASE
        WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
          THEN vsResult1 := vsResult1 || 'd';
        WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB') OR i.column_name IN ('DESCRIPTION')
          THEN vsResult1 := vsResult1 || 's';
        WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
          THEN vsResult1 := vsResult1 || 'n';
        ELSE
          vsResult1 := vsResult1 || '?';
      END CASE;

      vsResult1 := vsResult1 || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ');
      IF (i.column_name != 'ID') THEN
        vsResult1 := vsResult1 || ' IN  ';
      ELSE
        vsResult1 := vsResult1 || ' OUT ';
      END IF;

      IF (i.column_name != 'DESCRIPTION') THEN
        vsResult1 := vsResult1 || vTableParamSet.FullTableName || '.' || INITCAP(i.column_name) || '%TYPE';
      ELSE
        vsResult1 := vsResult1 || 'VARCHAR2';
      END IF;

      IF (i.NULLABLE = 'Y') THEN
        vsResult1 := vsResult1 || ' DEFAULT NULL';
      END IF;
      vsResult1 := vsResult1 || chr(10);
    END LOOP;

    vsResult2 := vsResult2 || vs_Displacement || 'pxRow IN OUT NOCOPY ' || vTableParamSet.FullTableName || '%ROWTYPE' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ') IS' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || ') IS' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'BEGIN' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'BEGIN' || chr(10);
    IncDisplacement;
    vsResult2 := vsResult2 || vs_Displacement || 'pxRow.Id := BASE.iBase.GetNewId(''' || vTableParamSet.Owner || ''', ''' || psTableName || ''');' || chr(10);
    vsResult2 := vsResult2 || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'INSERT INTO ' || INITCAP(vTableParamSet.FullTableName) || ' (' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'INSERT INTO ' || INITCAP(vTableParamSet.FullTableName) || chr(10);
    IncDisplacement;

    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      vn_Cnt1 := vn_Cnt1 + 1;

      IF (vn_Cnt1 <> 1) THEN
        vsResult1 := vsResult1 || vs_Displacement || ',';
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ' ';
      END IF;

      IF (i.comments IS NOT NULL) THEN
        vsResult1 := vsResult1 || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ') || ' -- ' || i.comments || chr(10);
      ELSE
        vsResult1 := vsResult1 || INITCAP(i.column_name) || chr(10);
      END IF;

    END LOOP;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ') VALUES (' || chr(10);
    IncDisplacement;

    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      vn_Cnt1 := vn_Cnt1 + 1;

      IF (vn_Cnt1 <> 1) THEN
        vsResult1 := vsResult1 || vs_Displacement || ',';
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ' ';
      END IF;

      CASE i.column_name
        WHEN 'ID'
          THEN
            vsResult1 := vsResult1 || INITCAP(vTableParamSet.FullTableName) || '_Id.NEXTVAL' || chr(10);
        WHEN 'DESCRIPTION'
          THEN
            IF (vSolutionParamSet.Descriptions = 'Y') THEN
              vsResult1 := vsResult1 || vTableParamSet.Owner || '.iDescription.AddDescription(psDescription)' || chr(10);
            ELSE
              vsResult1 := vsResult1 || 'BASE.iBase.AddDescription(psDescription)' || chr(10);
            END IF;
        ELSE
          CASE
            WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
              THEN vsResult1 := vsResult1 || 'pd';
            WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB')
              THEN vsResult1 := vsResult1 || 'ps';
            WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
              THEN vsResult1 := vsResult1 || 'pn';
            ELSE
              vsResult1 := vsResult1 || 'p?';
          END CASE;

          vsResult1 := vsResult1 || INITCAP(i.column_name) || chr(10);
      END CASE;

    END LOOP;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ') RETURNING' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'VALUES pxRow' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'RETURNING' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ' Id' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || ' Id' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'INTO' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'INTO' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ' pnId' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || ' pxRow.Id' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ';' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || ';' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'END AddRow;' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'END AddRow;' || chr(10);

    RETURN(vsResult1 || chr(10) || vsResult2);

  END Create_AddRow;

  FUNCTION Create_GetRow_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vsIdComments VARCHAR2(4000);

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vsIdComments    := Get_ColumnComment(vTableParamSet.Owner, psTableName, 'ID');

    -- Add comments
    vsResult1 := vs_Displacement || '-- Return class instance ''' || INITCAP(vTableParamSet.Class.Name) || '''.' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'FUNCTION GetRow(' || chr(10);
    IncDisplacement;
    IF (vsIdComments IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vsIdComments || chr(10);
    END IF;
    vsResult1 := vsResult1 || vs_Displacement || ' pn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || ' IN  ' || vTableParamSet.FullTableName || '.Id%TYPE' || chr(10);
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || ') RETURN ' || vTableParamSet.FullTableName || '%ROWTYPE;' || chr(10);

    RETURN(vsResult1);

  END Create_GetRow_Spc;

  FUNCTION Create_GetRow(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vsIdComments VARCHAR2(4000);

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vsIdComments    := Get_ColumnComment(vTableParamSet.Owner, psTableName, 'ID');

    -- Add comments
    vsResult1 := vs_Displacement || '-- Return class instance ''' || INITCAP(vTableParamSet.Class.Name) || '''.' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'FUNCTION GetRow(' || chr(10);
    IncDisplacement;
    IF (vsIdComments IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vsIdComments || chr(10);
    END IF;
    vsResult1 := vsResult1 || vs_Displacement || ' pn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || ' IN  ' || vTableParamSet.FullTableName || '.Id%TYPE' || chr(10);
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || ') RETURN ' || vTableParamSet.FullTableName || '%ROWTYPE IS' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'vxRow ' || vTableParamSet.FullTableName || '%ROWTYPE;' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'BEGIN' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'SELECT * INTO vxRow' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'FROM ' || INITCAP(vTableParamSet.FullTableName) || ' t' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'WHERE t.Id = pnId' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || ';' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'RETURN (vxRow);' || chr(10);
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || 'END GetRow;' || chr(10);

    RETURN(vsResult1);

  END Create_GetRow;

  FUNCTION Create_Getter_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psColumnName  IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vsIdComments VARCHAR2(4000);

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vColumnParamSet := AnalyzeColumn(vTableParamSet.Owner, psTableName, psColumnName);    
    vsIdComments    := Get_ColumnComment(vTableParamSet.Owner, psTableName, 'ID');

    -- Add comments
    vsResult1 := vs_Displacement || '-- Return value of property ''' || NVL(vColumnParamSet.PropertyName, psColumnName) || '''' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'FUNCTION Get' || INITCAP(psColumnName) || '(' || chr(10);
    IncDisplacement;
    IF (vsIdComments IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vsIdComments || chr(10);
    END IF;

    vsResult1 := vsResult1 || vs_Displacement || ' pn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || ' IN ' || vTableParamSet.FullTableName || '.Id%TYPE' || chr(10);

    DecDisplacement;
    IF (UPPER(psColumnName) = 'DESCRIPTION') THEN
      IF (vSolutionParamSet.Descriptions = 'Y') THEN
        vsResult1 := vsResult1 || vs_Displacement || ') RETURN ' || vTableParamSet.Owner || '.Description.Text%TYPE;' || chr(10);
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ') RETURN BASE.Description.Text%TYPE;' || chr(10);
      END IF;
    ELSE
      vsResult1 := vsResult1 || vs_Displacement || ') RETURN ' || vTableParamSet.FullTableName || '.' || INITCAP(psColumnName) || '%TYPE;' || chr(10);
    END IF;

    RETURN(vsResult1);

  END Create_Getter_Spc;

  FUNCTION Create_Getter(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psColumnName  IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vsIdComments VARCHAR2(4000);

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vColumnParamSet := AnalyzeColumn(vTableParamSet.Owner, psTableName, psColumnName);    
    vsIdComments    := Get_ColumnComment(vTableParamSet.Owner, psTableName, 'ID');

    -- Add comments
    vsResult1 := vs_Displacement || '-- Return value of property ''' || NVL(vColumnParamSet.PropertyName, psColumnName) || '''' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'FUNCTION Get' || INITCAP(psColumnName) || '(' || chr(10);
    IncDisplacement;
    IF (vsIdComments IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vsIdComments || chr(10);
    END IF;

    vsResult1 := vsResult1 || vs_Displacement || ' pn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || ' IN ' || vTableParamSet.FullTableName || '.Id%TYPE' || chr(10);

    DecDisplacement;
    IF (UPPER(psColumnName) = 'DESCRIPTION') THEN
      IF (vSolutionParamSet.Descriptions = 'Y') THEN
        vsResult1 := vsResult1 || vs_Displacement || ') RETURN ' || vTableParamSet.Owner || '.Description.Text%TYPE IS' || chr(10);
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ') RETURN BASE.Description.Text%TYPE IS' || chr(10);
      END IF;
    ELSE
      vsResult1 := vsResult1 || vs_Displacement || ') RETURN ' || vTableParamSet.FullTableName || '.' || INITCAP(psColumnName) || '%TYPE IS' || chr(10);
    END IF;
    IncDisplacement;

    IF (vColumnParamSet.ColumnComment IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vColumnParamSet.ColumnComment || chr(10);
    END IF;

    CASE
      WHEN SUBSTR(vColumnParamSet.DataType, 1, 9) IN ('DATE', 'TIMESTAMP')
        THEN vsResult1 := vsResult1 || vs_Displacement || 'vd' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
      WHEN vColumnParamSet.DataType IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB') OR UPPER(psColumnName) IN ('DESCRIPTION')
        THEN vsResult1 := vsResult1 || vs_Displacement || 'vs' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
      WHEN vColumnParamSet.DataType IN ('NUMBER', 'INTEGER', 'FLOAT')
        THEN vsResult1 := vsResult1 || vs_Displacement || 'vn' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || 'v?' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
    END CASE;

    CASE UPPER(psColumnName)
      WHEN 'DESCRIPTION' 
        THEN
          IF (vSolutionParamSet.Descriptions = 'Y') THEN
            vsResult1 := vsResult1 || ' ' || vTableParamSet.Owner || '.Description.Text%TYPE;' || chr(10);
          ELSE
            vsResult1 := vsResult1 || ' BASE.Description.Text%TYPE;' || chr(10);
          END IF;
      ELSE
        vsResult1 := vsResult1 || ' ' || vTableParamSet.FullTableName || '.' || INITCAP(psColumnName) || '%TYPE;' || chr(10);
    END CASE;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'BEGIN' || chr(10);
    IncDisplacement;

    CASE UPPER(psColumnName)
      WHEN 'DESCRIPTION'
        THEN
          vsResult1 := vsResult1 || vs_Displacement || 'SELECT d.Text INTO vsDescription' || chr(10);
      ELSE
        CASE
          WHEN SUBSTR(vColumnParamSet.DataType, 1, 9) IN ('DATE', 'TIMESTAMP')
            THEN vsResult1 := vsResult1 || vs_Displacement || 'SELECT t.'|| INITCAP(psColumnName) || ' INTO vd' || INITCAP(psColumnName) || chr(10);
          WHEN vColumnParamSet.DataType IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB')
            THEN vsResult1 := vsResult1 || vs_Displacement || 'SELECT t.'|| INITCAP(psColumnName) || ' INTO vs' || INITCAP(psColumnName) || chr(10);
          WHEN vColumnParamSet.DataType IN ('NUMBER', 'INTEGER', 'FLOAT')
            THEN vsResult1 := vsResult1 || vs_Displacement || 'SELECT t.'|| INITCAP(psColumnName) || ' INTO vn' || INITCAP(psColumnName) || chr(10);
          ELSE
            vsResult1 := vsResult1 || vs_Displacement || 'SELECT t.'|| INITCAP(psColumnName) || ' INTO v?' || INITCAP(psColumnName) || chr(10);
        END CASE;
    END CASE;

    vsResult1 := vsResult1 || vs_Displacement || 'FROM' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ' ' || vTableParamSet.FullTableName || ' t' || chr(10);
    IF (UPPER(psColumnName) = 'DESCRIPTION') THEN
      IF (vSolutionParamSet.Descriptions = 'Y') THEN
        vsResult1 := vsResult1 || vs_Displacement || ',' || vTableParamSet.Owner || '.Description d' || chr(10);
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ',BASE.Description d' || chr(10);
      END IF;
    END IF;
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || 'WHERE t.Id = pnId' || chr(10);   
    IF (UPPER(psColumnName) = 'DESCRIPTION') THEN
      vsResult1 := vsResult1 || vs_Displacement || '  AND t.Description = d.Id(+)' || chr(10);
    END IF;
    vsResult1 := vsResult1 || vs_Displacement || ';' || chr(10);
    CASE
      WHEN SUBSTR(vColumnParamSet.DataType, 1, 9) IN ('DATE', 'TIMESTAMP')
        THEN vsResult1 := vsResult1 || vs_Displacement || 'RETURN (vd' || INITCAP(psColumnName) || ');' || chr(10);
      WHEN vColumnParamSet.DataType IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB') OR UPPER(psColumnName) = 'DESCRIPTION'
        THEN vsResult1 := vsResult1 || vs_Displacement || 'RETURN (vs' || INITCAP(psColumnName) || ');' || chr(10);
      WHEN vColumnParamSet.DataType IN ('NUMBER', 'INTEGER', 'FLOAT')
        THEN vsResult1 := vsResult1 || vs_Displacement || 'RETURN (vn' || INITCAP(psColumnName) || ');' || chr(10);
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || 'RETURN (v?' || INITCAP(psColumnName) || ');' || chr(10);
    END CASE;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'END Get' || INITCAP(psColumnName) || ';' || chr(10);

    RETURN(vsResult1);

  END Create_Getter;

  FUNCTION Create_GetSet_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1  CLOB;
    vn_Cnt1    PLS_INTEGER;

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    -- Add comments
    vsResult1 := vs_Displacement || '-- Return an instance set of class ''' || INITCAP(vTableParamSet.Class.Name) || '''' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE GetSet(' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || '-- Result cursor' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || ' pc' || RPAD('Set', vTableParamSet.MaxColNameLength, ' ') || ' OUT BASE.iBase.RefCursor' || chr(10);

    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      IF (i.column_name != 'DESCRIPTION' AND i.data_type != 'CLOB') THEN
        vn_Cnt1 := vn_Cnt1 + 1;

        IF (i.comments IS NOT NULL) THEN
          vsResult1 := vsResult1 || vs_Displacement || '-- ' || i.comments || chr(10);
        END IF;

        vsResult1 := vsResult1 || vs_Displacement || ',p';

        CASE
          WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
            THEN vsResult1 := vsResult1 || 'd';
          WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR')
            THEN vsResult1 := vsResult1 || 's';
          WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
            THEN vsResult1 := vsResult1 || 'n';
          ELSE
            vsResult1 := vsResult1 || '?';
        END CASE;

        vsResult1 := vsResult1 || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ') || ' IN  ';
        vsResult1 := vsResult1 || vTableParamSet.FullTableName || '.' || INITCAP(i.column_name) || '%TYPE';
        vsResult1 := vsResult1 || ' DEFAULT NULL';
        vsResult1 := vsResult1 || chr(10);
      END IF;
    END LOOP;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ');' || chr(10);

    RETURN (vsResult1);

  END Create_GetSet_Spc;

  FUNCTION Create_GetSet(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1  CLOB;
    vn_Cnt1    PLS_INTEGER;

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    -- Add comments
    vsResult1 := vs_Displacement || '-- Return an instance set of class ''' || INITCAP(vTableParamSet.Class.Name) || '''' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE GetSet(' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || '-- Result cursor' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || ' pc' || RPAD('Set', vTableParamSet.MaxColNameLength, ' ') || ' OUT BASE.iBase.RefCursor' || chr(10);

    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      IF (i.column_name != 'DESCRIPTION' AND i.data_type != 'CLOB') THEN
        vn_Cnt1 := vn_Cnt1 + 1;

        IF (i.comments IS NOT NULL) THEN
          vsResult1 := vsResult1 || vs_Displacement || '-- ' || i.comments || chr(10);
        END IF;

        vsResult1 := vsResult1 || vs_Displacement || ',p';

        CASE
          WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
            THEN vsResult1 := vsResult1 || 'd';
          WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR')
            THEN vsResult1 := vsResult1 || 's';
          WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
            THEN vsResult1 := vsResult1 || 'n';
          ELSE
            vsResult1 := vsResult1 || '?';
        END CASE;

        vsResult1 := vsResult1 || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ') || ' IN  ';
        vsResult1 := vsResult1 || vTableParamSet.FullTableName || '.' || INITCAP(i.column_name) || '%TYPE';
        vsResult1 := vsResult1 || ' DEFAULT NULL';
        vsResult1 := vsResult1 || chr(10);
      END IF;
    END LOOP;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ') IS' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'BEGIN' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'OPEN pcSet FOR' || chr(10);
    IncDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || 'SELECT' || chr(10);
    IncDisplacement;

    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      vn_Cnt1 := vn_Cnt1 + 1;

      IF (vn_Cnt1 <> 1) THEN
        vsResult1 := vsResult1 || vs_Displacement || ',t.' || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ');
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ' t.' || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ');
      END IF;

      IF (i.column_name = 'DESCRIPTION') THEN
        vsResult1 := vsResult1 || ' AS idDescription' || chr(10);
        IF (vSolutionParamSet.Descriptions = 'Y') THEN
          vsResult1 := vsResult1 || vs_Displacement || ',' || vTableParamSet.Owner || '.iDescription.GetText(t.Description) AS cDescription' || chr(10);
        ELSE
          vsResult1 := vsResult1 || vs_Displacement || ',BASE.iDescription.GetText(t.Description) AS cDescription' || chr(10);
        END IF;
      ELSE
        CASE
          WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
            THEN vsResult1 := vsResult1 || ' AS d' || INITCAP(i.column_name) || chr(10);
          WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB')
            THEN vsResult1 := vsResult1 || ' AS s' || INITCAP(i.column_name) || chr(10);
          WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
            THEN vsResult1 := vsResult1 || ' AS n' || INITCAP(i.column_name) || chr(10);
          ELSE
            vsResult1 := vsResult1 || ' AS ?' || INITCAP(i.column_name) || chr(10);
        END CASE;
      END IF;
    END LOOP;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'FROM ' || INITCAP(vTableParamSet.FullTableName) || ' t' || chr(10);

    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP

      IF (i.column_name != 'DESCRIPTION' AND i.data_type != 'CLOB') THEN
        vn_Cnt1 := vn_Cnt1 + 1;

        IF (vn_Cnt1 <> 1) THEN
          vsResult1 := vsResult1 || vs_Displacement || '  AND (t.' || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ');
        ELSE
          vsResult1 := vsResult1 || vs_Displacement || 'WHERE (t.' || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ');
        END IF;

        CASE
          WHEN SUBSTR(i.data_type, 1, 9) IN ('DATE', 'TIMESTAMP')
            THEN vsResult1 := vsResult1 || ' = pd' || INITCAP(i.column_name) || ' OR pd' || INITCAP(i.column_name) || ' IS NULL)' || chr(10);
          WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR')
            THEN vsResult1 := vsResult1 || ' = ps' || INITCAP(i.column_name) || ' OR ps' || INITCAP(i.column_name) || ' IS NULL)' || chr(10);
          WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
            THEN vsResult1 := vsResult1 || ' = pn' || INITCAP(i.column_name) || ' OR pn' || INITCAP(i.column_name) || ' IS NULL)' || chr(10);
          ELSE
            vsResult1 := vsResult1 || ' = p?' || INITCAP(i.column_name) || ' OR p?' || INITCAP(i.column_name) || ' IS NULL)' || chr(10);
        END CASE;
      END IF;
    END LOOP;

    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || ';' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'END GetSet;' || chr(10);

    RETURN (vsResult1);

  END Create_GetSet;

  FUNCTION Create_DelRow_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vsIdComments VARCHAR2(4000);

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vsIdComments    := Get_ColumnComment(vTableParamSet.Owner, psTableName, 'ID');

    -- Add comments
    vsResult1 := vs_Displacement || '-- Delete instance of class ''' || INITCAP(vTableParamSet.Class.Name) || '''' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE DelRow(' || chr(10);
    IncDisplacement;
    IF (vsIdComments IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vsIdComments || chr(10);
    END IF;
    vsResult1 := vsResult1 || vs_Displacement || ' pn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || ' IN  ' || vTableParamSet.FullTableName || '.Id%TYPE' || chr(10);
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || ');' || chr(10);

    RETURN(vsResult1);

  END Create_DelRow_Spc;

  FUNCTION Create_DelRow(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vsIdComments VARCHAR2(4000);

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vsIdComments    := Get_ColumnComment(vTableParamSet.Owner, psTableName, 'ID');

    -- Add comments
    vsResult1 := vs_Displacement || '-- Delete instance of class ''' || INITCAP(vTableParamSet.Class.Name) || '''.' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE DelRow(' || chr(10);
    IncDisplacement;
    IF (vsIdComments IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vsIdComments || chr(10);
    END IF;
    vsResult1 := vsResult1 || vs_Displacement || ' pn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || ' IN  ' || vTableParamSet.FullTableName || '.Id%TYPE' || chr(10);
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || ') IS' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'vxRow ' || vTableParamSet.FullTableName || '%ROWTYPE;' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'BEGIN' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'vxRow := ' || UPPER(vTableParamSet.Owner) || '.' || vTableParamSet.Class.Interface || '.GetRow(pnId);' || chr(10);

    IF (vTableParamSet.DescriptionFlag > 0) THEN
      vsResult1 := vsResult1 || vs_Displacement || UPPER(vTableParamSet.Owner) || '.iDescription.DelRow(vxRow.Description);' || chr(10);
    END IF;

    vsResult1 := vsResult1 || vs_Displacement || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'DELETE' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'FROM ' || INITCAP(vTableParamSet.FullTableName) || ' t' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'WHERE t.Id = pnId' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || ';' || chr(10);
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || 'END DelRow;' || chr(10);

    RETURN(vsResult1);

  END Create_DelRow;

  FUNCTION Create_Ind_Getter_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psIndexName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vn_Cnt1      PLS_INTEGER;
    vnIndexNum   PLS_INTEGER;

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    SELECT
       x.ind_num
    INTO
       vnIndexNum
    FROM
       (SELECT
           rownum        AS ind_num
          ,t.index_name  AS index_name
        FROM sys.all_constraints t
        WHERE t.table_name = UPPER(psTableName)
          AND t.owner = vTableParamSet.Owner
          AND t.constraint_type = 'U'
        ORDER BY t.constraint_name) x
    WHERE x.index_name = UPPER(psIndexName)
    ;

    -- Add comments
    vsResult1 := vsResult1 || vs_Displacement || '-- Return an instance identifier of class ''' || NVL(vTableParamSet.Class.Name , vTableParamSet.FullTableName) || '''' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || '-- using index ''' || UPPER(psIndexName) || '''.' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'FUNCTION GetId' || TO_CHAR(vnIndexNum) || '(' || chr(10);
    IncDisplacement;

    vn_Cnt1 := 0;
    FOR i IN AllIndColumns(vTableParamSet.Owner, psTableName, psIndexName) LOOP
      vn_Cnt1 := vn_Cnt1 + 1;

      IF (i.comments IS NOT NULL) THEN
        vsResult1 := vsResult1 || vs_Displacement || '-- ' || i.comments || chr(10);
      END IF;

      IF (vn_Cnt1 <> 1) THEN
        vsResult1 := vsResult1 || vs_Displacement || ',p';
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ' p';
      END IF;

      CASE
        WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
          THEN vsResult1 := vsResult1 || 'd';
        WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR')
          THEN vsResult1 := vsResult1 || 's';
        WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
          THEN vsResult1 := vsResult1 || 'n';
        ELSE
          vsResult1 := vsResult1 || '?';
      END CASE;

      vsResult1 := vsResult1 || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ') || ' IN  ';
      vsResult1 := vsResult1 || vTableParamSet.FullTableName || '.' || INITCAP(i.column_name) || '%TYPE' || chr(10);

    END LOOP;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ') RETURN ' || vTableParamSet.FullTableName || '.Id%TYPE;' || chr(10);

    RETURN(vsResult1);

  END Create_Ind_Getter_Spc;

  FUNCTION Create_Ind_Getter(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psIndexName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vn_Cnt1      PLS_INTEGER;
    vnIndexNum   PLS_INTEGER;

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    SELECT
       x.ind_num
    INTO
       vnIndexNum
    FROM
       (SELECT
           rownum        AS ind_num
          ,t.index_name  AS index_name
        FROM sys.all_constraints t
        WHERE t.table_name = UPPER(psTableName) 
          AND t.owner = vTableParamSet.Owner
          AND t.constraint_type = 'U'
        ORDER BY t.constraint_name) x
    WHERE x.index_name = UPPER(psIndexName)
    ;

    -- Add comments
    vsResult1 := vsResult1 || vs_Displacement || '-- Return an instance identifier of class ''' || NVL(vTableParamSet.Class.Name , vTableParamSet.FullTableName) || '''' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || '-- using index ''' || UPPER(psIndexName) || '''.' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'FUNCTION GetId' || TO_CHAR(vnIndexNum) || '(' || chr(10);
    IncDisplacement;

    vn_Cnt1 := 0;
    FOR i IN AllIndColumns(vTableParamSet.Owner, psTableName, psIndexName) LOOP
      vn_Cnt1 := vn_Cnt1 + 1;

      IF (i.comments IS NOT NULL) THEN
        vsResult1 := vsResult1 || vs_Displacement || '-- ' || i.comments || chr(10);
      END IF;

      IF (vn_Cnt1 <> 1) THEN
        vsResult1 := vsResult1 || vs_Displacement || ',p';
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ' p';
      END IF;

      CASE
        WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
          THEN vsResult1 := vsResult1 || 'd';
        WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR')
          THEN vsResult1 := vsResult1 || 's';
        WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
          THEN vsResult1 := vsResult1 || 'n';
        ELSE
          vsResult1 := vsResult1 || '?';
      END CASE;

      vsResult1 := vsResult1 || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ') || ' IN  ';
      vsResult1 := vsResult1 || vTableParamSet.FullTableName || '.' || INITCAP(i.column_name) || '%TYPE' || chr(10);

    END LOOP;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ') RETURN ' || vTableParamSet.FullTableName || '.Id%TYPE IS' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'vn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || vTableParamSet.FullTableName || '.Id%TYPE;' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'BEGIN' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'SELECT t.Id INTO vnId' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'FROM' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || ' ' || INITCAP(vTableParamSet.FullTableName) || ' t' || chr(10);

    vn_Cnt1 := 0;
    FOR i IN AllIndColumns(vTableParamSet.Owner, psTableName, psIndexName) LOOP
      vn_Cnt1 := vn_Cnt1 + 1;

      IF (vn_Cnt1 <> 1) THEN
        vsResult1 := vsResult1 || vs_Displacement || '  AND t.' || INITCAP(i.column_name);
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || 'WHERE t.' || INITCAP(i.column_name);
      END IF;

      CASE
        WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
          THEN vsResult1 := vsResult1 || ' = pd' || INITCAP(i.column_name) || chr(10);
        WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR')
          THEN vsResult1 := vsResult1 || ' = ps' || INITCAP(i.column_name) || chr(10);
        WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
          THEN vsResult1 := vsResult1 || ' = pn' || INITCAP(i.column_name) || chr(10);
        ELSE
          vsResult1 := vsResult1 || ' = p?' || INITCAP(i.column_name) || chr(10);
      END CASE;

    END LOOP;

    vsResult1 := vsResult1 || vs_Displacement || ';' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'RETURN (vnId);' || chr(10);

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'END GetId' || TO_CHAR(vnIndexNum) || ';' || chr(10);

    RETURN(vsResult1);

  END Create_Ind_Getter;

  FUNCTION Create_LockRow_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vsIdComments VARCHAR2(4000);

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vsIdComments    := Get_ColumnComment(vTableParamSet.Owner, psTableName, 'ID');

    -- Add comments
    vsResult1 := vs_Displacement || '-- Lock instance of class ''' || INITCAP(vTableParamSet.Class.Name) || ''' for editing' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE LockRow(' || chr(10);
    IncDisplacement;
    IF (vsIdComments IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vsIdComments || chr(10);
    END IF;
    vsResult1 := vsResult1 || vs_Displacement || ' pn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || ' IN  ' || vTableParamSet.FullTableName || '.Id%TYPE' || chr(10);
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || ');' || chr(10);

    RETURN(vsResult1);

  END Create_LockRow_Spc;

  FUNCTION Create_LockRow(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vsIdComments VARCHAR2(4000);

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vsIdComments    := Get_ColumnComment(vTableParamSet.Owner, psTableName, 'ID');

    -- Add comments
    vsResult1 := vs_Displacement || '-- Lock instance of class ''' || INITCAP(vTableParamSet.Class.Name) || ''' for editing' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE LockRow(' || chr(10);
    IncDisplacement;
    IF (vsIdComments IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vsIdComments || chr(10);
    END IF;
    vsResult1 := vsResult1 || vs_Displacement || ' pn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || ' IN  ' || vTableParamSet.FullTableName || '.Id%TYPE' || chr(10);
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || ') IS' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'vnId ' || vTableParamSet.FullTableName || '.Id%TYPE;' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'BEGIN' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'SELECT t.Id INTO vnId' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'FROM ' || INITCAP(vTableParamSet.FullTableName) || ' t' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'WHERE t.Id = pnId' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'FOR UPDATE NOWAIT;' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'EXCEPTION' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'WHEN TIMEOUT_ON_RESOURCE' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'THEN raise_application_error(-20000, ''Error! Object already locked by another user.'');' || chr(10);
    DecDisplacement;
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || 'END LockRow;' || chr(10);

    RETURN(vsResult1);

  END Create_LockRow;

  PROCEDURE Create_Class_Sequence(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) IS
    vnCnt  PLS_INTEGER;
    vsSQL  CLOB;
  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vnCnt := DEV.Generators.Get_Sequence_Count(
                psOwner         => vTableParamSet.Owner
               ,psSequenceName  => UPPER(psTableName) || '_ID'
             );

    IF (vnCnt > 0) THEN
      RETURN;
    END IF;

    vsSQL := '
    CREATE SEQUENCE ' || vTableParamSet.FullTableName || '_ID
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1
    NOCACHE';

    EXECUTE IMMEDIATE TO_CHAR(vsSQL);

  END Create_Class_Sequence;

  FUNCTION Create_SetRow_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1  CLOB;  -- version 1
    vsResult2  CLOB;  -- version 2 (ROWTYPE)
    vn_Cnt1    PLS_INTEGER;

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    -- Add comments
    vsResult1 := vs_Displacement || '-- Set instance of ''' || INITCAP(vTableParamSet.Class.Name) || '''' || chr(10);
    vsResult2 := vs_Displacement || '-- Set instance of ''' || INITCAP(vTableParamSet.Class.Name) || ''' using ROWTYPE' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE SetRow(' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'PROCEDURE SetRow(' || chr(10);
    IncDisplacement;

    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      vn_Cnt1 := vn_Cnt1 + 1;

      IF (i.comments IS NOT NULL) THEN
        vsResult1 := vsResult1 || vs_Displacement || '-- ' || i.comments || chr(10);
      END IF;

      vsResult1 := vsResult1 || vs_Displacement;

      IF (vn_Cnt1 <> 1) THEN
        vsResult1 := vsResult1 || ',p';
      ELSE
        vsResult1 := vsResult1 || ' p';
      END IF;

      CASE
        WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
          THEN vsResult1 := vsResult1 || 'd';
        WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB') OR i.column_name IN ('DESCRIPTION')
          THEN vsResult1 := vsResult1 || 's';
        WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
          THEN vsResult1 := vsResult1 || 'n';
        ELSE
          vsResult1 := vsResult1 || '?';
      END CASE;

      vsResult1 := vsResult1 || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ') || ' IN  ';

      IF (i.column_name != 'DESCRIPTION') THEN
        vsResult1 := vsResult1 || vTableParamSet.FullTableName || '.' || INITCAP(i.column_name) || '%TYPE';
      ELSE
        vsResult1 := vsResult1 || 'VARCHAR2';
      END IF;

      IF (i.NULLABLE = 'Y') THEN
        vsResult1 := vsResult1 || ' DEFAULT NULL';
      END IF;
      vsResult1 := vsResult1 || chr(10);
    END LOOP;

    vsResult2 := vsResult2 || vs_Displacement || 'pxRow IN OUT NOCOPY ' || vTableParamSet.FullTableName || '%ROWTYPE' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ');' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || ');' || chr(10);

    RETURN (vsResult1 || chr(10) || vsResult2);

  END Create_SetRow_Spc;

  FUNCTION Create_SetRow(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1  CLOB;  -- version 1
    vsResult2  CLOB;  -- version 2 (ROWTYPE)
    vn_Cnt1    PLS_INTEGER;

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    -- Add comments
    vsResult1 := vs_Displacement || '-- Set instance of ''' || INITCAP(vTableParamSet.Class.Name) || '''' || chr(10);
    vsResult2 := vs_Displacement || '-- Set instance of ''' || INITCAP(vTableParamSet.Class.Name) || ''' using ROWTYPE' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE SetRow(' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'PROCEDURE SetRow(' || chr(10);
    IncDisplacement;

    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      vn_Cnt1 := vn_Cnt1 + 1;

      IF (i.comments IS NOT NULL) THEN
        vsResult1 := vsResult1 || vs_Displacement || '-- ' || i.comments || chr(10);
      END IF;

      IF (vn_Cnt1 <> 1) THEN
        vsResult1 := vsResult1 || vs_Displacement || ',p';
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ' p';
      END IF;

      CASE
        WHEN SUBSTR(i.DATA_TYPE, 1, 9) IN ('DATE', 'TIMESTAMP')
          THEN vsResult1 := vsResult1 || 'd';
        WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB') OR i.column_name IN ('DESCRIPTION')
          THEN vsResult1 := vsResult1 || 's';
        WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
          THEN vsResult1 := vsResult1 || 'n';
        ELSE
          vsResult1 := vsResult1 || '?';
      END CASE;

      vsResult1 := vsResult1 || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ') || ' IN  ';

      IF (i.column_name != 'DESCRIPTION') THEN
        vsResult1 := vsResult1 || vTableParamSet.FullTableName || '.' || INITCAP(i.column_name) || '%TYPE';
      ELSE
        vsResult1 := vsResult1 || 'VARCHAR2';
      END IF;

      IF (i.NULLABLE = 'Y') THEN
        vsResult1 := vsResult1 || ' DEFAULT NULL';
      END IF;
      vsResult1 := vsResult1 || chr(10);
    END LOOP;

    vsResult2 := vsResult2 || vs_Displacement || 'pxRow IN OUT NOCOPY ' || vTableParamSet.FullTableName || '%ROWTYPE' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ') IS' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || ') IS' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'BEGIN' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'BEGIN' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'UPDATE ' || INITCAP(vTableParamSet.FullTableName) || ' t' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'UPDATE ' || INITCAP(vTableParamSet.FullTableName) || ' t' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'SET' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'SET' || chr(10);

    IncDisplacement;
    vn_Cnt1 := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      IF (i.column_name != 'ID') THEN
        vn_Cnt1 := vn_Cnt1 + 1;

        IF (vn_Cnt1 <> 1) THEN
          vsResult1 := vsResult1 || vs_Displacement || ',t.' || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ');
          vsResult2 := vsResult2 || vs_Displacement || ',t.' || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ');
        ELSE
          vsResult1 := vsResult1 || vs_Displacement || ' t.' || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ');
          vsResult2 := vsResult2 || vs_Displacement || ' t.' || RPAD(INITCAP(i.column_name), vTableParamSet.MaxColNameLength, ' ');
        END IF;

        CASE i.column_name
        WHEN 'DESCRIPTION'
          THEN
            IF (vSolutionParamSet.Descriptions = 'Y') THEN
              vsResult1 := vsResult1 || ' = ' || vTableParamSet.Owner || '.iDescription.AddDescription(psDescription)' || chr(10);
            ELSE
              vsResult1 := vsResult1 || ' = BASE.iBase.AddDescription(psDescription)' || chr(10);
            END IF;
        ELSE
          CASE
            WHEN SUBSTR(i.data_type, 1, 9) IN ('DATE', 'TIMESTAMP')
              THEN vsResult1 := vsResult1 || ' = pd' || INITCAP(i.column_name) || chr(10);
            WHEN i.data_type IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB')
              THEN vsResult1 := vsResult1 || ' = ps' || INITCAP(i.column_name) || chr(10);
            WHEN i.data_type IN ('NUMBER', 'INTEGER', 'FLOAT')
              THEN vsResult1 := vsResult1 || ' = pn' || INITCAP(i.column_name) || chr(10);
            ELSE
              vsResult1 := vsResult1 || ' = p?' || INITCAP(i.column_name) || chr(10);
          END CASE;
        END CASE;

        vsResult2 := vsResult2 || ' = pxRow.' || INITCAP(i.column_name) || chr(10);
      END IF;
    END LOOP;
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || 'WHERE t.Id = pnId' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'WHERE t.Id = pxRow.Id' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || ';' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || ';' || chr(10);
    DecDisplacement;

    vsResult1 := vsResult1 || vs_Displacement || 'END SetRow;' || chr(10);
    vsResult2 := vsResult2 || vs_Displacement || 'END SetRow;' || chr(10);

    RETURN(vsResult1 || chr(10) || vsResult2);

  END Create_SetRow;

  FUNCTION Create_Setter_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psColumnName  IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vsIdComments VARCHAR2(4000);

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vColumnParamSet := AnalyzeColumn(vTableParamSet.Owner, psTableName, psColumnName);
    vsIdComments    := Get_ColumnComment(vTableParamSet.Owner, psTableName, 'ID');

    -- Add comments
    vsResult1 := vs_Displacement || '-- Set a value of property ''' || NVL(vColumnParamSet.PropertyName, psColumnName) || '''' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE Set' || INITCAP(psColumnName) || '(' || chr(10);
    IncDisplacement;
    IF (vsIdComments IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vsIdComments || chr(10);
    END IF;

    vsResult1 := vsResult1 || vs_Displacement || ' pn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || ' IN ' || vTableParamSet.FullTableName || '.Id%TYPE' || chr(10);

    IF (vColumnParamSet.ColumnComment IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vColumnParamSet.ColumnComment || chr(10);
    END IF;

    CASE
      WHEN SUBSTR(vColumnParamSet.DataType, 1, 9) IN ('DATE', 'TIMESTAMP')
        THEN vsResult1 := vsResult1 || vs_Displacement || ',pd' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
      WHEN vColumnParamSet.DataType IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB') OR UPPER(psColumnName) IN ('DESCRIPTION')
        THEN vsResult1 := vsResult1 || vs_Displacement || ',ps' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
      WHEN vColumnParamSet.DataType IN ('NUMBER', 'INTEGER', 'FLOAT')
        THEN vsResult1 := vsResult1 || vs_Displacement || ',pn' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ',p?' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
    END CASE;

    CASE UPPER(psColumnName)
      WHEN 'DESCRIPTION' 
        THEN
          vsResult1 := vsResult1 || ' IN VARCHAR2' || chr(10);
      ELSE
        vsResult1 := vsResult1 || ' IN ' || vTableParamSet.FullTableName || '.' || INITCAP(psColumnName) || '%TYPE' || chr(10);
    END CASE;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ');' || chr(10);

    RETURN(vsResult1);

  END Create_Setter_Spc;

  FUNCTION Create_Setter(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psColumnName  IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult1    CLOB;
    vsIdComments VARCHAR2(4000);

  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    vColumnParamSet := AnalyzeColumn(vTableParamSet.Owner, psTableName, psColumnName);    
    vsIdComments    := Get_ColumnComment(vTableParamSet.Owner, psTableName, 'ID');

    -- Add comments
    vsResult1 := vs_Displacement || '-- Set a value of property ''' || NVL(vColumnParamSet.PropertyName, psColumnName) || '''' || chr(10);
    -- Starting creating procedure
    vsResult1 := vsResult1 || vs_Displacement || 'PROCEDURE Set' || INITCAP(psColumnName) || '(' || chr(10);
    IncDisplacement;
    IF (vsIdComments IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vsIdComments || chr(10);
    END IF;

    vsResult1 := vsResult1 || vs_Displacement || ' pn' || RPAD('Id', vTableParamSet.MaxColNameLength, ' ') || ' IN ' || vTableParamSet.FullTableName || '.Id%TYPE' || chr(10);

    IF (vColumnParamSet.ColumnComment IS NOT NULL) THEN
      vsResult1 := vsResult1 || vs_Displacement || '-- ' || vColumnParamSet.ColumnComment || chr(10);
    END IF;

    CASE
      WHEN SUBSTR(vColumnParamSet.DataType, 1, 9) IN ('DATE', 'TIMESTAMP')
        THEN vsResult1 := vsResult1 || vs_Displacement || ',pd' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
      WHEN vColumnParamSet.DataType IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB') OR UPPER(psColumnName) IN ('DESCRIPTION')
        THEN vsResult1 := vsResult1 || vs_Displacement || ',ps' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
      WHEN vColumnParamSet.DataType IN ('NUMBER', 'INTEGER', 'FLOAT')
        THEN vsResult1 := vsResult1 || vs_Displacement || ',pn' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
      ELSE
        vsResult1 := vsResult1 || vs_Displacement || ',p?' || RPAD(INITCAP(psColumnName), vTableParamSet.MaxColNameLength, ' ');
    END CASE;

    CASE UPPER(psColumnName)
      WHEN 'DESCRIPTION'
        THEN
          vsResult1 := vsResult1 || ' IN VARCHAR2' || chr(10);
      ELSE
        vsResult1 := vsResult1 || ' IN ' || vTableParamSet.FullTableName || '.' || INITCAP(psColumnName) || '%TYPE' || chr(10);
    END CASE;

    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || ') IS' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || 'BEGIN' || chr(10);
    IncDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'UPDATE ' || INITCAP(vTableParamSet.FullTableName) || ' t' || chr(10);

    vsResult1 := vsResult1 || vs_Displacement || 'SET t.' || INITCAP(psColumnName) || ' = ';
    CASE UPPER(psColumnName)
      WHEN 'DESCRIPTION' 
        THEN
          IF (vSolutionParamSet.Descriptions = 'Y') THEN
            vsResult1 := vsResult1 || vTableParamSet.Owner || '.iDescription.AddDescription(psDescription)' || chr(10);
          ELSE
            vsResult1 := vsResult1 || 'BASE.iBase.AddDescription(psDescription)' || chr(10);
          END IF;
      ELSE
        CASE
          WHEN SUBSTR(vColumnParamSet.DataType, 1, 9) IN ('DATE', 'TIMESTAMP')
            THEN vsResult1 := vsResult1 || 'pd' || INITCAP(psColumnName) || chr(10);
          WHEN vColumnParamSet.DataType IN ('VARCHAR', 'VARCHAR2', 'CHAR', 'CLOB')
            THEN vsResult1 := vsResult1 || 'ps' || INITCAP(psColumnName) || chr(10);
          WHEN vColumnParamSet.DataType IN ('NUMBER', 'INTEGER', 'FLOAT')
            THEN vsResult1 := vsResult1 || 'pn' || INITCAP(psColumnName) || chr(10);
          ELSE
            vsResult1 := vsResult1 || 'p?' || INITCAP(psColumnName) || chr(10);
        END CASE;
    END CASE;

    vsResult1 := vsResult1 || vs_Displacement || 'WHERE t.Id = pnId' || chr(10);
    vsResult1 := vsResult1 || vs_Displacement || ';' || chr(10);
    DecDisplacement;
    vsResult1 := vsResult1 || vs_Displacement || 'END Set' || INITCAP(psColumnName) || ';' || chr(10);

    RETURN(vsResult1);

  END Create_Setter;

  FUNCTION Create_Table_Script(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS
    vsResult         CLOB;
    vn_Cnt           PLS_INTEGER;
    vn_Cnt2          PLS_INTEGER;
  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    -- Add comments
    vsResult := vs_Displacement || '-- Create new table ' || vTableParamSet.FullTableName;
    IF (vTableParamSet.TableComment IS NOT NULL) THEN
      vsResult := vsResult || ' (' || vTableParamSet.TableComment || ')';
    END IF;
    vsResult := vsResult || chr(10);

    -- Create script DECLARE part
    vsResult := vsResult || vs_Displacement || 'DECLARE' || chr(10);
    IncDisplacement;
    vsResult := vsResult || vs_Displacement || 'vs_DDL VARCHAR2(2000);' || chr(10);
    vsResult := vsResult || vs_Displacement || 'vn_Cnt PLS_INTEGER;' || chr(10);
    DecDisplacement;
    -- Create script body
    vsResult := vsResult || vs_Displacement || 'BEGIN' || chr(10);
    IncDisplacement;
    vsResult := vsResult || vs_Displacement || '-- Verify existing' || chr(10);
    vsResult := vsResult || vs_Displacement || 'SELECT COUNT(*) INTO vn_Cnt' || chr(10);
    vsResult := vsResult || vs_Displacement || 'FROM   sys.all_tables t' || chr(10);
    vsResult := vsResult || vs_Displacement || 'WHERE  t.owner = ''' || vTableParamSet.Owner || '''' || chr(10);
    vsResult := vsResult || vs_Displacement || '  AND  t.table_name = ''' || UPPER(psTableName) || ''';' || chr(10);
    vsResult := vsResult || vs_Displacement || chr(10);
    vsResult := vsResult || vs_Displacement || 'IF (vn_Cnt = 0) THEN' || chr(10);
    IncDisplacement;
    vsResult := vsResult || vs_Displacement || '-- Creating table' || chr(10);
    vsResult := vsResult || vs_Displacement || 'dbms_output.put_line(''Creating ' || vTableParamSet.FullTableName || ' table'');' || chr(10);
    vsResult := vsResult || vs_Displacement || 'vs_DDL := ''CREATE TABLE ' || vTableParamSet.FullTableName || '(' || chr(10);
    IncDisplacement;
    vn_Cnt := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      vn_Cnt := vn_Cnt + 1;
      IF (vn_Cnt <> 1) THEN
        vsResult := vsResult || vs_Displacement || ',' || RPAD(i.column_name, vTableParamSet.MaxColNameLength + 1, ' ') || i.data_type;
      ELSE
        vsResult := vsResult || vs_Displacement || ' ' || RPAD(i.column_name, vTableParamSet.MaxColNameLength + 1, ' ') || i.data_type;
      END IF;

      IF (i.data_length <> Default_Data_Length(i.data_type)) THEN
        vsResult := vsResult || '(' || i.data_length || ')';
      END IF;

      -- ToDo: i.data_precision & i.data_scale
      IF (i.data_default IS NOT NULL) THEN
        vsResult := vsResult || ' DEFAULT ' || REPLACE(i.data_default, '''', '''''');
      END IF;

      IF (i.nullable = 'N') THEN
        vsResult := vsResult || ' NOT NULL';
      END IF;

      vsResult := vsResult || chr(10);
    END LOOP;
    DecDisplacement;
    vsResult := vsResult || vs_Displacement || ')'';' || chr(10);

    vsResult := vsResult || vs_Displacement || 'EXECUTE IMMEDIATE (vs_DDL);' || chr(10);

    -- Add comments to the table
    IF (vTableParamSet.TableComment IS NOT NULL) THEN
      vsResult := vsResult || vs_Displacement || '-- Add comments to the table' || chr(10);
      vsResult := vsResult || vs_Displacement || 'vs_DDL := ''COMMENT ON TABLE ' || vTableParamSet.FullTableName || ' IS ''''' || REPLACE(vTableParamSet.TableComment, '''', '''''') || ''''''';' || chr(10);
      vsResult := vsResult || vs_Displacement || 'EXECUTE IMMEDIATE (vs_DDL);' || chr(10);
    END IF;

    -- Add comments to the columns
    vn_Cnt := 0;
    FOR i IN AllTabColumns(vTableParamSet.Owner, psTableName) LOOP
      vn_Cnt := vn_Cnt + 1;
      IF (vn_Cnt = 1) THEN
        vsResult := vsResult || vs_Displacement || '-- Add comments to the columns' || chr(10);
      END IF;
      vsResult := vsResult || vs_Displacement || 'vs_DDL := ''COMMENT ON COLUMN ' || vTableParamSet.FullTableName || '.' || i.column_name;
      vsResult := vsResult || ' IS ''''' || REPLACE(i.comments, '''', '''''''''') || ''''''';' || chr(10);
      vsResult := vsResult || vs_Displacement || 'EXECUTE IMMEDIATE (vs_DDL);' || chr(10);
    END LOOP;

    -- Create/Recreate primary, unique and foreign key constraints
    -- 1) Primary keys
    vn_Cnt := 0;
    FOR i IN AllConstraints(vTableParamSet.Owner, psTableName, 'P') LOOP
      vn_Cnt := vn_Cnt + 1;
      IF (vn_Cnt = 1) THEN
        vsResult := vsResult || vs_Displacement || '-- Create/Recreate primary key constraint' || chr(10);
      END IF;
      vsResult := vsResult || vs_Displacement || 'vs_DDL := ''ALTER TABLE ' || vTableParamSet.FullTableName || chr(10);
      vsResult := vsResult || vs_Displacement || 'ADD CONSTRAINT ' || i.constraint_name;
      vsResult := vsResult || ' PRIMARY KEY (';
      vn_Cnt2 := 0;
      FOR j IN AllConstraintCols(i.owner, i.table_name, i.constraint_name) LOOP
        vn_Cnt2 := vn_Cnt2 + 1;
        IF (vn_Cnt2 != 1) THEN
          vsResult := vsResult || ', ' || j.column_name;
        ELSE
          vsResult := vsResult || j.column_name;
        END IF;
      END LOOP;
      vsResult := vsResult || ')'';' || chr(10);
      vsResult := vsResult || vs_Displacement || 'EXECUTE IMMEDIATE (vs_DDL);' || chr(10);
    END LOOP;
    -- 2) Unique keys
    vn_Cnt := 0;
    FOR i IN AllConstraints(vTableParamSet.Owner, psTableName, 'U') LOOP
      vn_Cnt := vn_Cnt + 1;
      IF (vn_Cnt = 1) THEN
        vsResult := vsResult || vs_Displacement || '-- Create/Recreate unique key constraints' || chr(10);
      END IF;
      vsResult := vsResult || vs_Displacement || 'vs_DDL := ''ALTER TABLE ' || vTableParamSet.FullTableName || chr(10);
      vsResult := vsResult || vs_Displacement || 'ADD CONSTRAINT ' || i.constraint_name;
      vsResult := vsResult || ' UNIQUE (';
      vn_Cnt2 := 0;
      FOR j IN AllConstraintCols(i.owner, i.table_name, i.constraint_name) LOOP
        vn_Cnt2 := vn_Cnt2 + 1;
        IF (vn_Cnt2 != 1) THEN
          vsResult := vsResult || ', ' || j.column_name;
        ELSE
          vsResult := vsResult || j.column_name;
        END IF;
      END LOOP;
      vsResult := vsResult || ')'';' || chr(10);
      vsResult := vsResult || vs_Displacement || 'EXECUTE IMMEDIATE (vs_DDL);' || chr(10);
    END LOOP;
    -- 3) Foreign keys
    vn_Cnt := 0;
    FOR i IN AllConstraints(vTableParamSet.Owner, psTableName, 'R') LOOP
      vn_Cnt := vn_Cnt + 1;
      IF (vn_Cnt = 1) THEN
        vsResult := vsResult || vs_Displacement || '-- Create/Recreate foreign key constraints' || chr(10);
      END IF;
      vsResult := vsResult || vs_Displacement || 'vs_DDL := ''ALTER TABLE ' || vTableParamSet.FullTableName || chr(10);
      vsResult := vsResult || vs_Displacement || 'ADD CONSTRAINT ' || i.constraint_name;
      vsResult := vsResult || ' FOREIGN KEY (';
      vn_Cnt2 := 0;
      FOR j IN AllConstraintCols(i.owner, i.table_name, i.constraint_name) LOOP
        vn_Cnt2 := vn_Cnt2 + 1;
        IF (vn_Cnt2 != 1) THEN
          vsResult := vsResult || ',' || j.column_name;
        ELSE
          vsResult := vsResult || ' ' || j.column_name;
        END IF;
      END LOOP;
      vsResult := vsResult || ') REFERENCES ';
      vn_Cnt2 := 0;
      FOR j IN AllConstraintCols(i.r_owner, NULL, i.r_constraint_name) LOOP
        vn_Cnt2 := vn_Cnt2 + 1;
        IF (vn_Cnt2 = 1) THEN
          vsResult := vsResult || j.owner || '.' || j.table_name ||' (';
        END IF;
        vsResult := vsResult || j.column_name;
        IF (vn_Cnt2 != 1) THEN
          vsResult := vsResult || ', ';
        ELSE
          vsResult := vsResult || ' ';
        END IF;
      END LOOP;
      vsResult := vsResult || ')'';' || chr(10);
      vsResult := vsResult || vs_Displacement || 'EXECUTE IMMEDIATE (vs_DDL);' || chr(10);
    END LOOP;

    -- Create/Recreate check constraints
    vn_Cnt := 0;
    FOR i IN AllChecks(vTableParamSet.Owner, psTableName) LOOP
      vn_Cnt := vn_Cnt + 1;
      IF (vn_Cnt = 1) THEN
        vsResult := vsResult || vs_Displacement || '-- Create/Recreate check constraints' || chr(10);
      END IF;
      vsResult := vsResult || vs_Displacement || 'vs_DDL := ''ALTER TABLE ' || vTableParamSet.FullTableName || chr(10);
      vsResult := vsResult || vs_Displacement || 'ADD CONSTRAINT ' || i.constraint_name;
      vsResult := vsResult || vs_Displacement || ' CHECK (' || REPLACE(i.search_condition, '''', '''''');
      vsResult := vsResult || vs_Displacement || ')'';' || chr(10);
      vsResult := vsResult || vs_Displacement || 'EXECUTE IMMEDIATE (vs_DDL);' || chr(10);
    END LOOP;

    -- Create/Recreate indexes
    vsResult := vsResult || Create_Index_Script(vTableParamSet.Owner, psTableName, NULL, TRUE);
    DecDisplacement;
    vsResult := vsResult || vs_Displacement || 'ELSE' || chr(10);
    IncDisplacement;
    vsResult := vsResult || vs_Displacement || 'dbms_output.put_line(''Warning! Table ' || vTableParamSet.FullTableName || ' already exists. Skipped.'');' || chr(10);
    DecDisplacement;
    vsResult := vsResult || vs_Displacement || 'END IF;' || chr(10);
    vsResult := vsResult || vs_Displacement || chr(10);
    DecDisplacement;
    vsResult := vsResult || vs_Displacement || 'END;' || chr(10);

    RETURN(vsResult);
  END Create_Table_Script;

  FUNCTION Create_Index_Script(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psIndexName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS
    vsResult         CLOB;

    vn_Cnt           PLS_INTEGER;
    vn_Cnt2          PLS_INTEGER;
  BEGIN

    IF (pbPackageMode = FALSE OR pbPackageMode IS NULL) THEN
      vSolutionParamSet := Get_SolutionParamSet(psOwner);
      vTableParamSet    := AnalyzeTable(psOwner, psTableName);
    END IF;

    -- Create/Recreate indexes
    vn_Cnt := 0;
    FOR i IN AllIndexes(vTableParamSet.Owner, psTableName, psIndexName) LOOP
      -- Skip auto generated indexes
      SELECT COUNT(*) INTO vn_Cnt2
      FROM   sys.all_constraints t
      WHERE  t.owner = vTableParamSet.Owner
      AND    t.table_name = UPPER(psTableName)
      AND    t.index_name = i.index_name;

      IF (vn_Cnt2 = 0) THEN

        vn_Cnt := vn_Cnt + 1;

        IF (vn_Cnt = 1) THEN
          vsResult := vsResult || vs_Displacement || '-- Create/Recreate indexes' || chr(10);
          vsResult := vsResult || vs_Displacement || 'DECLARE' || chr(10);
          IncDisplacement;
          vsResult := vsResult || vs_Displacement || 'vs_DDL VARCHAR2(2000);' || chr(10);
          vsResult := vsResult || vs_Displacement || 'vn_Cnt PLS_INTEGER;' || chr(10);
          DecDisplacement;
          vsResult := vsResult || vs_Displacement || 'BEGIN' || chr(10);
          IncDisplacement;
          vsResult := vsResult || vs_Displacement || 'IF USER != ''' || USER || ''' THEN' || chr(10);
          IncDisplacement;
          vsResult := vsResult || vs_Displacement || '    raise_application_error(-20000,' || chr(10);
          vsResult := vsResult || vs_Displacement || '                           ''Error! This script must be run under ' || USER || ' user!'');' || chr(10);
          DecDisplacement;
          vsResult := vsResult || vs_Displacement || 'END IF;' || chr(10) || chr(10);
        END IF;

        -- Add verify existings block
        vsResult := vsResult || vs_Displacement || '-- Verify existing' || chr(10);
        vsResult := vsResult || vs_Displacement || 'SELECT COUNT(i.index_name)' || chr(10);
        vsResult := vsResult || vs_Displacement || 'INTO   vn_Cnt' || chr(10);
        vsResult := vsResult || vs_Displacement || 'FROM   sys.user_indexes i' || chr(10);
        vsResult := vsResult || vs_Displacement || 'WHERE  i.table_owner = ''' || vTableParamSet.Owner || '''' || chr(10);
        vsResult := vsResult || vs_Displacement || '  AND  i.table_name = ''' || psTableName || '''' || chr(10);

        IF (psIndexName IS NOT NULL) THEN
          vsResult := vsResult || vs_Displacement || '  AND  i.index_name = ''' || UPPER(psIndexName) || '''' || chr(10);
        END IF;
        vsResult := vsResult || vs_Displacement || '  AND  1 = 1;' || chr(10);

        -- Add create index block
        vsResult := vsResult || vs_Displacement || 'IF (vn_Cnt = 0) THEN' || chr(10);
        IncDisplacement;
        vsResult := vsResult || vs_Displacement || 'dbms_output.put_line(''Creating index ' || i.INDEX_NAME || ' on ' || i.TABLE_OWNER || '.' || i.TABLE_NAME || ' table'');' || chr(10);
        IF (i.index_type IN ('BITMAP')) THEN
          vsResult := vsResult || vs_Displacement || 'vs_DDL := ''CREATE ' || i.index_type || ' INDEX ';
        ELSE
          vsResult := vsResult || vs_Displacement || 'vs_DDL := ''CREATE INDEX ';
        END IF;
        vsResult := vsResult || i.index_name || ' ON ' || vTableParamSet.FullTableName || ' (';
        vn_Cnt2 := 0;
        FOR j IN AllIndColumns(vTableParamSet.Owner, psTableName, i.index_name) LOOP
          vn_Cnt2 := vn_Cnt2 + 1;
          vsResult := vsResult || j.column_name;
          IF (vn_Cnt2 != 1) THEN
            vsResult := vsResult || ', ';
          ELSE
            vsResult := vsResult || ' ';
          END IF;
        END LOOP;

        vsResult := vsResult || vs_Displacement || ')'';' || chr(10);
        IncDisplacement;
        vsResult := vsResult || vs_Displacement || 'EXECUTE IMMEDIATE (vs_DDL);' || chr(10);
        DecDisplacement;
        vsResult := vsResult || vs_Displacement || 'ELSE' || chr(10);
        IncDisplacement;
        vsResult := vsResult || vs_Displacement || 'dbms_output.put_line(''Warning! Index ' || i.INDEX_NAME || ' already exists. Skipped.'');' || chr(10);
        DecDisplacement;
        vsResult := vsResult || vs_Displacement || 'END IF;' || chr(10) || chr(10);

      END IF;

    END LOOP;
    DecDisplacement;
    vsResult := vsResult || vs_Displacement || chr(10);
    vsResult := vsResult || vs_Displacement || 'END;' || chr(10);

    RETURN(vsResult);
  END Create_Index_Script;

  FUNCTION Default_Data_Length(
     psDataType IN VARCHAR2
  ) RETURN PLS_INTEGER IS
  BEGIN
    IF (UPPER(psDataType) = 'NUMBER') THEN
      RETURN (22);
    ELSIF (UPPER(psDataType) = 'DATE') THEN
      RETURN (7);
    ELSIF (UPPER(psDataType) = 'CLOB') THEN
      RETURN (4000);
    END IF;
    RETURN (-1);
  END Default_Data_Length;

  FUNCTION Get_Class(
     psOwner  IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2
  ) RETURN BASE.Class%ROWTYPE IS
    vnClass BASE.Class%ROWTYPE;
  BEGIN
    BEGIN
      SELECT t.* INTO vnClass
      FROM   BASE.Class t
      WHERE  t.Owner_Name = NVL(UPPER(psOwner), t.Owner_Name)
      AND    t.Table_Name = UPPER(psTableName)
      ;
    EXCEPTION
      WHEN OTHERS
        THEN NULL;
    END;
    RETURN (vnClass);
  END Get_Class;

  FUNCTION Get_Property_Id(
     pnClassId     IN BASE.Class.Id%TYPE
    ,psColumnName  IN VARCHAR2
  ) RETURN BASE.Property.Id%TYPE IS
    vnPropertyId BASE.Property.Id%TYPE;
  BEGIN
    BEGIN
      SELECT t.Id INTO vnPropertyId
      FROM   BASE.Property t
      WHERE  t.Class = pnClassId
      AND    t.RefColumn = psColumnName
      ;
    EXCEPTION
      WHEN OTHERS
        THEN vnPropertyId := NULL;
    END;
    RETURN (vnPropertyId);
  END Get_Property_Id;

  FUNCTION Get_Column_Count(
     p_owner  IN VARCHAR2 DEFAULT NULL
    ,p_table  IN VARCHAR2 DEFAULT NULL
    ,p_column IN VARCHAR2 DEFAULT NULL
  ) RETURN PLS_INTEGER IS
    vn_Cnt PLS_INTEGER;
  BEGIN
    SELECT COUNT(*) INTO vn_Cnt
    FROM   sys.all_tab_columns t
    WHERE  t.owner = NVL(UPPER(p_owner), t.owner)
    AND    t.table_name = NVL(UPPER(p_table), t.table_name)
    AND    t.column_name = NVL(UPPER(p_column), t.column_name);
    RETURN (vn_Cnt);
  END Get_Column_Count;

  FUNCTION Get_Constraint_Count(
     p_owner           IN VARCHAR2 DEFAULT NULL
    ,p_table           IN VARCHAR2 DEFAULT NULL
    ,p_constraint_name IN VARCHAR2 DEFAULT NULL
    ,p_constraint_type IN VARCHAR2 DEFAULT NULL
  ) RETURN PLS_INTEGER IS
    vn_Cnt PLS_INTEGER;
  BEGIN
    SELECT COUNT(*) INTO vn_Cnt
    FROM   sys.all_constraints t
    WHERE  t.owner = NVL(UPPER(p_owner), t.owner)
    AND    t.table_name = NVL(UPPER(p_table), t.table_name)
    AND    t.constraint_name = NVL(UPPER(p_constraint_name), t.constraint_name)
    AND    t.constraint_type = NVL(UPPER(p_constraint_type), t.constraint_type);
    RETURN (vn_Cnt);
  END Get_Constraint_Count;

  FUNCTION Get_Index_Count(
     psOwner      IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2 DEFAULT NULL
    ,psIndexName  IN VARCHAR2 DEFAULT NULL
    ,psIndexType  IN VARCHAR2 DEFAULT NULL
    ,psUniqueness IN VARCHAR2 DEFAULT NULL
  ) RETURN PLS_INTEGER IS
    vn_Cnt PLS_INTEGER;
  BEGIN
    SELECT
       COUNT(*)
    INTO
       vn_Cnt
    FROM
       sys.all_indexes c
    WHERE c.table_owner = NVL(UPPER(psOwner), c.owner)
      AND c.table_name = NVL(UPPER(psTableName), c.table_name)
      AND c.index_name = NVL(UPPER(psIndexName), c.index_name)
      AND c.index_type = NVL(UPPER(psIndexType), c.index_type)
      AND c.uniqueness = NVL(UPPER(psUniqueness), c.uniqueness)
    ;
    RETURN (vn_Cnt);
  END Get_Index_Count;

  FUNCTION Get_FullTableName(
     psOwner      IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2
  ) RETURN VARCHAR2 IS
    vsResult VARCHAR2(255);
  BEGIN
    BEGIN
      SELECT
         t.owner || '.' || t.table_name
      INTO
         vsResult
      FROM
         sys.all_tables t
      WHERE t.owner = NVL(UPPER(psOwner), t.owner)
        AND t.table_name = UPPER(psTableName)
      ;
    EXCEPTION
      WHEN OTHERS
        THEN NULL;
    END;

    RETURN (vsResult);
  END Get_FullTableName;

  FUNCTION Get_MaxColNameLength(
     psOwner     IN VARCHAR2 DEFAULT NULL
    ,psTableName IN VARCHAR2 DEFAULT NULL
  ) RETURN PLS_INTEGER IS
    nResult PLS_INTEGER;
  BEGIN
    SELECT
       MAX(length(t.column_name))
    INTO
       nResult
    FROM
       sys.all_tab_columns t
    WHERE t.owner = NVL(UPPER(psOwner), t.owner)
      AND t.table_name = NVL(UPPER(psTableName), t.table_name);
    RETURN (nResult);
  END Get_MaxColNameLength;

  FUNCTION Get_DescriptionFlag(
     psOwner     IN VARCHAR2 DEFAULT NULL
    ,psTableName IN VARCHAR2 DEFAULT NULL
  ) RETURN PLS_INTEGER IS
    nResult PLS_INTEGER;
  BEGIN
    SELECT
       COUNT(*)
    INTO
       nResult
    FROM
       sys.all_tab_columns t
    WHERE t.owner = NVL(UPPER(psOwner), t.owner)
      AND t.table_name = NVL(UPPER(psTableName), t.table_name)
      AND t.column_name = 'DESCRIPTION';
    RETURN (nResult);
  END Get_DescriptionFlag;

  FUNCTION Get_ColumnComment(
     psOwner      IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2
    ,psColumnName IN VARCHAR2
  ) RETURN VARCHAR2 IS
    vsResult VARCHAR2(4000);
  BEGIN
    BEGIN
      SELECT
         t.comments
      INTO
         vsResult
      FROM
         sys.all_col_comments t
      WHERE t.owner = NVL(UPPER(psOwner), t.owner)
        AND t.table_name = UPPER(psTableName)
        AND t.column_name = UPPER(psColumnName)
      ;
    EXCEPTION
      WHEN OTHERS
        THEN NULL;
    END;

    RETURN (vsResult);
  END Get_ColumnComment;

  FUNCTION Get_ColumnDataType(
     psOwner      IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2
    ,psColumnName IN VARCHAR2
  ) RETURN VARCHAR2 IS
    vsResult VARCHAR2(255);
  BEGIN
    BEGIN
      SELECT
         t.data_type
      INTO
         vsResult
      FROM
         sys.all_tab_columns t
      WHERE t.owner = NVL(UPPER(psOwner), t.owner)
        AND t.table_name = UPPER(psTableName)
        AND t.column_name = UPPER(psColumnName)
      ;
    EXCEPTION
      WHEN OTHERS
        THEN NULL;
    END;

    RETURN (vsResult);
  END Get_ColumnDataType;

  FUNCTION Get_Sequence_Count(
     psOwner         IN VARCHAR2 DEFAULT NULL
    ,psSequenceName  IN VARCHAR2
  ) RETURN PLS_INTEGER IS
    vn_Cnt PLS_INTEGER;
  BEGIN
    SELECT COUNT(*) INTO vn_Cnt
    FROM   sys.all_objects t
    WHERE  t.owner = NVL(UPPER(psOwner), t.owner)
    AND    t.object_name = NVL(UPPER(psSequenceName), t.object_name)
    AND    t.object_type = 'SEQUENCE';
    RETURN (vn_Cnt);
  END Get_Sequence_Count;

  FUNCTION Get_SolutionParamSet(
     psOwner      IN VARCHAR2
  ) RETURN BASE.Solution%ROWTYPE IS
    vsResult BASE.Solution%ROWTYPE;
  BEGIN
    BEGIN
      SELECT
         t.*
      INTO
         vsResult
      FROM
         BASE.Solution t
      WHERE t.schema = UPPER(psOwner)
      ;
    EXCEPTION
      WHEN OTHERS
        THEN NULL;
    END;

    RETURN (vsResult);
  END Get_SolutionParamSet;

  FUNCTION Get_TableComment(
     psOwner      IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2
  ) RETURN VARCHAR2 IS
    vsResult VARCHAR2(4000);
  BEGIN
    BEGIN
      SELECT
         t.comments
      INTO
         vsResult
      FROM
         sys.all_tab_comments t
      WHERE t.owner = NVL(UPPER(psOwner), t.owner)
        AND t.table_name = UPPER(psTableName)
      ;
    EXCEPTION
      WHEN OTHERS
        THEN NULL;
    END;

    RETURN (vsResult);
  END Get_TableComment;

  FUNCTION Get_TableOwner(
     psTableName  IN VARCHAR2
  ) RETURN VARCHAR2 IS
    vsResult VARCHAR2(255);
  BEGIN
    BEGIN
      SELECT
         t.owner
      INTO
         vsResult
      FROM
         sys.all_tables t
      WHERE t.table_name = UPPER(psTableName)
      ;
    EXCEPTION
      WHEN OTHERS
        THEN NULL;
    END;

    RETURN (vsResult);
  END Get_TableOwner;

  PROCEDURE Update_V$VIEWS(
     psOwner           IN VARCHAR2
  ) IS
    vResult CLOB;
  BEGIN
    FOR i IN (SELECT t.owner, t.table_name
              FROM sys.all_tables t
              WHERE t.owner = UPPER(psOwner)
                AND EXISTS (SELECT 1
                            FROM sys.all_tables x
                            WHERE x.owner = t.owner
                              AND x.table_name = t.table_name || '_HIST')
    ) LOOP

      vResult := dev.generators.create_v$view_script(
         psowner => i.owner
        ,pstablename => i.table_name
        ,pbpackagemode => FALSE
      );

      BEGIN
        EXECUTE IMMEDIATE TO_CHAR(vResult);
      EXCEPTION
        WHEN OTHERS
          THEN dbms_output.put_line(i.table_name);
      END;

    END LOOP;

  END Update_V$VIEWS;

  FUNCTION Create_V$VIEW_Script(
     psOwner           IN VARCHAR2 DEFAULT NULL
    ,psTableName       IN VARCHAR2
    ,pbPackageMode     IN BOOLEAN  DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult         CLOB;
    vsTableList      VARCHAR2(1024);

  BEGIN

    IF (pbPackageMode) THEN
      NULL;
    END IF;

    IF (psOwner IS NULL) THEN
      vsTableList := psTableName || ', ' || psTableName || '_hist';
    ELSE
      vsTableList := psOwner || '.' || psTableName || ', ' || psOwner || '.' || psTableName || '_hist';
    END IF;

    vsResult := vsResult || vs_Displacement || 'CREATE OR REPLACE VIEW V$' || UPPER(psTableName) || ' AS' || CHR(10);
    vsResult := vsResult || dev.generators.Create_Union_Table_Script(vsTableList, TRUE, FALSE, TRUE);

    RETURN(vsResult);

  END Create_V$VIEW_Script;

  PROCEDURE FullTableName(
     psTable       IN  VARCHAR2
    ,psTableOwner  OUT VARCHAR2
    ,psTableName   OUT VARCHAR2
  ) IS
  BEGIN
    IF (INSTR(psTable, '.') > 0) THEN
      psTableOwner := UPPER(SUBSTR(psTable, 1, INSTR(psTable, '.') - 1));
      psTableName  := UPPER(SUBSTR(psTable, INSTR(psTable, '.') + 1));
    ELSE
      psTableName := UPPER(psTable);
      SELECT owner INTO psTableOwner
      FROM
        (SELECT t.owner AS owner, rownum AS rc
         FROM sys.all_tables t
         WHERE t.table_name = psTableName
         ORDER BY DECODE(t.owner, USER, 0, 1))
      WHERE rc = 1;
    END IF;
  END FullTableName;

  FUNCTION Create_Union_Table_Script(
     psTableList       IN VARCHAR2
    ,pbUnionAll        IN BOOLEAN  DEFAULT TRUE
    ,pbInnerCol        IN BOOLEAN  DEFAULT TRUE
    ,pbExtResults      IN BOOLEAN  DEFAULT FALSE
    ,pbPackageMode     IN BOOLEAN  DEFAULT FALSE
  ) RETURN CLOB IS

    vsResult         CLOB;
    vsTableList      v255_array;
    vsTableOwners    v255_array;
    vsTableNames     v255_array;
    vsSQL            VARCHAR2(32000);
    vsFromSQL        VARCHAR2(1024);
    vsWhereSQL       VARCHAR2(1024);
    cur              RefCursor;
    vnSourceExists   PLS_INTEGER; -- Source exists in current table
    vnWrhsExists     PLS_INTEGER;
    vnFullSourceCnt  PLS_INTEGER; -- Source exists in all tables
    vsColumnName     VARCHAR2(255);
    k                PLS_INTEGER;
  BEGIN

    IF (pbPackageMode) THEN
      NULL;
    END IF;

    vsTableList := Parse_Separated_List(psTableList, ',');

    FOR i IN 1..vsTableList.count LOOP
      FullTableName(vsTableList(i), vsTableOwners(i), vsTableNames(i));
    END LOOP;

    IF (pbInnerCol) THEN
      vsSQL := '
      SELECT t1.column_name
      FROM sys.all_tab_columns t1
      ';

      FOR i IN 2..vsTableList.count LOOP
        vsFromSQL := vsFromSQL || ',sys.all_tab_columns t' || TO_CHAR(i) || CHR(10);
        vsWhereSQL := vsWhereSQL || 'AND t' || TO_CHAR(i-1) || '.owner = ''' || vsTableOwners(i-1) || '''' || CHR(10);
        vsWhereSQL := vsWhereSQL || 'AND t' || TO_CHAR(i-1) || '.table_name = ''' || vsTableNames(i-1) || '''' || CHR(10);
        vsWhereSQL := vsWhereSQL || 'AND t' || TO_CHAR(i-1) || '.data_type NOT IN (''BLOB'', ''CLOB'', ''NCLOB'', ''LONG'', ''LONG RAW'', ''RAW'')' || CHR(10);
        vsWhereSQL := vsWhereSQL || 'AND t' || TO_CHAR(i) || '.owner = ''' || vsTableOwners(i) || '''' || CHR(10);
        vsWhereSQL := vsWhereSQL || 'AND t' || TO_CHAR(i) || '.table_name = ''' || vsTableNames(i) || '''' || CHR(10);
        vsWhereSQL := vsWhereSQL || 'AND t' || TO_CHAR(i) || '.data_type NOT IN (''BLOB'', ''CLOB'', ''NCLOB'', ''LONG'', ''LONG RAW'', ''RAW'')' || CHR(10);
        vsWhereSQL := vsWhereSQL || 'AND t' || TO_CHAR(i-1) || '.column_name = t' || TO_CHAR(i) || '.column_name' || CHR(10);
      END LOOP;

      vsSQL := vsSQL || vsFromSQL || 'WHERE 1 = 1' || CHR(10) || vsWhereSQL;
    ELSE
      FOR i IN 1..vsTableList.count LOOP
        IF (i > 1) THEN
          vsSQL := vsSQL || 'UNION' || CHR(10);
        END IF;

        vsSQL := vsSQL || 'SELECT t' || TO_CHAR(i) || '.column_name' || CHR(10);
        vsSQL := vsSQL || 'FROM sys.all_tab_columns t' || TO_CHAR(i) || CHR(10);
        vsSQL := vsSQL || 'WHERE t' || TO_CHAR(i) || '.owner = ''' || vsTableOwners(i) || '''' || CHR(10);
        vsSQL := vsSQL || 'AND t' || TO_CHAR(i) || '.table_name = ''' || vsTableNames(i) || '''' || CHR(10);
        vsSQL := vsSQL || 'AND t' || TO_CHAR(i) || '.data_type NOT IN (''BLOB'', ''CLOB'', ''NCLOB'', ''LONG'', ''LONG RAW'', ''RAW'')' || CHR(10);

      END LOOP;

    END IF;

    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM (' || vsSQL || ') WHERE column_name IN (''GLOB_ID'', ''DAT_ID'')' INTO vnFullSourceCnt;

    FOR i IN 1..vsTableList.count LOOP
      vTableParamSet := AnalyzeTable(vsTableOwners(i), vsTableNames(i));

      IF (i > 1 AND pbUnionAll) THEN
        DecDisplacement;
        vsResult := vsResult || vs_Displacement || 'UNION ALL' || CHR(10);
        vsResult := vsResult || vs_Displacement || 'SELECT' || CHR(10);
      ELSIF (i > 1) THEN
        DecDisplacement;
        vsResult := vsResult || vs_Displacement || 'UNION' || CHR(10);
        vsResult := vsResult || vs_Displacement || 'SELECT' || CHR(10);
      ELSE
        vsResult := vsResult || vs_Displacement || 'SELECT' || CHR(10);
      END IF;

      IncDisplacement;
      k := 0;
      IF (pbExtResults) THEN
        SELECT COUNT(*) INTO vnSourceExists
         FROM sys.all_tab_columns t
         WHERE t.owner = vsTableOwners(i)
           AND t.table_name = vsTableNames(i)
           AND t.column_name = 'GLOB_ID'
        ;

        SELECT COUNT(*) INTO vnWrhsExists
         FROM sys.all_tab_columns t
         WHERE t.owner = vsTableOwners(i)
           AND t.table_name = vsTableNames(i)
           AND t.column_name = 'DAT_ID'
        ;

        IF (vnSourceExists > 0 OR vnWrhsExists > 0) THEN
          vsResult := vsResult || vs_Displacement || ' s.' || RPAD('source_nm', vTableParamSet.MaxColNameLength + 2, ' ') || 'AS source_nm' || CHR(10);
          k := k + 1;
        ELSIF (vnFullSourceCnt > 0 AND NOT pbInnerCol) THEN
          vsResult := vsResult || vs_Displacement || ' ' || RPAD('NULL', vTableParamSet.MaxColNameLength + 4, ' ') || 'AS source_nm' || CHR(10);
          k := k + 1;
        END IF;
      END IF;

      OPEN cur FOR vsSQL;
      LOOP
        FETCH cur INTO vsColumnName;
        EXIT WHEN cur%NOTFOUND;
        k := k + 1;

        IF (Get_Column_Count(vsTableOwners(i), vsTableNames(i), vsColumnName) > 0) THEN
          IF (k > 1) THEN
            IF (pbExtResults AND vsColumnName = 'UPD_DT') THEN
              vsResult := vsResult || vs_Displacement || ',TO_CHAR(t' || TO_CHAR(i) || '.' || LOWER(vsColumnName) || ', ''YYYYMMDD HH24:MI:SS'') AS ' || LOWER(vsColumnName) || CHR(10);
            ELSE
              vsResult := vsResult || vs_Displacement || ',t' || TO_CHAR(i) || '.' || RPAD(LOWER(vsColumnName), vTableParamSet.MaxColNameLength + 1, ' ') || 'AS ' || LOWER(vsColumnName) || CHR(10);
            END IF;
          ELSE
            IF (pbExtResults AND vsColumnName = 'UPD_DT') THEN
              vsResult := vsResult || vs_Displacement || ' TO_CHAR(t' || TO_CHAR(i) || '.' || LOWER(vsColumnName) || ', ''YYYYMMDD HH24:MI:SS'') AS ' || LOWER(vsColumnName) || CHR(10);
            ELSE
              vsResult := vsResult || vs_Displacement || ' t' || TO_CHAR(i) || '.' || RPAD(LOWER(vsColumnName), vTableParamSet.MaxColNameLength + 1, ' ') || 'AS ' || LOWER(vsColumnName) || CHR(10);
            END IF;
          END IF;
        ELSE
          IF (k > 1) THEN
            vsResult := vsResult || vs_Displacement || RPAD(',NULL', vTableParamSet.MaxColNameLength + 5, ' ') || 'AS ' || LOWER(vsColumnName) || CHR(10);
          ELSE
            vsResult := vsResult || vs_Displacement || RPAD(' NULL', vTableParamSet.MaxColNameLength + 5, ' ') || 'AS ' || LOWER(vsColumnName) || CHR(10);
          END IF;
        END IF;

      END LOOP;

      DecDisplacement;
      vsResult := vsResult || vs_Displacement || 'FROM' || CHR(10);
      IncDisplacement;
      vsResult := vsResult || vs_Displacement || ' ' || LOWER(vTableParamSet.FullTableName) || ' t' || TO_CHAR(i) || CHR(10);

      IF (pbExtResults) THEN
        IF (vnSourceExists > 0) THEN
          vsResult := vsResult || vs_Displacement || ',base.global               s' || CHR(10);
          DecDisplacement;
          vsResult := vsResult || vs_Displacement || 'WHERE t' || TO_CHAR(i) || '.GLOB_ID = s.GLOB_ID(+)' || CHR(10);
          IncDisplacement;
        ELSIF (vnWrhsExists > 0) THEN
          vsResult := vsResult || vs_Displacement || ',base.dat wi' || CHR(10);
          vsResult := vsResult || vs_Displacement || ',base.global               s' || CHR(10);
          DecDisplacement;
          vsResult := vsResult || vs_Displacement || 'WHERE t' || TO_CHAR(i) || '.dat_id = wi.GLOB_ID(+)' || CHR(10);
          IncDisplacement;
          vsResult := vsResult || vs_Displacement || 'AND wi.GLOB_ID = s.GLOB_ID(+)' || CHR(10);
        END IF;
      END IF;
      DecDisplacement;

    END LOOP;

    RETURN(vsResult);

  END Create_Union_Table_Script;

  FUNCTION Parse_Separated_List(
     psSeparatedList IN VARCHAR2
    ,psSeparator     IN VARCHAR2
  ) RETURN v255_array IS
    itms_list v255_array;
    bPos PLS_INTEGER;
    ePos PLS_INTEGER;
    vTmp VARCHAR2(255);
    i    PLS_INTEGER;
  BEGIN
    i := 0;

    LOOP
      i := i + 1;
      IF (i = 1) THEN
        bPos := 1;
      ELSE
        bPos := INSTR(psSeparatedList, psSeparator, 1, i - 1) + 1;
      END IF;

      ePos := NVL(INSTR(psSeparatedList, psSeparator, 1, i), 0) - 1;
      IF (ePos = -1) THEN
        ePos := NVL(LENGTH(psSeparatedList), 0);
      END IF;

      vTmp := TRIM(SUBSTR(psSeparatedList, bPos, ePos - bPos + 1));

      IF (vTmp IS NOT NULL) THEN
        itms_list(itms_list.count + 1) := vTmp;
      END IF;

      EXIT WHEN NVL(INSTR(psSeparatedList, psSeparator, 1, i), 0) = 0;

    END LOOP;

    RETURN (itms_list);

  END Parse_Separated_List;

BEGIN
  vs_Displacement := '';
END Generators;
/
