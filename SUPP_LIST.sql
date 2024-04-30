SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE NUM_ORD_TOT_AMT AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
    PROCEDURE GEN_REPORT;


END NUM_ORD_TOT_AMT;
/


CREATE OR REPLACE PACKAGE BODY NUM_ORD_TOT_AMT AS

PROCEDURE GEN_REPORT
IS
        v_header1               varchar2(200);
      

        cursor c3 is
                SELECT SUPP.SUPPLIER_NAME, (SUPP.FIRST_NAME || ' ' || SUPP.LAST_NAME) SUPP_CONTACT_NAME,
regexp_replace(lpad(SUPP.TEL_NUMBER,7,'0'),'(.{3})(.{4})','\1-\2') TEL_NUMBER
, regexp_replace(lpad(SUPP.MOBILE_NUMBER,8,'0'),'(.{4})(.{4})','\1-\2') MOBILE_NUMBER,
COUNT(ORD.SUPPLIER_NAME) TOT_ORD, SUM(ORD.ORDER_TOTAL_AMOUNT) ORD_TOT_AMT
FROM XXBCM_SUPPLIER_TBL SUPP,
XXBCM_ORDER_TBL ORD
WHERE SUPP.SUPPLIER_NAME = ORD.SUPPLIER_NAME
AND ORD.ORDER_DATE BETWEEN '01-JAN-22' AND '31-AUG-2022'
GROUP BY SUPP.SUPPLIER_NAME, SUPP.FIRST_NAME, SUPP.LAST_NAME,
SUPP.TEL_NUMBER, SUPP.MOBILE_NUMBER;


begin

        v_header1 :=
                'Number of orders and total amount ordered between the period of 01 January 2022 and 31 August 2022';
        
        DBMS_OUTPUT.PUT_LINE(v_header1); 

        for k in c3 loop    
              DBMS_OUTPUT.PUT_LINE('Supplier Name : '|| K.SUPPLIER_NAME	);
              DBMS_OUTPUT.PUT_LINE('Supplier Contact Name : '|| K.SUPP_CONTACT_NAME );
              DBMS_OUTPUT.PUT_LINE('Supplier Contact No. 1 : '||  K.TEL_NUMBER);
              DBMS_OUTPUT.PUT_LINE('Supplier Contact No. 2 : '||  K.MOBILE_NUMBER);
              DBMS_OUTPUT.PUT_LINE('Total Orders : '||   K.TOT_ORD);
               DBMS_OUTPUT.PUT_LINE('Order Total Amount : ' || TO_CHAR(K.ORD_TOT_AMT,'FM9G999G999G999G990D00'));
          

        end loop;       


END GEN_REPORT;

END NUM_ORD_TOT_AMT;
/

--exec NUM_ORD_TOT_AMT.GEN_REPORT;