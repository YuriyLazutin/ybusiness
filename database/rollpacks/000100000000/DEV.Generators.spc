CREATE OR REPLACE PACKAGE Generators IS

  -- Anchors
  -- /*+GENERATOR(New setter)*/ New setter for class property.
  -- /*+GENERATOR(New getter)*/ New getter for class property.

  -- Cursors
  CURSOR AllTables(psOwner IN VARCHAR2, psTableName IN VARCHAR2) IS
    SELECT t.*
    FROM   sys.all_tables t
    WHERE  t.owner = NVL(UPPER(psOwner), t.owner)
    AND    t.table_name = NVL(UPPER(psTableName), t.table_name);

  CURSOR AllTabColumns(
     psOwner     IN VARCHAR2
    ,psTableName IN VARCHAR2
  ) IS
    SELECT 
       t.*
      ,cmt.comments
    FROM   sys.all_tab_columns t, sys.all_col_comments cmt
    WHERE  t.owner = NVL(UPPER(psOwner), t.owner)
      AND  t.table_name = NVL(UPPER(psTableName), t.table_name)
      AND  t.owner = cmt.owner(+)
      AND  t.table_name = cmt.table_name(+)
      AND  t.column_name = cmt.column_name(+)
    ORDER BY DECODE(t.column_name, 'ID', 0, t.column_id)
  ;

  CURSOR AllConstraints(
     psOwner          IN VARCHAR2 DEFAULT NULL
    ,psTableName      IN VARCHAR2 DEFAULT NULL
    ,psConstraintType IN CHAR     DEFAULT NULL
  ) IS
    SELECT t.*
    FROM   sys.all_constraints t
    WHERE  t.owner = NVL(UPPER(psOwner), t.owner)
      AND  t.table_name = NVL(UPPER(psTableName), t.table_name)
      AND  t.constraint_type = NVL(UPPER(psConstraintType), t.constraint_type)
    ORDER  BY decode(t.constraint_type, 'P', 0, 'U', 1, 'R', 2, 3), constraint_name
  ;

  CURSOR AllConstraintCols(
     psOwner          IN VARCHAR2 DEFAULT NULL
    ,psTableName      IN VARCHAR2 DEFAULT NULL
    ,psConstraintName IN VARCHAR2 DEFAULT NULL
    ,psConstraintType IN VARCHAR2 DEFAULT NULL
  ) IS
    SELECT 
       z.*
    FROM
       sys.all_constraints  x
      ,sys.all_cons_columns y
      ,sys.all_tab_columns  z
    WHERE  x.owner = NVL(psOwner, x.owner)
      AND  x.table_name = NVL(psTableName, x.table_name)
      AND  x.constraint_name = NVL(UPPER(psConstraintName), x.constraint_name)
      AND  x.constraint_type = NVL(UPPER(psConstraintType), x.constraint_type)
      AND  y.owner = x.owner
      AND  y.table_name = x.table_name
      AND  y.constraint_name = x.constraint_name
      AND  z.owner = x.owner
      AND  z.table_name = x.table_name
      AND  z.column_name = y.column_name
    ORDER  BY y.position
  ;

  CURSOR AllIndexes(
     psTableOwner IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2 DEFAULT NULL
    ,psIndexName  IN VARCHAR2 DEFAULT NULL
    ,psIndexType  IN VARCHAR2 DEFAULT NULL
    ,psUniqueness IN VARCHAR2 DEFAULT NULL
  ) IS
    SELECT t.*
    FROM   sys.all_indexes t
    WHERE  t.table_owner = NVL(UPPER(psTableOwner), t.table_owner)
      AND  t.table_name = NVL(UPPER(psTableName), t.table_name)
      AND  t.index_name = NVL(UPPER(psIndexName), t.index_name)
      AND  t.index_type = NVL(UPPER(psIndexType), t.index_type)
      AND  t.uniqueness = NVL(UPPER(psUniqueness), t.uniqueness)
    ORDER  BY t.index_name
  ;

  CURSOR AllIndColumns(
     psOwner     IN VARCHAR2
    ,psTableName IN VARCHAR2
    ,psIndexName IN VARCHAR2
  ) IS
    SELECT
       t.index_owner
      ,t.index_name
      ,z.*
      ,cmt.comments
    FROM
       sys.all_ind_columns  t
      ,sys.all_tab_columns  z
      ,sys.all_col_comments cmt
    WHERE  t.table_owner = NVL(UPPER(psOwner), t.table_owner)
      AND  t.table_name = NVL(UPPER(psTableName), t.table_name)
      AND  t.index_name = NVL(UPPER(psIndexName), t.index_name)
      AND  t.table_owner = z.owner
      AND  t.table_name = z.table_name
      AND  t.column_name = z.column_name
      AND  z.owner = cmt.owner(+)
      AND  z.table_name = cmt.table_name(+)
      AND  z.column_name = cmt.column_name(+)
    ORDER  BY t.index_name, t.column_position
  ;

  CURSOR AllChecks(psOwner IN VARCHAR2, psTableName IN VARCHAR2) IS
    SELECT t.*
    FROM   sys.all_constraints t
    WHERE  t.owner = NVL(UPPER(psOwner), t.owner)
    AND    t.table_name = NVL(UPPER(psTableName), t.table_name)
    AND    t.constraint_type = 'C'
    AND    t.generated = 'USER NAME'
    ORDER  BY constraint_name;

  -- Types
  TYPE RefCursor  IS REF CURSOR;
  TYPE v255_array IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;

  TYPE TableParamSet IS RECORD
  (
     FullTableName      VARCHAR2(255)              -- Table name in format OWNER.TABLE_NAME
    ,Owner              VARCHAR2(255)              -- Table owner
    ,TableComment       VARCHAR2(4000)             -- Table comment
    ,Col_Cnt            PLS_INTEGER                -- Columns count
    ,PK_Cnt             PLS_INTEGER                -- Primary keys count
    ,UK_Cnt             PLS_INTEGER                -- Unique keys count
    ,CHK_Cnt            PLS_INTEGER                -- Check constraints count
    ,IX_Cnt             PLS_INTEGER                -- Indexes count
    ,UIX_Cnt            PLS_INTEGER                -- Unique indexex count
    ,MaxColNameLength   PLS_INTEGER                -- Length of longest column name
    ,DescriptionFlag    PLS_INTEGER                -- Flag, determines if description exists
    ,Class              BASE.Class%ROWTYPE         -- Class
  );

  TYPE ColumnParamSet IS RECORD
  (
     FullColumnName     VARCHAR2(255)           -- Column name in format OWNER.TABLE_NAME.COLUMN_NAME
    ,ColumnComment      VARCHAR2(4000)          -- Column comment
    ,DataType           VARCHAR2(255)           -- Column data type
    ,PropertyId         BASE.Property.Id%TYPE   -- Id of property
    ,PropertyName       BASE.Property.Name%TYPE -- Name of property
  );

  -- Public constant declarations

  -- Public variable declarations
  vSolutionParamSet  BASE.Solution%ROWTYPE;
  vTableParamSet     TableParamSet;
  vColumnParamSet    ColumnParamSet;
  vs_Displacement    VARCHAR2(1024);

  -- Public function and procedure declarations
  PROCEDURE AddClass(
     psClassName        IN  VARCHAR2
    ,psOwner            IN  VARCHAR2
    ,psTableName        IN  VARCHAR2
    ,psInterfacePackage IN  VARCHAR2 DEFAULT NULL
    ,psDescription      IN  VARCHAR2 DEFAULT NULL
    ,pbPackageMode      IN  BOOLEAN  DEFAULT FALSE
  );

  FUNCTION  AnalyzeColumn(
     psOwner      IN VARCHAR2
    ,psTableName  IN VARCHAR2
    ,psColumnName IN VARCHAR2
  ) RETURN ColumnParamSet;

  FUNCTION AnalyzeTable(
     psOwner IN VARCHAR2
    ,psTableName IN VARCHAR2
  ) RETURN TableParamSet;

  FUNCTION Create_Interface_Package(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psPackageName IN VARCHAR2 DEFAULT NULL
  ) RETURN CLOB;

  FUNCTION Create_Interface_Specification(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psPackageName IN VARCHAR2 DEFAULT NULL
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_Interface_Realization(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psPackageName IN VARCHAR2 DEFAULT NULL
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_AddRow_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_AddRow(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_GetRow_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_GetRow(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_Getter_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psColumnName  IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_Getter(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psColumnName  IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_GetSet_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_GetSet(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_DelRow_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_DelRow(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_Ind_Getter_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psIndexName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_Ind_Getter(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psIndexName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_LockRow_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_LockRow(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  PROCEDURE Create_Class_Sequence(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  );

  FUNCTION Create_SetRow_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_SetRow(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_Setter_Spc(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psColumnName  IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_Setter(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psColumnName  IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_Table_Script(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Create_Index_Script(
     psOwner       IN VARCHAR2 DEFAULT NULL
    ,psTableName   IN VARCHAR2
    ,psIndexName   IN VARCHAR2
    ,pbPackageMode IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Default_Data_Length(
     psDataType IN VARCHAR2
  ) RETURN PLS_INTEGER;

  FUNCTION Get_Class(
     psOwner  IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2
  ) RETURN BASE.Class%ROWTYPE;

  FUNCTION Get_Property_Id(
     pnClassId     IN BASE.Class.Id%TYPE
    ,psColumnName  IN VARCHAR2
  ) RETURN BASE.Property.Id%TYPE;

  FUNCTION Get_Column_Count(
     p_owner  IN VARCHAR2 DEFAULT NULL
    ,p_table  IN VARCHAR2 DEFAULT NULL
    ,p_column IN VARCHAR2 DEFAULT NULL
  ) RETURN PLS_INTEGER;

  FUNCTION Get_Constraint_Count(
     p_owner           IN VARCHAR2 DEFAULT NULL
    ,p_table           IN VARCHAR2 DEFAULT NULL
    ,p_constraint_name IN VARCHAR2 DEFAULT NULL
    ,p_constraint_type IN VARCHAR2 DEFAULT NULL
  ) RETURN PLS_INTEGER;

  FUNCTION Get_Index_Count(
     psOwner      IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2 DEFAULT NULL
    ,psIndexName  IN VARCHAR2 DEFAULT NULL
    ,psIndexType  IN VARCHAR2 DEFAULT NULL
    ,psUniqueness IN VARCHAR2 DEFAULT NULL
  ) RETURN PLS_INTEGER;

  FUNCTION Get_FullTableName(
     psOwner      IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2
  ) RETURN VARCHAR2;

  FUNCTION Get_MaxColNameLength(
     psOwner     IN VARCHAR2 DEFAULT NULL
    ,psTableName IN VARCHAR2 DEFAULT NULL
  ) RETURN PLS_INTEGER;

  FUNCTION Get_DescriptionFlag(
     psOwner     IN VARCHAR2 DEFAULT NULL
    ,psTableName IN VARCHAR2 DEFAULT NULL
  ) RETURN PLS_INTEGER;

  FUNCTION Get_ColumnComment(
     psOwner      IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2
    ,psColumnName IN VARCHAR2
  ) RETURN VARCHAR2;

  FUNCTION Get_ColumnDataType(
     psOwner      IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2
    ,psColumnName IN VARCHAR2
  ) RETURN VARCHAR2;

  FUNCTION Get_Sequence_Count(
     psOwner         IN VARCHAR2 DEFAULT NULL
    ,psSequenceName  IN VARCHAR2
  ) RETURN PLS_INTEGER;

  FUNCTION Get_SolutionParamSet(
     psOwner      IN VARCHAR2
  ) RETURN BASE.Solution%ROWTYPE;

  FUNCTION Get_TableComment(
     psOwner      IN VARCHAR2 DEFAULT NULL
    ,psTableName  IN VARCHAR2
  ) RETURN VARCHAR2;

  FUNCTION Get_TableOwner(
     psTableName  IN VARCHAR2
  ) RETURN VARCHAR2;

  PROCEDURE Update_V$VIEWS(
     psOwner           IN VARCHAR2
  );

  FUNCTION Create_V$VIEW_Script(
     psOwner           IN VARCHAR2 DEFAULT NULL
    ,psTableName       IN VARCHAR2
    ,pbPackageMode     IN BOOLEAN  DEFAULT FALSE
  ) RETURN CLOB;

  PROCEDURE FullTableName(
     psTable       IN  VARCHAR2
    ,psTableOwner  OUT VARCHAR2
    ,psTableName   OUT VARCHAR2
  );

  FUNCTION Create_Union_Table_Script(
     psTableList       IN VARCHAR2
    ,pbUnionAll        IN BOOLEAN  DEFAULT TRUE
    ,pbInnerCol        IN BOOLEAN  DEFAULT TRUE
    ,pbExtResults      IN BOOLEAN  DEFAULT FALSE
    ,pbPackageMode     IN BOOLEAN  DEFAULT FALSE
  ) RETURN CLOB;

  FUNCTION Parse_Separated_List(
     psSeparatedList IN VARCHAR2
    ,psSeparator     IN VARCHAR2
  ) RETURN v255_array;

END Generators;
/
