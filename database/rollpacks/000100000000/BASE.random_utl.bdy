CREATE OR REPLACE PACKAGE BODY random_utl
AS
   FUNCTION rand RETURN PLS_INTEGER
   IS
      LANGUAGE C      -- Language of routine.
      NAME "rand"     -- Function name in the
      LIBRARY libc_l; -- The library created above.

   PROCEDURE srand (seed IN PLS_INTEGER)
   IS
      LANGUAGE C
      NAME "srand"   -- Name is lowercase in this
      LIBRARY libc_l
      PARAMETERS (seed ub4); --Map to unsigned INT
END random_utl;
/
