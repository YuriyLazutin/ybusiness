CREATE OR REPLACE VIEW class_properties AS
SELECT
   -- This view presents a registered class properties
   c.id          AS class_id
  ,c.name        AS class_name
  ,p.id          AS property_id
  ,p.name        AS property_name
  ,t.id          AS property_type_id
  ,t.name        AS property_type
FROM
   base.class c
  ,base.property p
  ,base.class t
WHERE c.id = p.class
  AND NVL(p.type, -1) = t.id(+)
ORDER BY c.name, p.id
;

CREATE OR REPLACE VIEW table_to_object AS
SELECT
   -- This view presents tables, columns and corresponding classes and properties
   x.table_owner      AS table_owner
  ,x.table_name       AS table_name
  ,x.column_name      AS column_name
  ,x.data_type        AS data_type
  ,x.class_id         AS class_id
  ,x.class_name       AS class_name
  ,p.id               AS property_id
  ,p.name             AS property_name
FROM
   (SELECT
       t.owner          AS table_owner
      ,t.table_name     AS table_name
      ,c.column_id      AS column_id
      ,c.column_name    AS column_name
      ,c.data_type      AS data_type
      ,cl.id            AS class_id
      ,cl.name          AS class_name
    FROM
       sys.all_tables t
      ,sys.all_tab_columns c
      ,base.class cl
    WHERE t.owner = c.owner
      AND t.table_name = c.table_name
      AND t.owner = cl.owner_name(+)
      AND t.table_name = cl.table_name(+)
   ) x
  ,base.property p
WHERE x.class_id = p.class(+)
  AND x.column_name = p.refcolumn(+)
ORDER BY x.table_owner, x.table_name, x.column_id
;

CREATE OR REPLACE VIEW unregistered_classes AS
SELECT
-- This view presents the tables for which no one class was registered
-- In column class_name is shown prospective class name (which was got from table comment)
   t.owner          AS table_owner
  ,t.table_name     AS table_name
  ,NULL             AS class_id
  ,tc.comments      AS class_name
FROM
   sys.all_tables t
  ,sys.all_tab_comments tc
WHERE t.owner = tc.owner(+)
  AND t.table_name = tc.table_name(+)
  AND tc.table_type (+)= 'TABLE'
  AND NOT EXISTS (SELECT 1
                  FROM base.class c
                  WHERE c.owner_name = t.owner
                    AND c.table_name = t.table_name
                 )
ORDER BY t.owner, t.table_name
;
CREATE OR REPLACE VIEW unregistered_properties AS
SELECT
-- This view presents the table columns for which no one class property was registered
-- In column property_name is shown prospective property name (which was got from column comment)
   t.owner          AS table_owner
  ,t.table_name     AS table_name
  ,c.column_name    AS column_name
  ,c.data_type      AS data_type
  ,cl.id            AS class_id
  ,cl.name          AS class_name
  ,NULL             AS property_id
  ,cc.comments      AS property_name
FROM
   sys.all_tables t
  ,sys.all_tab_columns c
  ,sys.all_col_comments cc
  ,base.class cl
WHERE t.owner = c.owner
  AND t.table_name = c.table_name
  AND c.column_name <> 'ID'
  AND c.owner = cc.owner(+)
  AND c.table_name = cc.table_name(+)
  AND c.column_name = cc.column_name(+)
  AND t.owner = cl.owner_name(+)
  AND t.table_name = cl.table_name(+)
  AND NOT EXISTS (SELECT 1
                  FROM base.property p
                  WHERE p.class = NVL(cl.id, -1)
                    AND p.refcolumn = c.column_name
                 )
ORDER BY t.owner, t.table_name, c.column_id
;
