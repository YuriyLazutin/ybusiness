CREATE OR REPLACE TYPE tIntegerTable IS TABLE OF INTEGER
/
CREATE OR REPLACE TYPE tIntegerTable2D IS TABLE OF tIntegerTable
/
CREATE OR REPLACE TYPE tIntegerTable3D IS TABLE OF tIntegerTable2D
/