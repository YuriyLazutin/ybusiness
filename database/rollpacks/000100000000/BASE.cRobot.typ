CREATE OR REPLACE TYPE cRobot AS OBJECT
(
  -- The base class for robots
   TaskList tIntegerTable
  -- Default constructor
  ,CONSTRUCTOR FUNCTION cRobot RETURN SELF AS RESULT
  -- Copy constructor
  ,CONSTRUCTOR FUNCTION cRobot(x IN cRobot) RETURN SELF AS RESULT
  -- Run robot
  ,MEMBER PROCEDURE Run
  -- Perform the task
  ,MEMBER PROCEDURE PerformTask(nItm IN INTEGER)
  -- Check Jobs In TaskLists
  ,MEMBER FUNCTION IsEmpty RETURN BOOLEAN
  -- ,MEMBER FUNCTION Top RETURN INTEGER
  -- ,MEMBER FUNCTION GetSize RETURN INTEGER
)
/
CREATE OR REPLACE TYPE BODY cRobot IS

  -- Default constructor
  CONSTRUCTOR FUNCTION cRobot RETURN SELF AS RESULT IS
  BEGIN
    RETURN;
  END cRobot;

  -- Copy constructor
  CONSTRUCTOR FUNCTION cRobot(x IN cRobot) RETURN SELF AS RESULT IS
  BEGIN
    SELF.TaskList := x.TaskList;
    RETURN;
  END cRobot;

  -- Run robot
  MEMBER PROCEDURE Run IS
  BEGIN
    NULL;
  END Run;

  -- Perform the task
  MEMBER PROCEDURE PerformTask(nItm IN INTEGER) IS
  BEGIN
    NULL;
  END PerformTask;

  -- Check Jobs In TaskLists
  MEMBER FUNCTION IsEmpty RETURN BOOLEAN IS
  BEGIN
    RETURN NOT TaskList.EXISTS(1);
  END IsEmpty;

END;
/
