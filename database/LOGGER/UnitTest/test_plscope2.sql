ALTER SESSION SET plscope_settings='identifiers:all, statements:all';


CREATE TABLE species_locations 
( 
   id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
   location   VARCHAR2 (100) UNIQUE 
);


CREATE TABLE endangered_species
(
   id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   name          VARCHAR2 (100) UNIQUE,
   location_id   NUMBER    REFERENCES species_locations (id)
);


CREATE TABLE research_locations
(
   id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   name          VARCHAR2 (100) UNIQUE,
   location_id   NUMBER    REFERENCES species_locations (id)
);


CREATE OR REPLACE PACKAGE species_mgr
   AUTHID DEFINER
IS
   FUNCTION location_id_from_name (
      location_in   IN species_locations.location%TYPE)
      RETURN species_locations.id%TYPE;
END;
/

CREATE OR REPLACE PACKAGE BODY species_mgr
IS
   FUNCTION location_id_from_name (
      location_in   IN species_locations.location%TYPE)
      RETURN species_locations.id%TYPE
   IS
      l_return   species_locations.id%TYPE;
   BEGIN
      SELECT sl.id
        INTO l_return
        FROM species_locations sl
       WHERE sl.location = location_id_from_name.location_in;

      RETURN l_return;
   END;
END;
/


BEGIN 
   /* Amazon Data */ 
 
   INSERT INTO species_locations (location) 
        VALUES ('Amazon'); 
 
   INSERT INTO endangered_species (name, location_id) 
           VALUES ( 
                     'Black Spider Monkey', 
                     species_mgr.location_id_from_name ('Amazon')); 
 
   INSERT INTO endangered_species (name, location_id) 
        VALUES ('Sloth', species_mgr.location_id_from_name ('Amazon')); 
 
   INSERT INTO endangered_species (name, location_id) 
           VALUES ( 
                     'Amazon River Dolphin', 
                     species_mgr.location_id_from_name ('Amazon')); 
 
   INSERT INTO endangered_species (name, location_id) 
           VALUES ( 
                     'Poison Dart Frog', 
                     species_mgr.location_id_from_name ('Amazon')); 
 
   INSERT INTO endangered_species (name, location_id) 
        VALUES ('Macaw', species_mgr.location_id_from_name ('Amazon')); 
 
   INSERT INTO endangered_species (name, location_id) 
        VALUES ('Jaguar', species_mgr.location_id_from_name ('Amazon')); 
 
   INSERT INTO research_locations (name, location_id) 
           VALUES ( 
                     'Smithsonian Tropical Research Institute', 
                     species_mgr.location_id_from_name ('Amazon')); 
 
   INSERT INTO research_locations (name, location_id) 
        VALUES ('IBAMA', species_mgr.location_id_from_name ('Amazon')); 
 
   /* Galapagos Data */ 
 
   INSERT INTO species_locations (location) 
        VALUES ('Galapagos'); 
 
   INSERT INTO endangered_species (name, location_id) 
           VALUES ( 
                     'Sea Turtle', 
                     species_mgr.location_id_from_name ('Galapagos')); 
 
   INSERT INTO endangered_species (name, location_id) 
           VALUES ( 
                     'Leatherback Turtle', 
                     species_mgr.location_id_from_name ('Galapagos')); 
 
   INSERT INTO endangered_species (name, location_id) 
        VALUES ('SEI Whale', species_mgr.location_id_from_name ('Galapagos')); 
 
   INSERT INTO endangered_species (name, location_id) 
           VALUES ( 
                     'Green Turtle', 
                     species_mgr.location_id_from_name ('Galapagos')); 
 
   INSERT INTO endangered_species (name, location_id) 
           VALUES ( 
                     'Giant Tortoise', 
                     species_mgr.location_id_from_name ('Galapagos')); 
 
   INSERT INTO endangered_species (name, location_id) 
           VALUES ( 
                     'Galapagos Penguin', 
                     species_mgr.location_id_from_name ('Galapagos')); 
 
   INSERT INTO research_locations (name, location_id) 
           VALUES ( 
                     'Charles Darwin Foundation', 
                     species_mgr.location_id_from_name ('Galapagos')); 
 
   INSERT INTO research_locations (name, location_id) 
           VALUES ( 
                     'Galapagos Science Center', 
                     species_mgr.location_id_from_name ('Galapagos')); 
 
   COMMIT; 
