CREATE OR REPLACE PACKAGE BODY math_utl IS

  -- Finding the value of the argument of a function 1 unknown by the method of linear interpolation
  -- y = F(x)
  FUNCTION LinearInterpolation(
    -- function (example '12 + 14* :x - 35* power(1.1, :x)')
     F          IN VARCHAR2
    ,Precision  IN PLS_INTEGER
  ) RETURN NUMBER IS
    result NUMBER;
  BEGIN
    -- ToDo:
    return (result);
  END LinearInterpolation;

END math_utl;
/
