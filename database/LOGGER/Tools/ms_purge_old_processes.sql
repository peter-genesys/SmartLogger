delete from ms_process where created_date < TRUNC(SYSDATE) - 1;
delete from ms_internal_error where time_now < TRUNC(SYSDATE) - 1;
delete from ms_large_message where time_now < TRUNC(SYSDATE) - 1;