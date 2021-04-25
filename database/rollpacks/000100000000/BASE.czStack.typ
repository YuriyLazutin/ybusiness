CREATE OR REPLACE TYPE czStack AS OBJECT
(
  -- The stack of integer numbers (Z - is the set of integer numbers)
  stack tIntegerTable
  -- Default constructor
  ,CONSTRUCTOR FUNCTION czStack RETURN SELF AS RESULT
  -- Copy constructor
  ,CONSTRUCTOR FUNCTION czStack(s IN czStack) RETURN SELF AS RESULT
  -- Adds an element to the top of the stack
  ,MEMBER PROCEDURE Push(nItm IN INTEGER)
  -- Removes the element from the top of the stack
  ,MEMBER PROCEDURE Pop(nItm OUT INTEGER)
  -- Returns an element at the top of the stack
  ,MEMBER FUNCTION Top RETURN INTEGER
  -- Tests if the stack is empty
  ,MEMBER FUNCTION IsEmpty RETURN BOOLEAN
  -- Returns the number of elements in the stack
  ,MEMBER FUNCTION GetSize RETURN INTEGER
)
/
CREATE OR REPLACE TYPE BODY czStack IS

  -- Default constructor
  CONSTRUCTOR FUNCTION czStack RETURN SELF AS RESULT IS
  BEGIN
    RETURN;
  END czStack;

  -- Copy constructor
  CONSTRUCTOR FUNCTION czStack(s IN czStack) RETURN SELF AS RESULT IS
  BEGIN
    SELF.stack := s.stack;
    RETURN;
  END czStack;

  -- Adds an element to the top of the stack
  MEMBER PROCEDURE Push(nItm IN INTEGER) IS
  BEGIN
    IF (IsEmpty()) THEN
     stack := tIntegerTable(NULL);
     stack(1) := nItm;
     RETURN;
    END IF;    
    stack.EXTEND;
    stack(stack.COUNT) := nItm;    
  END Push;

  -- Removes the element from the top of the stack
  MEMBER PROCEDURE Pop(nItm OUT INTEGER) IS
  BEGIN
    IF (IsEmpty()) THEN 
      nItm := NULL;
    ELSE
      nItm := stack(stack.COUNT);
      stack.TRIM;
    END IF;
  END Pop;

  -- Returns an element at the top of the stack
  MEMBER FUNCTION Top RETURN INTEGER IS
  BEGIN
    IF (IsEmpty()) THEN 
      RETURN NULL;
    END IF;
    RETURN stack(stack.COUNT);
  END Top;

  -- Tests if the stack is empty
  MEMBER FUNCTION IsEmpty RETURN BOOLEAN IS
  BEGIN
    RETURN NOT stack.EXISTS(1);
  END IsEmpty;

  -- Returns the number of elements in the stack
  MEMBER FUNCTION GetSize RETURN INTEGER IS
  BEGIN
    IF IsEmpty THEN RETURN 0; ELSE
    RETURN stack.COUNT;
    END IF;
  END GetSize;

END;
/
