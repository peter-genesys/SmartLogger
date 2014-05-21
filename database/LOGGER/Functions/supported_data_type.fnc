  --------------------------------------------------------------------
  -- supported_data_type
  --------------------------------------------------------------------
  create or replace function supported_data_type(i_data_type IN VARCHAR2 ) RETURN VARCHAR2 IS
  BEGIN   
    IF i_data_type IN ('NUMBER'
	                  ,'INTEGER'
	   			      ,'BINARY_INTEGER'
	   			      ,'PLS_INTEGER'
	   			      ,'DATE'
       			      ,'VARCHAR2'
       			      ,'BOOLEAN') then
      RETURN 'Y';
	ELSE
      RETURN 'N';
	END IF;  
  
  END;
  /