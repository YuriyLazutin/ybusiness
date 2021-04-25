CREATE OR REPLACE TYPE cSQLQuery AS OBJECT
(
  -- Type for storing SQL queries

  -- User comments (without -- and /**/)
   szPurpose VARCHAR2(32000)
  -- A set of clauses for the SELECT path (without SELECT keyword)
  ,szSelect VARCHAR2(32000) -- ToDo: we need a table type here
  -- A set of clauses for the FROM path (without FROM keyword)
  ,szFrom VARCHAR2(32000) -- ToDo: we need a table type here
  -- A set of clauses for the WHERE path (without WHERE keyword)
  ,szWhere VARCHAR2(32000) -- ToDo: we need a table type here
  -- A set of clauses for the GROUP BY path (without GROUP BY keyword)
  ,szGroupBy VARCHAR2(32000) -- ToDo: we need a table type here
  -- A set of clauses for the HAVING path (without HAVING keyword)
  ,szHaving VARCHAR2(32000) -- ToDo: we need a table type here
  -- A set of clauses for the ORDER BY path (without ORDER BY keyword)
  ,szOrderBy VARCHAR2(32000) -- ToDo: we need a table type here

  -- Member functions and procedures
  ,MEMBER PROCEDURE AddSelectClause(szGetter IN VARCHAR2, szAlias IN VARCHAR2, szComment IN VARCHAR2)
  ,MEMBER PROCEDURE AddWhereClause(szLeftPart IN VARCHAR2, szOperator IN VARCHAR2, szRigthPart IN VARCHAR2, szComment IN VARCHAR2)
)
/
CREATE OR REPLACE TYPE BODY cSQLQuery IS

  -- Member procedures and functions
  MEMBER PROCEDURE AddSelectClause(szGetter IN VARCHAR2, szAlias IN VARCHAR2, szComment IN VARCHAR2) IS
  BEGIN
    NULL;
  END AddSelectClause;

  MEMBER PROCEDURE AddWhereClause(szLeftPart IN VARCHAR2, szOperator IN VARCHAR2, szRigthPart IN VARCHAR2, szComment IN VARCHAR2) IS
  BEGIN
    NULL;
  END AddWhereClause;

END;
/
