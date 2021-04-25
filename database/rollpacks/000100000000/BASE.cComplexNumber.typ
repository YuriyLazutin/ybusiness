CREATE OR REPLACE TYPE cComplexNumber AS OBJECT
(
  -- The complex number
   RealPart      NUMBER
  ,ImaginaryPart NUMBER
  -- Default constructor
  ,CONSTRUCTOR FUNCTION cComplexNumber RETURN SELF AS RESULT
  -- Constructor with values
  ,CONSTRUCTOR FUNCTION cComplexNumber(r IN NUMBER, i IN NUMBER) RETURN SELF AS RESULT
  -- Copy constructor
  ,CONSTRUCTOR FUNCTION cComplexNumber(n IN cComplexNumber) RETURN SELF AS RESULT
)
/
CREATE OR REPLACE TYPE BODY cComplexNumber IS

  -- Default constructor
  CONSTRUCTOR FUNCTION cComplexNumber RETURN SELF AS RESULT IS
  BEGIN
    RETURN;
  END cComplexNumber;

  -- Constructor with values
  CONSTRUCTOR FUNCTION cComplexNumber(r IN NUMBER, i IN NUMBER) RETURN SELF AS RESULT IS
  BEGIN
    RealPart := r;
    ImaginaryPart := i;
    RETURN;
  END cComplexNumber;

  -- Copy constructor
  CONSTRUCTOR FUNCTION cComplexNumber(n IN cComplexNumber) RETURN SELF AS RESULT IS
  BEGIN
    SELF.RealPart := n.RealPart;
    SELF.ImaginaryPart := n.ImaginaryPart;
    RETURN;
  END cComplexNumber;

END;
/