END;
/


CREATE OR REPLACE PROCEDURE add_species (NAME_IN       IN VARCHAR2,
                                         location_in   IN VARCHAR2)
   AUTHID DEFINER
IS
   l_info   VARCHAR2 (32767);
BEGIN
   INSERT INTO endangered_species (name, location_id)
        VALUES (NAME_IN, species_mgr.location_id_from_name (location_in));

   SELECT s.id || '-' || s.name || '-' || l.location
     INTO l_info
     FROM endangered_species s, species_locations l
    WHERE s.location_id = l.id;

   DBMS_OUTPUT.put_line ('Inserted ' || l_info);
END;
/


CREATE OR REPLACE PROCEDURE show_location_info (
   location_id_in   IN species_locations.id%TYPE)
   AUTHID DEFINER
IS
BEGIN
   FOR rec IN (  SELECT r.location_id, r.name
                   FROM research_locations r
                  WHERE r.location_id = show_location_info.location_id_in
               ORDER BY r.name)
   LOOP
      DBMS_OUTPUT.put_line (rec.location_id || '-' || rec.name);
   END LOOP;
END;
/

WITH one_obj_name AS (SELECT 'ADD_SPECIES' object_name FROM DUAL)  
    SELECT plscope_type,  
           usage_id,  
           usage_context_id,  
           LPAD (' ', 2 * (LEVEL - 1)) || usage || ' ' || name usages,  
           line,  
           col  
      FROM (SELECT 'ID' plscope_type,  
                   ai.object_name,  
                   ai.usage usage,  
                   ai.usage_id,  
                   ai.usage_context_id,  
                   ai.TYPE || ' ' || ai.name name,  
                   ai.line,  
                   ai.col  
              FROM user_identifiers ai, one_obj_name  
             WHERE ai.object_name = one_obj_name.object_name  
            UNION ALL  
            SELECT 'ST',  
                   st.object_name,  
                   st.TYPE,  
                   st.usage_id,  
                   st.usage_context_id,  
                   'STATEMENT',  
                   st.line,  
                   st.col  
              FROM user_statements st, one_obj_name  
             WHERE st.object_name = one_obj_name.object_name)  
START WITH usage_context_id = 0  
CONNECT BY PRIOR usage_id = usage_context_id
/


  SELECT ref_ids.object_name,  
         ref_ids.line,  
         ref_ids.name column_referenced,  
         decl_ids.object_name declared_in_table  
    FROM user_identifiers ref_ids, user_identifiers decl_ids  
   WHERE     ref_ids.object_name = 'ADD_SPECIES'  
         AND ref_ids.signature = decl_ids.signature  
         AND decl_ids.usage = 'DECLARATION'  
         AND ref_ids.TYPE = 'COLUMN'  
         AND ref_ids.usage = 'REFERENCE'  
ORDER BY line
/

CREATE OR REPLACE PROCEDURE show_column_usages (table_in    IN VARCHAR2,  
                                                column_in   IN VARCHAR2)  
   AUTHID DEFINER  
IS  
BEGIN  
   DBMS_OUTPUT.put_line (  
      'References to ' || table_in || '.' || column_in);  
   DBMS_OUTPUT.put_line ('');  
  
   FOR rec  
      IN (  SELECT idt.line, idt.object_name code_unit,  
                   RTRIM (src.text, CHR (10)) text  
              FROM user_identifiers idt, user_source src  
             WHERE     idt.usage = 'REFERENCE'  
                   AND idt.signature =  
                          (SELECT idt_inner.signature  
                             FROM user_identifiers idt_inner  
                            WHERE     idt_inner.object_name =  
                                         show_column_usages.table_in  
                                  AND idt_inner.TYPE = 'COLUMN'  
                                  AND idt_inner.name =  
                                         show_column_usages.column_in  
                                  AND idt_inner.usage = 'DECLARATION')  
                   AND idt.line = src.line  
                   AND idt.object_name = src.name  
          ORDER BY code_unit, line)  
   LOOP  
      DBMS_OUTPUT.put_line (  
         'In ' || rec.code_unit || ' on ' || rec.line || ': ' || rec.text);  
   END LOOP;  
END; 
/

BEGIN 
   show_column_usages (table_in    => 'ENDANGERED_SPECIES', 
                       column_in   => 'LOCATION_ID'); 
END;
/


