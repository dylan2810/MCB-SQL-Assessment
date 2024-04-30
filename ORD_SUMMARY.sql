SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE Summary_Orders AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
    PROCEDURE GEN_REPORT;


END Summary_Orders;
/


CREATE OR REPLACE PACKAGE BODY Summary_Orders AS

PROCEDURE GEN_REPORT
IS


        v_out_line      varchar2(30000);
        v_header1               varchar2(200);
        v_header                varchar2(200);
      

        cursor c3 is
                   SELECT REPLACE(ORD.ORDER_REF,'PO') AS ORDER_REF,
TO_CHAR(ORD.ORDER_DATE,'MON-YYYY') ORD_PERIOD, INITCAP(ORD.SUPPLIER_NAME) AS SUPP_NAME,
TO_CHAR(SUM(ORD.ORDER_TOTAL_AMOUNT),'FM9G999G999G999G990D00') AS ORD_TOT_AMT,
ORD.ORDER_STATUS AS ORD_STS,
INV.INVOICE_REFERENCE AS INV_REF,
TO_CHAR(INV.INVOICE_AMOUNT,'FM9G999G999G999G990D00') AS INV_TOT_AMT
, DECODE(INV.INVOICE_STATUS, 'Paid', 'OK',
'Pending','To follow up',
' ', 'To verify') AS INV_STS
FROM XXBCM_ORDER_TBL ORD
, XXBCM_INVOICE_TBL INV
WHERE ORD.ORDER_REF = INV.ORDER_REF
GROUP BY REPLACE(ORD.ORDER_REF,'PO'),ORD.ORDER_DATE,
ORD.SUPPLIER_NAME,
ORD.ORDER_STATUS,
INV.INVOICE_REFERENCE,
INV.INVOICE_AMOUNT,
INV.INVOICE_STATUS;               

begin

        v_header1 :=
                'ORDER SUMMURY ' || TO_CHAR(SYSDATE,'DD-MON-YYYY');
      v_header :='Order Reference|Order Period|Supplier Name|Order Total Amount|Order Status|Invoice Reference|Invoice Total Amount|Status';

        
        DBMS_OUTPUT.PUT_LINE(v_header1); 
        DBMS_OUTPUT.PUT_LINE(v_header);

        for k in c3 loop    

            v_out_line:=K.ORDER_REF|| '|' || K.ORD_PERIOD|| '|' || K.SUPP_NAME|| '|' || K.ORD_TOT_AMT|| '|' || K.ORD_STS|| '|' || K.INV_REF|| '|' || K.INV_TOT_AMT|| '|' || K.INV_STS;
              
              
              DBMS_OUTPUT.PUT_LINE(v_out_line);

        end loop;       


END GEN_REPORT;

END Summary_Orders;
/

--exec Summary_Orders.GEN_REPORT;