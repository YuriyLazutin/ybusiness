CREATE OR REPLACE TYPE cz2DMatrix AS OBJECT
(
  -- The 2D matrix of integer numbers
  -- The cz2DMatrix class is an m*n matrix is a set of numbers arranged
  -- in m rows and n columns. The following illustration shows several matrices.
  --  _       _
  --  | 3 1 4 |      -  2*3 matrix
  --  | 2 5 0 |
  --  -       -
  --  _     _
  --  | 1 3 |
  --  | 2 8 |        -  4*2 matrix
  --  | 0 4 |
  --  | 5 6 |
  --  -     -
  --  _       _
  --  | 1 3 1 |      -  1*3 matrix
  --  -       -
   matrix tIntegerTable2D
  ,m INTEGER  -- number of rows
  ,n INTEGER  -- number of columns
  -- Construct the cz2DMatrix object by default
  ,CONSTRUCTOR FUNCTION cz2DMatrix RETURN SELF AS RESULT
  -- Construct the cz2DMatrix object with dimension
  ,CONSTRUCTOR FUNCTION cz2DMatrix(nRows IN INTEGER, nCols IN INTEGER) RETURN SELF AS RESULT
  -- Copy constructor, specifies a copy of the matrix
  ,CONSTRUCTOR FUNCTION cz2DMatrix(mtx IN cz2DMatrix) RETURN SELF AS RESULT
  -- Get the element of the matrix, that specified (nRow, nCol) position
  ,MEMBER FUNCTION Get(nRow IN INTEGER, nCol IN INTEGER) RETURN INTEGER
  -- Get the row of the matrix, that specified nRow position
  ,MEMBER FUNCTION GetRow(nRow IN INTEGER) RETURN czVector
  -- Get the column of the matrix, that specified nCol position
  ,MEMBER FUNCTION GetCol(nCol IN INTEGER) RETURN czVector
  -- Inserts an element into the matrix at a specified position
  ,MEMBER PROCEDURE Put(nRow IN INTEGER, nCol IN INTEGER, nItm IN INTEGER)
  -- Inserts a row into the matrix at a specified nRow position
  ,MEMBER PROCEDURE PutRow(nRow IN INTEGER, cRow IN czVector)
  -- Inserts a column into the matrix at a specified nCol position
  ,MEMBER PROCEDURE PutCol(nCol IN INTEGER, cCol IN czVector)
  -- Put into all elements 0
  ,MEMBER PROCEDURE Zero

  -- Matrix composition
  -- You can add two matrices of the same size by adding individual elements.
  -- The following illustration shows two examples of matrix addition.
  --  _     _     _       _     _       _
  --  | 5 4 |  +  | 20 30 |  =  | 25 34 |
  --  -     -     -       -     -       -
  --  _     _    _     _     _     _
  --  | 1 0 |    | 2 4 |     | 3 4 |
  --  | 0 2 |  + | 1 5 |  =  | 1 7 |
  --  | 1 3 |    | 0 6 |     | 1 9 |
  --  -     -    -     -     -     -
  ,MEMBER FUNCTION SUM(mtx1 cz2DMatrix, mtx2 cz2DMatrix) RETURN cz2DMatrix
  -- Add other matrix to self
  ,MEMBER PROCEDURE AddToSelf(mtx cz2DMatrix)

  -- Matrix multiplication
  /* An m*n matrix can be multiplied by an n*p matrix, and the result is an m*p matrix.
    The number of columns in the first matrix must be the same as the number of rows in
    the second matrix. For example, a 4*2 matrix can be multiplied by a 2*3 matrix to
    produce a 4*3 matrix.
    Let A(i, j) be the entry in matrix A in the i-th row and the j-th column. For example
    A(3, 2) is the entry in matrix A in the 3rd row and the 2nd column. Suppose A, B,
    and C are matrices, and AB = C. The entries of C are calculated as follows:
    C(i, j) = (row i of A) ? (column j of B)
    The following illustration shows several examples of matrix multiplication.
      _     _   _   _   _    _
      | 2 3 |   | 2 |   | 16 |
      -     - * | 4 | = -    -
                -   -
                  _     _
      _       _   | 1 0 |   _       _
      | 1 3 2 | * | 2 4 | = | 17 14 |
      -       -   | 5 1 |   -       -
                  -     -
      _       _   _       _   _        _
      | 2 5 1 |   | 1 0 0 |   | 4 13 1 |
      | 4 3 1 | * | 0 2 0 | = | 6  9 1 |
      -       -   | 2 3 1 |   -        -
                  -       -
  */
  ,MEMBER FUNCTION Mul(mtx1 cz2DMatrix, mtx2 cz2DMatrix) RETURN cz2DMatrix
  -- Transpose matrix
  ,MEMBER PROCEDURE Transpose
)
/
CREATE OR REPLACE TYPE BODY cz2DMatrix IS

  -- Construct the cz2DMatrix object by default
  CONSTRUCTOR FUNCTION cz2DMatrix RETURN SELF AS RESULT IS
  BEGIN
    m := 0;
    n := 0;
    RETURN;
  END cz2DMatrix; 

  -- Construct the cz2DMatrix object with dimension
  CONSTRUCTOR FUNCTION cz2DMatrix(nRows IN INTEGER, nCols IN INTEGER) RETURN SELF AS RESULT IS
  BEGIN
    m := nRows;
    n := nCols;
    SELF.matrix := tIntegerTable2D(NULL);
    SELF.matrix.EXTEND(nRows - 1);
    FOR i IN 1..nRows LOOP
      SELF.matrix(i) := tIntegerTable(NULL);
      SELF.matrix(i).EXTEND(nCols - 1);
    END LOOP;
    RETURN;
  END cz2DMatrix;

  -- Copy constructor, specifies a copy of the matrix
  CONSTRUCTOR FUNCTION cz2DMatrix(mtx IN cz2DMatrix) RETURN SELF AS RESULT IS
  BEGIN
    SELF.matrix := mtx.matrix;
    SELF.m := mtx.m;
    SELF.n := mtx.n;
    RETURN;
  END cz2DMatrix;

  -- Get the element of the matrix, that specified (nRow, nCol) position
  MEMBER FUNCTION Get(nRow IN INTEGER, nCol IN INTEGER) RETURN INTEGER IS
  BEGIN
    RETURN (matrix(nRow)(nCol));
  END Get;

  -- Get the row of the matrix, that specified nRow position
  MEMBER FUNCTION GetRow(nRow IN INTEGER) RETURN czVector IS
    cRow czVector;
  BEGIN
    cRow := czVector(SELF.n, 0);
    FOR i IN 1..SELF.n LOOP
      cRow.Put(i, matrix(nRow)(i));
    END LOOP;
    RETURN (cRow);
  END GetRow;

  -- Get the column of the matrix, that specified nCol position
  MEMBER FUNCTION GetCol(nCol IN INTEGER) RETURN czVector IS
    cCol czVector;
  BEGIN
    cCol := czVector(SELF.m, 1);
    FOR i IN 1..SELF.m LOOP
      cCol.Put(i, matrix(i)(nCol));
    END LOOP;
    RETURN (cCol);
  END GetCol;

  -- Inserts an element into the matrix at a specified position
  MEMBER PROCEDURE Put(nRow IN INTEGER, nCol IN INTEGER, nItm IN INTEGER) IS
  BEGIN
    matrix(nRow)(nCol) := nItm;
  END Put;

  -- Inserts a row into the matrix at a specified nRow position
  MEMBER PROCEDURE PutRow(nRow IN INTEGER, cRow IN czVector) IS
    k INTEGER;
  BEGIN
    IF (m < cRow.GetSize) THEN
      k := m;
    ELSE
      k := cRow.GetSize;
    END IF;
    --k := minn(m, cRow.GetSize);
    FOR i IN 1..k LOOP
      matrix(nRow)(i) := cRow.Get(i);
    END LOOP;
  END PutRow;

  -- Inserts a column into the matrix at a specified nCol position
  MEMBER PROCEDURE PutCol(nCol IN INTEGER, cCol IN czVector) IS
    k INTEGER;
  BEGIN
    IF (n < cCol.GetSize) THEN
      k := n;
    ELSE
      k := cCol.GetSize;
    END IF;
    --k := minn(n, cCol.GetSize);
    FOR i IN 1..k LOOP
      matrix(i)(nCol) := cCol.Get(i);
    END LOOP;
  END PutCol;

  -- Put into all elements 0
  MEMBER PROCEDURE Zero IS
  BEGIN
    FOR i IN 1..m LOOP
      FOR j IN 1..n LOOP
        matrix(i)(j) := 0;
      END LOOP;
    END LOOP;
  END Zero;

  -- Matrix composition
  -- You can add two matrices of the same size by adding individual elements.
  -- The following illustration shows two examples of matrix addition.
  --  _     _     _       _     _       _
  --  | 5 4 |  +  | 20 30 |  =  | 25 34 |
  --  -     -     -       -     -       -
  --  _     _    _     _     _     _
  --  | 1 0 |    | 2 4 |     | 3 4 |
  --  | 0 2 |  + | 1 5 |  =  | 1 7 |
  --  | 1 3 |    | 0 6 |     | 1 9 |
  --  -     -    -     -     -     -
  MEMBER FUNCTION SUM(mtx1 cz2DMatrix, mtx2 cz2DMatrix) RETURN cz2DMatrix IS
    rc cz2DMatrix;
  BEGIN
    <<Test_dimension>>
    IF (mtx1.m != mtx2.m OR mtx1.n != mtx2.n)  THEN
      RAISE_APPLICATION_ERROR(-20001, 'The dimensions of the matrices do not match.');
    END IF;
    rc := cz2DMatrix(m,n);
    FOR i IN 1..m LOOP
      FOR j IN 1..n LOOP
        rc.Put(i, j, mtx1.Get(i, j) + mtx2.Get(i, j));
      END LOOP;
    END LOOP;
    RETURN rc;
  END SUM;

  -- Add other matrix to self
  MEMBER PROCEDURE AddToSelf(mtx cz2DMatrix) IS
  BEGIN
    <<Test_dimension>>
    IF (SELF.m != mtx.m OR SELF.n != mtx.n)  THEN
      RAISE_APPLICATION_ERROR(-20001, 'The dimensions of the matrices do not match.');
    END IF;
    FOR i IN 1..m LOOP
      FOR j IN 1..n LOOP
        SELF.Put(i, j, SELF.Get(i, j) + mtx.Get(i, j));
      END LOOP;
    END LOOP;
  END AddToSelf;

  -- Matrix multiplication
  /* An m*n matrix can be multiplied by an n*p matrix, and the result is an m*p matrix.
    The number of columns in the first matrix must be the same as the number of rows in
    the second matrix. For example, a 4*2 matrix can be multiplied by a 2*3 matrix to
    produce a 4*3 matrix.
    Let A(i, j) be the entry in matrix A in the i-th row and the j-th column. For example
    A(3, 2) is the entry in matrix A in the 3rd row and the 2nd column. Suppose A, B,
    and C are matrices, and AB = C. The entries of C are calculated as follows:
    C(i, j) = (row i of A) ? (column j of B)
    The following illustration shows several examples of matrix multiplication.
      _     _   _   _   _    _
      | 2 3 |   | 2 |   | 16 |
      -     - * | 4 | = -    -
                -   -
                  _     _
      _       _   | 1 0 |   _       _
      | 1 3 2 | * | 2 4 | = | 17 14 |
      -       -   | 5 1 |   -       -
                  -     -
      _       _   _       _   _        _
      | 2 5 1 |   | 1 0 0 |   | 4 13 1 |
      | 4 3 1 | * | 0 2 0 | = | 6  9 1 |
      -       -   | 2 3 1 |   -        -
                  -       -
  */
  MEMBER FUNCTION Mul(mtx1 cz2DMatrix, mtx2 cz2DMatrix) RETURN cz2DMatrix IS
    mtxRC cz2DMatrix;
    nTmp INTEGER;
  BEGIN
    <<Test_dimension>>
    IF (mtx1.n != mtx2.m)  THEN
      RAISE_APPLICATION_ERROR(-20001, 'Wrong matrix dimensions.');
    END IF;
    mtxRC := cz2DMatrix(mtx1.m, mtx2.n);
    <<Loop_for_rows_mtx1>>
    FOR i IN 1..mtx1.m LOOP
      <<Loop_for_cols_mtx2>>
      FOR j IN 1..mtx2.n LOOP
        nTmp := 0;
        <<Loop_for_components>>
        FOR k IN 1..mtx1.n LOOP
          nTmp := nTmp + mtx1.Get(i, k) * mtx2.Get(k, j);
        END LOOP Loop_for_components;
        mtxRC.Put(i, j, nTmp);
      END LOOP Loop_for_cols_mtx2;
    END LOOP Loop_for_rows_mtx1;
    RETURN (mtxRC);
  END Mul;

  -- Transpose matrix
  MEMBER PROCEDURE Transpose IS
    mtx cz2DMatrix;
  BEGIN
    mtx := cz2DMatrix(SELF.n,SELF.m);
    FOR i IN 1..SELF.m LOOP
      FOR j IN 1..SELF.n LOOP
        mtx.Put(j, i, SELF.Get(i, j));
      END LOOP;
    END LOOP;
    SELF.matrix := mtx.matrix;
    SELF.m := mtx.m;
    SELF.n := mtx.n;
  END Transpose;

END;
/
