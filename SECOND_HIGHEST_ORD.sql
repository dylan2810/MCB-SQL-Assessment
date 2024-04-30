SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE Second_highest_ord AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
    PROCEDURE GEN_REPORT;


END Second_highest_ord;
/


CREATE OR REPLACE PACKAGE BODY Second_highest_ord AS

PROCEDURE GEN_REPORT
IS


        V_ORDER_REF      varchar2(300);
        v_header1               varchar2(200);
      

        cursor c3 is
                SELECT ROWNUM, A.* FROM (SELECT REPLACE(ORD.ORDER_REF,'PO') AS ORDER_REF,
ORD.ORDER_DATE AS ORD_PERIOD, ORD.SUPPLIER_NAME AS SUPP_NAME,
SUM(ORD.ORDER_TOTAL_AMOUNT) AS ORD_TOT_AMT,
ORD.ORDER_STATUS AS ORD_STS
FROM XXBCM_ORDER_TBL ORD
GROUP BY REPLACE(ORD.ORDER_REF,'PO'),ORD.ORDER_DATE,
ORD.SUPPLIER_NAME,
ORD.ORDER_STATUS
ORDER BY SUM(ORD.ORDER_TOTAL_AMOUNT) DESC) A
WHERE ROWNUM <= 2
ORDER BY ROWNUM DESC FETCH FIRST ROW ONLY;

CURSOR C4 IS 
SELECT INVOICE_REFERENCE 
FROM XXBCM_INVOICE_TBL
WHERE ORDER_REF IN (V_ORDER_REF);

begin

        v_header1 :=
                'SECOND (2nd) highest Order Total Amount ' || TO_CHAR(SYSDATE,'DD-MON-YYYY');
        
        DBMS_OUTPUT.PUT_LINE(v_header1); 

        for k in c3 loop    
          V_ORDER_REF := 'PO' || K.ORDER_REF;
              DBMS_OUTPUT.PUT_LINE('Order Reference : '|| K.ORDER_REF	);
              DBMS_OUTPUT.PUT_LINE('Order Date : '|| TO_CHAR(TO_DATE(K.ORD_PERIOD,'DD-MON-YYYY'), 'Month DD, YYYY') );
              DBMS_OUTPUT.PUT_LINE('Supplier Name : '||  UPPER(K.SUPP_NAME));
              DBMS_OUTPUT.PUT_LINE('Order Total Amount : '||  TO_CHAR(K.ORD_TOT_AMT,'FM9G999G999G999G990D00'));
              DBMS_OUTPUT.PUT_LINE('Order Status : '||   K.ORD_STS);
               DBMS_OUTPUT.PUT_LINE('Invoice References : ');
          
          for j in C4 loop
            
            DBMS_OUTPUT.PUT_LINE(j.INVOICE_REFERENCE || '|');
                               
          end loop;

        end loop;       


END GEN_REPORT;

END Second_highest_ord;
/

--exec Second_highest_ord.GEN_REPORT;