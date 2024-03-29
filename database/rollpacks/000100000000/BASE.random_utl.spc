CREATE OR REPLACE PACKAGE random_utl
AS
   FUNCTION rand RETURN PLS_INTEGER;
   PRAGMA RESTRICT_REFERENCES(rand,WNDS,RNDS,WNPS,RNPS);

   PROCEDURE srand (seed IN PLS_INTEGER);
   PRAGMA RESTRICT_REFERENCES(srand,WNDS,RNDS,WNPS,RNPS);
END random_utl;
/
