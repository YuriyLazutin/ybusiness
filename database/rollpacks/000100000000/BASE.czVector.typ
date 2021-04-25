CREATE OR REPLACE TYPE czVector AS OBJECT
(
  -- The vector of integer numbers (Z - is the set of integer numbers)
  -- The czVector class is a class of sequence containers that arrange elements
  -- of an integer type in a linear arrangement and allow fast random access
  -- to any element
  vector tIntegerTable
  -- Type of vector orientation (0 - row vector, 1 - column vector, ... z - vector)
  ,orientation INTEGER
  -- Construct the czVector object
  ,CONSTRUCTOR FUNCTION czVector(nSize IN INTEGER) RETURN SELF AS RESULT
  -- Construct the czVector object with orientation
  ,CONSTRUCTOR FUNCTION czVector(nSize IN INTEGER, nOrientation IN INTEGER) RETURN SELF AS RESULT
  -- Copy constructor, specifies a copy of the vector
  ,CONSTRUCTOR FUNCTION czVector(v IN czVector) RETURN SELF AS RESULT
  -- Tests if the vector container is empty
  ,MEMBER FUNCTION IsEmpty RETURN BOOLEAN
  -- Returns the number of elements in the vector
  ,MEMBER FUNCTION GetSize RETURN INTEGER
  -- Get the element of the vector, that specified nPos position
  ,MEMBER FUNCTION Get(nPos IN INTEGER) RETURN INTEGER
  -- Inserts an element into the vector at a specified position
  ,MEMBER PROCEDURE Put(nPos IN INTEGER, nItm IN INTEGER)
  -- Erases the elements of the vector
  ,MEMBER PROCEDURE Clear(nPos IN INTEGER)
  -- Erases a range of elements in a vector from specified positions including borders
  ,MEMBER PROCEDURE Clear(nPosBegin IN INTEGER, nPosEnd IN INTEGER)
  -- Removes an element or a range of elements in a vector from specified positions including borders
  ,MEMBER PROCEDURE Erase(nPos IN INTEGER)
  ,MEMBER PROCEDURE Erase(nPosBegin IN INTEGER, nPosEnd IN INTEGER)
  -- Specifies a new size for a vector
  ,MEMBER PROCEDURE ReSize(nSize IN NUMBER)
  -- Swing vector on 1 dimensions
  ,MEMBER PROCEDURE Swing
  -- Swing vector on nDim dimensions (if nDim = 1 or nDim = -1 we have transposition)
  ,MEMBER PROCEDURE Swing(nDim IN INTEGER)
  /*Points in the plane and rows and columns of a matrix can be thought of as vectors.
    For example, (2, 5) is a vector with two components, and (3, 7, 1) is a vector with
    three components. The dot product of two vectors is defined as follows:
      (a, b) * (c, d) = a*c + b*d
      (a, b, c) * (d, e, f) = a*d + b*e + c*f
    For example, the dot product of (2, 3) and (5, 4) is (2)*(5) + (3)*(4) = 22.
    The dot product of (2, 5, 1) and (4, 3, 1) is (2)*(4) + (5)*(3) + (1)*(1) = 24.
    Note that the dot product of two vectors is a number, not another vector. Also note
    that you can calculate the dot product only if the two vectors have the same number
    of components and same orientation.*/
  ,MEMBER FUNCTION DotProduct(v1 IN czVector, v2 IN czVector) RETURN INTEGER
)
/
CREATE OR REPLACE TYPE BODY czVector IS

  -- Construct the czVector object
  CONSTRUCTOR FUNCTION czVector(nSize IN INTEGER) RETURN SELF AS RESULT IS
  BEGIN
    IF (nSize) > 1 THEN
      vector := tIntegerTable(NULL);
      vector.EXTEND(nSize - 1);
    END IF;
    orientation := 0;
    RETURN;
  END czVector;

  -- Construct the czVector object with orientation
  CONSTRUCTOR FUNCTION czVector(nSize IN INTEGER, nOrientation IN INTEGER) RETURN SELF AS RESULT IS
  BEGIN
    IF (nSize) > 1 THEN
      vector := tIntegerTable(NULL);
      vector.EXTEND(nSize - 1);
    END IF;
    orientation := nOrientation;
    RETURN;
  END czVector;

  -- Copy constructor, specifies a copy of the vector
  CONSTRUCTOR FUNCTION czVector(v IN czVector) RETURN SELF AS RESULT IS
  BEGIN
    SELF.vector := v.vector;
    SELF.orientation := v.orientation;
    RETURN;
  END czVector;

  -- Tests if the vector container is empty
  MEMBER FUNCTION IsEmpty RETURN BOOLEAN IS
  BEGIN
    RETURN NOT vector.EXISTS(1);
  END IsEmpty;

  -- Returns the number of elements in the vector
  MEMBER FUNCTION GetSize RETURN INTEGER IS
  BEGIN
    IF IsEmpty THEN
      RETURN 0;
    ELSE
      RETURN vector.COUNT;
    END IF;
  END GetSize;

  -- Get the element of the vector, that specified nPos position
  MEMBER FUNCTION Get(nPos IN INTEGER) RETURN INTEGER IS
  BEGIN
    RETURN vector(nPos);
  END Get;

  -- Inserts an element into the vector at a specified position
  MEMBER PROCEDURE Put(nPos IN INTEGER, nItm IN INTEGER) IS
  BEGIN
    vector(nPos) := nItm;
  END Put;

  -- Erases the elements of the vector
  MEMBER PROCEDURE Clear(nPos IN INTEGER) IS
  BEGIN
    vector(nPos) := NULL;
  END Clear;

  -- Erases a range of elements in a vector from specified positions including borders
  MEMBER PROCEDURE Clear(nPosBegin IN INTEGER, nPosEnd IN INTEGER) IS
  BEGIN
    FOR i IN nPosBegin..nPosEnd LOOP
      vector(i) := NULL;
    END LOOP;
  END Clear;

  -- Removes an element in a vector from specified position
  MEMBER PROCEDURE Erase(nPos IN INTEGER) IS
  BEGIN
    FOR i IN nPos..vector.COUNT-1 LOOP
      vector(i) := vector(i + 1);
    END LOOP;
    vector(vector.COUNT) := NULL;
  END Erase;

  -- Removes a range of elements in a vector from specified positions including borders
  MEMBER PROCEDURE Erase(nPosBegin IN INTEGER, nPosEnd IN INTEGER) IS
  BEGIN
    FOR i IN nPosEnd..vector.COUNT-1 LOOP
      vector(i - nPosEnd + nPosBegin) := vector(i + 1);
    END LOOP;
    FOR i IN (vector.COUNT - nPosEnd + nPosBegin)..vector.COUNT LOOP
      vector(i) := NULL;
    END LOOP;
  END Erase;

  -- Specifies a new size for a vector
  MEMBER PROCEDURE ReSize(nSize IN NUMBER) IS
    i PLS_INTEGER DEFAULT 0;
  BEGIN
    IF (nSize > vector.COUNT) THEN
      vector.EXTEND(nSize - vector.COUNT);
    ELSE
      i := vector.COUNT;
      vector.DELETE(nSize + 1, i);
      vector.TRIM(i - (nSize + 1));
    END IF;
  END ReSize;

  -- Swing vector on 1 dimensions
  MEMBER PROCEDURE Swing IS
  BEGIN
    orientation := orientation + 1;
  END Swing;

  -- Swing vector on nDim dimensions (if nDim = 1 or nDim = -1 we have transposition)
  MEMBER PROCEDURE Swing(nDim IN INTEGER) IS
  BEGIN
    orientation := orientation + nDim;
    IF (orientation < 0) THEN
      orientation := 0;
    END IF;
  END Swing;

  /*Points in the plane and rows and columns of a matrix can be thought of as vectors.
    For example, (2, 5) is a vector with two components, and (3, 7, 1) is a vector with
    three components. The dot product of two vectors is defined as follows:
      (a, b) * (c, d) = a*c + b*d
      (a, b, c) * (d, e, f) = a*d + b*e + c*f
    For example, the dot product of (2, 3) and (5, 4) is (2)*(5) + (3)*(4) = 22.
    The dot product of (2, 5, 1) and (4, 3, 1) is (2)*(4) + (5)*(3) + (1)*(1) = 24.
    Note that the dot product of two vectors is a number, not another vector. Also note
    that you can calculate the dot product only if the two vectors have the same number
    of components and same orientation.*/
  MEMBER FUNCTION DotProduct(v1 IN czVector, v2 IN czVector) RETURN INTEGER IS
    rc INTEGER DEFAULT 0;
  BEGIN
    <<Test_size>>
    IF (v1.GetSize != v2.GetSize) THEN
      RAISE_APPLICATION_ERROR(-20001, 'The dimensions of the vectors do not match.');
    END IF;
    <<Test_orientation>>
    IF (v1.orientation != v2.orientation) THEN
      RAISE_APPLICATION_ERROR(-20001, 'The orientation of the vectors do not match.');
    END IF;
    FOR i IN 1..v1.GetSize LOOP
      rc := rc + v1.Get(i)*v2.Get(i);
    END LOOP;
    RETURN (rc);
  END DotProduct;

END;
/
